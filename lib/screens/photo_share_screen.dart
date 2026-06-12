import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';

/// Lets the user take a photo with the camera, preview it (retaking if
/// needed), and share it through the OS share sheet - e.g. to send it by
/// email, by picking Mail and entering a recipient there.
class PhotoShareScreen extends StatefulWidget {
  const PhotoShareScreen({super.key});

  @override
  State<PhotoShareScreen> createState() => _PhotoShareScreenState();
}

class _PhotoShareScreenState extends State<PhotoShareScreen> {
  final _picker = ImagePicker();

  XFile? _photo;
  bool _isCapturing = false;
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    _capture();
  }

  Future<void> _capture() async {
    setState(() => _isCapturing = true);
    try {
      final photo = await _picker.pickImage(source: ImageSource.camera);
      if (!mounted) return;
      if (photo != null) {
        setState(() => _photo = photo);
      } else if (_photo == null) {
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  Future<void> _share() async {
    final photo = _photo;
    if (photo == null) return;

    final l10n = AppLocalizations.of(context)!;
    setState(() => _isSharing = true);
    try {
      await SharePlus.instance.share(
        ShareParams(files: [XFile(photo.path)], subject: l10n.photoShareSubject),
      );
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final photo = _photo;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.photoShareTitle)),
      body: SafeArea(
        child: photo == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: Image.file(File(photo.path), fit: BoxFit.contain),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isCapturing || _isSharing
                                ? null
                                : _capture,
                            icon: const Icon(Icons.refresh),
                            label: Text(l10n.photoRetakeButton),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: ctaColors(context).background,
                              foregroundColor: ctaColors(context).foreground,
                            ),
                            onPressed: _isCapturing || _isSharing
                                ? null
                                : _share,
                            icon: _isSharing
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: ctaColors(context).foreground,
                                    ),
                                  )
                                : const Icon(Icons.share),
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
