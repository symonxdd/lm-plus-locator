import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';

/// Recipient for scanned documents. Routed through a forwarding alias rather
/// than the real LM+ inbox so the address isn't exposed in this public repo.
const _documentRecipientEmail = 'lmplus-demo@symon.me';

/// Lets the user take a photo of a document with the camera, preview it
/// (retaking if needed), and send it straight into the device's Mail
/// compose screen - pre-addressed, subject filled in, photo already
/// attached - skipping the OS share sheet chooser entirely.
class PhotoShareScreen extends StatefulWidget {
  const PhotoShareScreen({super.key, this.onPhotoPreviewChanged});

  /// Called whenever a captured photo starts or stops being previewed (i.e.
  /// the Retake/Send buttons appear or disappear), so [RootScreen] can hide
  /// its mascot watermark while those buttons occupy its corner.
  final ValueChanged<bool>? onPhotoPreviewChanged;

  @override
  State<PhotoShareScreen> createState() => _PhotoShareScreenState();
}

class _PhotoShareScreenState extends State<PhotoShareScreen> {
  final _picker = ImagePicker();

  XFile? _photo;
  bool _isCapturing = false;
  bool _isSharing = false;

  Future<void> _capture() async {
    setState(() => _isCapturing = true);
    try {
      final photo = await _picker.pickImage(source: ImageSource.camera);
      if (!mounted) return;
      if (photo != null) {
        setState(() => _photo = photo);
        widget.onPhotoPreviewChanged?.call(true);
      }
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  Future<void> _send() async {
    final photo = _photo;
    if (photo == null) return;

    final l10n = AppLocalizations.of(context)!;
    setState(() => _isSharing = true);
    try {
      final email = Email(recipients: [_documentRecipientEmail], subject: l10n.photoShareSubject, attachmentPaths: [photo.path]);
      await FlutterEmailSender.send(email);
      if (mounted) {
        setState(() => _photo = null);
        widget.onPhotoPreviewChanged?.call(false);
        return;
      }
    } on FlutterEmailSenderException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.genericErrorMessage)));
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final photo = _photo;
    return Scaffold(
      body: SafeArea(
        child: photo == null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.photoShareTagline,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(backgroundColor: ctaColors(context).background, foregroundColor: ctaColors(context).foreground),
                        onPressed: _isCapturing ? null : _capture,
                        icon: _isCapturing ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: ctaColors(context).foreground)) : const Icon(Icons.camera_alt),
                        label: Text(l10n.photoShareTooltip),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.photoShareExperimentalNotice,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.outline),
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                children: [
                  Expanded(child: Image.file(File(photo.path), fit: BoxFit.contain)),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(onPressed: _isCapturing || _isSharing ? null : _capture, icon: const Icon(Icons.refresh), label: Text(l10n.photoRetakeButton)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(backgroundColor: ctaColors(context).background, foregroundColor: ctaColors(context).foreground),
                            onPressed: _isCapturing || _isSharing ? null : _send,
                            icon: _isSharing ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: ctaColors(context).foreground)) : const Icon(Icons.send),
                            label: Text(l10n.photoShareButton),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
