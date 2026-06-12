import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/office.dart';
import '../services/auth_service.dart';
import '../services/location_service.dart';
import '../services/office_service.dart';
import '../widgets/language_selector.dart';
import '../widgets/office_card.dart';

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
  final _authService = AuthService();
  final _locationService = LocationService();
  final _officeService = OfficeService();

  _LocatorStatus _status = _LocatorStatus.idle;
  List<OfficeWithDistance> _nearestOffices = [];

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
      final nearest = _officeService.nearestOffices(
        offices: offices,
        userLat: position.latitude,
        userLng: position.longitude,
      );

      setState(() {
        _nearestOffices = nearest;
        _status = _LocatorStatus.results;
      });
    } catch (_) {
      setState(() => _status = _LocatorStatus.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          const LanguageSelector(),
          IconButton(
            onPressed: _authService.signOut,
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
                    onPressed: _status == _LocatorStatus.loading
                        ? null
                        : _findNearestOffices,
                    icon: const Icon(Icons.my_location),
                    label: Text(l10n.findNearestOfficeButton),
                  ),
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
        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          itemCount: _nearestOffices.length,
          itemBuilder: (context, index) {
            return OfficeCard(officeWithDistance: _nearestOffices[index]);
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
