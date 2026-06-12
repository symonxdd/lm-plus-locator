import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../models/head_office.dart';
import '../models/office.dart';
import '../services/auth_service.dart';
import '../services/location_service.dart';
import '../services/office_service.dart';
import '../theme/app_colors.dart';
import '../widgets/language_selector.dart';
import '../widgets/office_card.dart';
import '../widgets/theme_selector.dart';

enum _LocatorStatus {
  idle,
  loading,
  results,
  permissionDenied,
  permissionPermanentlyDenied,
  serviceDisabled,
  error,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _pageSize = 10;

  final _authService = AuthService();
  final _locationService = LocationService();
  final _officeService = OfficeService();
  final _scrollController = ScrollController();

  _LocatorStatus _status = _LocatorStatus.idle;
  List<OfficeWithDistance> _allOffices = [];
  int _visibleCount = _pageSize;
  String? _userLocationText;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_visibleCount >= _allOffices.length) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      setState(() {
        _visibleCount = (_visibleCount + _pageSize).clamp(
          0,
          _allOffices.length,
        );
      });
    }
  }

  String _formatCoordinates(Position position) =>
      '${position.latitude.toStringAsFixed(4)}, '
      '${position.longitude.toStringAsFixed(4)}';

  Future<void> _findNearestOffices() async {
    setState(() => _status = _LocatorStatus.loading);

    try {
      final permissionStatus = await _locationService.checkPermission();

      switch (permissionStatus) {
        case LocationPermissionStatus.denied:
          setState(() => _status = _LocatorStatus.permissionDenied);
          return;
        case LocationPermissionStatus.permanentlyDenied:
          setState(() => _status = _LocatorStatus.permissionPermanentlyDenied);
          return;
        case LocationPermissionStatus.serviceDisabled:
          setState(() => _status = _LocatorStatus.serviceDisabled);
          return;
        case LocationPermissionStatus.granted:
          break;
      }

      final position = await _locationService.getCurrentPosition();
      final offices = await _officeService.loadOffices();
      final allOffices = _officeService.nearestOffices(
        offices: offices,
        userLat: position.latitude,
        userLng: position.longitude,
      );

      setState(() {
        _userLocationText = _formatCoordinates(position);
        _allOffices = allOffices;
        _visibleCount = _pageSize;
        _status = _LocatorStatus.results;
      });

      final address = await _locationService.reverseGeocode(
        position.latitude,
        position.longitude,
      );
      if (address != null && mounted) {
        setState(() => _userLocationText = address);
      }
    } catch (_) {
      setState(() => _status = _LocatorStatus.error);
    }
  }

  Future<void> _confirmLogout() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logoutConfirmTitle),
        content: Text(l10n.logoutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.logoutTooltip),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _authService.signOut();
    }
  }

  Future<void> _showHeadOfficeInfo() async {
    final l10n = AppLocalizations.of(context)!;
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.headOfficeTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  HeadOffice.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(HeadOffice.addressLine),
                Text(
                  '${HeadOffice.postalCode} ${HeadOffice.city}, '
                  '${l10n.countryBelgium}',
                ),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.phone_outlined),
                  title: Text(HeadOffice.phone),
                  onTap: () => launchUrl(
                    Uri(
                      scheme: 'tel',
                      path: HeadOffice.phone.replaceAll(' ', ''),
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.email_outlined),
                  title: Text(HeadOffice.email),
                  onTap: () => launchUrl(
                    Uri(scheme: 'mailto', path: HeadOffice.email),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset('assets/icon/icon_foreground.png'),
        ),
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            onPressed: _showHeadOfficeInfo,
            icon: const Icon(Icons.info_outline),
            tooltip: l10n.headOfficeTooltip,
          ),
          const ThemeSelector(),
          const LanguageSelector(),
          IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: ctaColors(context).background,
              foregroundColor: ctaColors(context).foreground,
            ),
            onPressed: _confirmLogout,
            icon: const Icon(Icons.logout),
            tooltip: l10n.logoutTooltip,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.locationPrivacyNotice,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: ctaColors(context).background,
                      foregroundColor: ctaColors(context).foreground,
                    ),
                    onPressed: _status == _LocatorStatus.loading
                        ? null
                        : _findNearestOffices,
                    icon: const Icon(Icons.my_location),
                    label: Text(l10n.findNearestOfficeButton),
                  ),
                  if (_userLocationText != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.my_location,
                          size: 14,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            l10n.yourLocationLabel(_userLocationText!),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Expanded(child: _buildContent(l10n)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(AppLocalizations l10n) {
    switch (_status) {
      case _LocatorStatus.idle:
        return const SizedBox.shrink();

      case _LocatorStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case _LocatorStatus.results:
        final visibleOffices = _allOffices.take(_visibleCount).toList();
        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          itemCount: visibleOffices.length,
          itemBuilder: (context, index) {
            return OfficeCard(officeWithDistance: visibleOffices[index]);
          },
        );

      case _LocatorStatus.permissionDenied:
      case _LocatorStatus.permissionPermanentlyDenied:
        return _InfoMessage(
          text: l10n.locationPermissionDenied,
          actionLabel: l10n.openSettingsButton,
          onAction: _locationService.openAppSettings,
        );

      case _LocatorStatus.serviceDisabled:
        return _InfoMessage(
          text: l10n.locationServiceDisabled,
          actionLabel: l10n.openLocationSettingsButton,
          onAction: _locationService.openLocationSettings,
        );

      case _LocatorStatus.error:
        return _InfoMessage(text: l10n.genericErrorMessage);
    }
  }
}

/// A centered, non-blocking informational message with an optional action
/// button (e.g. "Open instellingen").
class _InfoMessage extends StatelessWidget {
  const _InfoMessage({required this.text, this.actionLabel, this.onAction});

  final String text;
  final String? actionLabel;
  final Future<bool> Function()? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off,
              size: 40,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 12),
            Text(text, textAlign: TextAlign.center),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
