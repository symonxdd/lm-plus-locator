import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../l10n/app_localizations.dart';
import '../models/office.dart';
import '../services/location_service.dart';
import '../services/office_service.dart';
import '../theme/app_colors.dart';
import '../widgets/head_office_info_button.dart';
import '../widgets/office_card.dart';
import '../widgets/settings_selector.dart';
import 'photo_share_screen.dart';

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

  final _locationService = LocationService();
  final _officeService = OfficeService();
  final _scrollController = ScrollController();

  _LocatorStatus _status = _LocatorStatus.idle;
  List<OfficeWithDistance> _allOffices = [];
  OfficeType _selectedType = OfficeType.office;
  int _visibleCount = _pageSize;
  String? _userLocationText;
  Future<List<Office>>? _officesFuture;

  List<OfficeWithDistance> get _filteredOffices => _allOffices
      .where((o) => o.office.type == _selectedType)
      .toList(growable: false);

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
    final total = _filteredOffices.length;
    if (_visibleCount >= total) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      setState(() {
        _visibleCount = (_visibleCount + _pageSize).clamp(0, total);
      });
    }
  }

  String _formatCoordinates(Position position) =>
      '${position.latitude.toStringAsFixed(4)}, '
      '${position.longitude.toStringAsFixed(4)}';

  Future<void> _findNearestOffices() async {
    setState(() => _status = _LocatorStatus.loading);

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

    // Loaded once and cached: parsing the offices asset is independent of
    // the user's position, so kick it off in parallel with location lookups.
    final officesFuture = _officesFuture ??= _officeService.loadOffices();

    var hasResults = false;
    try {
      final lastKnown = await _locationService.getLastKnownPosition();
      if (lastKnown != null) {
        await _showResultsFor(lastKnown, officesFuture);
        hasResults = true;
      }
    } catch (_) {
      // Best-effort only; fall through to a fresh fix below.
    }

    try {
      final position = await _locationService.getCurrentPosition();
      await _showResultsFor(position, officesFuture);

      final address = await _locationService.reverseGeocode(
        position.latitude,
        position.longitude,
      );
      if (address != null && mounted) {
        setState(() => _userLocationText = address);
      }
    } catch (_) {
      if (!hasResults && mounted) {
        setState(() => _status = _LocatorStatus.error);
      }
    }
  }

  /// Computes and displays the nearest offices for [position], using the
  /// (cached) [officesFuture].
  Future<void> _showResultsFor(
    Position position,
    Future<List<Office>> officesFuture,
  ) async {
    final offices = await officesFuture;
    final allOffices = _officeService.nearestOffices(
      offices: offices,
      userLat: position.latitude,
      userLng: position.longitude,
    );

    if (!mounted) return;
    setState(() {
      _userLocationText = _formatCoordinates(position);
      _allOffices = allOffices;
      _visibleCount = _pageSize;
      _status = _LocatorStatus.results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              ctaColors(context).background,
              BlendMode.srcIn,
            ),
            child: Image.asset('assets/icon/icon_foreground.png'),
          ),
        ),
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const PhotoShareScreen()),
            ),
            icon: const Icon(Icons.camera_alt_outlined),
            tooltip: l10n.photoShareTooltip,
          ),
          const HeadOfficeInfoButton(),
          const SettingsSelector(),
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
                        Flexible(
                          child: Text(
                            l10n.yourLocationLabel(_userLocationText!),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
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
        final filteredOffices = _filteredOffices;
        final visibleOffices = filteredOffices.take(_visibleCount).toList();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SegmentedButton<OfficeType>(
                segments: [
                  ButtonSegment(
                    value: OfficeType.office,
                    label: Text(l10n.officeTypeFilterOffices),
                    icon: const Icon(Icons.business_outlined),
                  ),
                  ButtonSegment(
                    value: OfficeType.mailbox,
                    label: Text(l10n.officeTypeFilterMailboxes),
                    icon: const Icon(Icons.mail_outline),
                  ),
                ],
                selected: {_selectedType},
                onSelectionChanged: (selection) {
                  setState(() {
                    _selectedType = selection.first;
                    _visibleCount = _pageSize;
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: visibleOffices.length,
                itemBuilder: (context, index) {
                  return OfficeCard(officeWithDistance: visibleOffices[index]);
                },
              ),
            ),
          ],
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
