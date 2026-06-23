import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/office.dart';
import '../services/location_service.dart';
import '../services/office_service.dart';
import '../theme/app_colors.dart';
import '../widgets/address_search_sheet.dart';
import '../widgets/office_card.dart';
import '../widgets/privacy_info_button.dart';

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
  const HomeScreen({super.key, this.onSubScreenChanged});

  /// Called whenever the locator moves between the hero and any sub-screen
  /// (results, loading, errors, permission prompts), so [RootScreen] can
  /// swap its shared app bar's leading icon for a back button.
  final ValueChanged<bool>? onSubScreenChanged;

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  static const _pageSize = 10;

  final _locationService = LocationService();
  final _officeService = OfficeService();
  final _scrollController = ScrollController();
  final _filterController = TextEditingController();

  _LocatorStatus _status = _LocatorStatus.idle;
  List<OfficeWithDistance> _allOffices = [];
  OfficeType _selectedType = OfficeType.office;
  int _visibleCount = _pageSize;
  String? _userLocationText;
  String _filterQuery = '';
  Future<List<Office>>? _officesFuture;

  /// [_allOffices] narrowed down by the free-text filter, preserving their
  /// existing order (by distance, or as loaded).
  List<OfficeWithDistance> get _textFilteredOffices =>
      _officeService.filterByText(_allOffices, _filterQuery);

  /// [_textFilteredOffices] further narrowed down to the selected office
  /// type, for display.
  List<OfficeWithDistance> get _filteredOffices => _textFilteredOffices
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
    _filterController.dispose();
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

  /// Builds a segmented-button label with an inline result-count pill, laid
  /// out as a normal Row so it can't overflow into a neighboring segment
  /// (unlike [Badge], which positions itself with an absolute offset).
  ///
  /// The pill is tinted from the ambient text color rather than a fixed
  /// theme color, so it automatically matches whatever foreground Flutter
  /// resolves for this segment (selected vs. unselected, light vs. dark).
  Widget _segmentLabel(String text, int count) {
    final foreground =
        DefaultTextStyle.of(context).style.color ??
        Theme.of(context).colorScheme.onSurface;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text),
        if (count > 0) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: foreground.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$count',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: foreground,
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _formatCoordinates(double lat, double lng) =>
      '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';

  Future<void> _findNearestOffices() async {
    setState(() => _status = _LocatorStatus.loading);
    widget.onSubScreenChanged?.call(true);

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
        await _showResultsFor(
          lastKnown.latitude,
          lastKnown.longitude,
          officesFuture,
        );
        hasResults = true;
      }
    } catch (_) {
      // Best-effort only; fall through to a fresh fix below.
    }

    try {
      final position = await _locationService.getCurrentPosition();
      await _showResultsFor(position.latitude, position.longitude, officesFuture);

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

  /// Opens the address search sheet and, if the user finds an address,
  /// shows the nearest offices to it - an alternative to GPS location.
  Future<void> _searchByAddress() async {
    final result = await showModalBottomSheet<AddressSearchResult>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => const AddressSearchSheet(),
    );
    if (result == null || !mounted) return;

    setState(() => _status = _LocatorStatus.loading);
    widget.onSubScreenChanged?.call(true);
    final officesFuture = _officesFuture ??= _officeService.loadOffices();
    await _showResultsFor(
      result.latitude,
      result.longitude,
      officesFuture,
      locationText: result.address,
    );
  }

  /// Clears the current results and returns to the hero, so the user can
  /// search again by GPS or a different address.
  void _changeLocation() {
    setState(() {
      _status = _LocatorStatus.idle;
      _allOffices = [];
      _visibleCount = _pageSize;
      _userLocationText = null;
      _filterController.clear();
      _filterQuery = '';
    });
    widget.onSubScreenChanged?.call(false);
  }

  /// Returns to the hero screen. Called by [RootScreen] when the user taps
  /// the back button shown in the shared app bar while a sub-screen (results,
  /// loading, errors, ...) is visible.
  void goToHero() => _changeLocation();

  /// Computes and displays the nearest offices to (lat, lng), using the
  /// (cached) [officesFuture]. Shows [locationText] as the user's location,
  /// falling back to the raw coordinates.
  Future<void> _showResultsFor(
    double lat,
    double lng,
    Future<List<Office>> officesFuture, {
    String? locationText,
  }) async {
    final offices = await officesFuture;
    final allOffices = _officeService.nearestOffices(
      offices: offices,
      userLat: lat,
      userLng: lng,
    );

    if (!mounted) return;
    setState(() {
      _userLocationText = locationText ?? _formatCoordinates(lat, lng);
      _filterController.clear();
      _filterQuery = '';
      _allOffices = allOffices;
      _visibleCount = _pageSize;
      _status = _LocatorStatus.results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopScope(
      // From any non-idle state (results, errors, ...), the back button
      // should return to the hero screen first instead of leaving the app.
      canPop: _status == _LocatorStatus.idle,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _changeLocation();
      },
      child: Scaffold(
        // The address search sheet's text field grabs focus on open, which
        // would otherwise push this screen's whole body (incl. the hero) up
        // to avoid the keyboard. The sheet handles its own keyboard inset.
        resizeToAvoidBottomInset: false,
        body: SafeArea(child: _buildContent(l10n)),
      ),
    );
  }

  Widget _buildHero(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 96,
              height: 96,
              child: Stack(
                children: [
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      ctaColors(context).background,
                      BlendMode.srcIn,
                    ),
                    child: Image.asset('assets/icon/icon_pin_mask.png'),
                  ),
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      ctaColors(context).foreground,
                      BlendMode.srcIn,
                    ),
                    child: Image.asset('assets/icon/icon_plus_mask.png'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.appTagline,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Balances the PrivacyInfoButton on the other side, so the
                // CTA itself stays centered (matching the address button
                // below) while the privacy button sits beside it.
                const SizedBox(width: 48),
                const SizedBox(width: 4),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: ctaColors(context).background,
                    foregroundColor: ctaColors(context).foreground,
                  ),
                  onPressed: _findNearestOffices,
                  icon: const Icon(Icons.my_location),
                  label: Text(l10n.findNearestOfficeButton),
                ),
                const SizedBox(width: 4),
                const PrivacyInfoButton(),
              ],
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _searchByAddress,
              icon: const Icon(Icons.edit_location_alt_outlined),
              label: Text(l10n.searchByAddressButton),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(AppLocalizations l10n) {
    switch (_status) {
      case _LocatorStatus.idle:
        return _buildHero(l10n);

      case _LocatorStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case _LocatorStatus.results:
        final textFilteredOffices = _textFilteredOffices;
        final filteredOffices = _filteredOffices;
        final visibleOffices = filteredOffices.take(_visibleCount).toList();
        final officeCount = textFilteredOffices
            .where((o) => o.office.type == OfficeType.office)
            .length;
        final mailboxCount = textFilteredOffices
            .where((o) => o.office.type == OfficeType.mailbox)
            .length;
        return Column(
          children: [
            if (_userLocationText != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
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
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: TextField(
                controller: _filterController,
                onChanged: (value) => setState(() {
                  _filterQuery = value;
                  _visibleCount = _pageSize;
                }),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: l10n.resultsFilterHint,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _filterQuery.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() {
                            _filterController.clear();
                            _filterQuery = '';
                            _visibleCount = _pageSize;
                          }),
                        ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SegmentedButton<OfficeType>(
                segments: [
                  ButtonSegment(
                    value: OfficeType.office,
                    icon: const Icon(Icons.business_outlined),
                    label: _segmentLabel(
                      l10n.officeTypeFilterOffices,
                      officeCount,
                    ),
                  ),
                  ButtonSegment(
                    value: OfficeType.mailbox,
                    icon: const Icon(Icons.mail_outline),
                    label: _segmentLabel(
                      l10n.officeTypeFilterMailboxes,
                      mailboxCount,
                    ),
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
              child: filteredOffices.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          l10n.resultsFilterNoMatches,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: visibleOffices.length,
                      itemBuilder: (context, index) {
                        return OfficeCard(
                          officeWithDistance: visibleOffices[index],
                        );
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
