import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../models/address_suggestion.dart';
import '../services/location_service.dart';
import '../theme/app_colors.dart';

/// The result of a successful address search.
class AddressSearchResult {
  const AddressSearchResult(this.latitude, this.longitude, this.address);

  final double latitude;
  final double longitude;
  final String address;
}

/// Bottom sheet that lets the user type an address and resolves it to
/// coordinates, as an alternative to using the device's GPS location. Shows
/// live suggestions as the user types.
class AddressSearchSheet extends StatefulWidget {
  const AddressSearchSheet({super.key});

  @override
  State<AddressSearchSheet> createState() => _AddressSearchSheetState();
}

class _AddressSearchSheetState extends State<AddressSearchSheet> {
  final _controller = TextEditingController();
  final _locationService = LocationService();
  Timer? _debounce;
  List<AddressSuggestion> _suggestions = [];
  bool _isSearching = false;
  bool _notFound = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String query) {
    _debounce?.cancel();
    if (_notFound) setState(() => _notFound = false);

    final trimmed = query.trim();
    if (trimmed.length < 3) {
      setState(() => _suggestions = []);
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 200), () async {
      final suggestions = await _locationService.suggestAddresses(
        trimmed,
        languageCode: Localizations.localeOf(context).languageCode,
      );
      if (!mounted || _controller.text.trim() != trimmed) return;
      setState(() => _suggestions = suggestions);
    });
  }

  void _selectSuggestion(AddressSuggestion suggestion) {
    Navigator.of(context).pop(
      AddressSearchResult(
        suggestion.latitude,
        suggestion.longitude,
        suggestion.displayName,
      ),
    );
  }

  Future<void> _search() async {
    final address = _controller.text.trim();
    if (address.isEmpty) return;

    setState(() {
      _isSearching = true;
      _notFound = false;
    });

    final location = await _locationService.geocodeAddress(address);
    if (!mounted) return;

    if (location == null) {
      setState(() {
        _isSearching = false;
        _notFound = true;
      });
      return;
    }

    Navigator.of(context).pop(
      AddressSearchResult(location.latitude, location.longitude, address),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          0,
          24,
          24 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.addressSearchTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onChanged: _onChanged,
              onSubmitted: (_) => _search(),
              decoration: InputDecoration(
                labelText: l10n.addressInputLabel,
                prefixIcon: const Icon(Icons.search),
                errorText: _notFound ? l10n.addressNotFoundError : null,
              ),
            ),
            if (_suggestions.isNotEmpty) ...[
              const SizedBox(height: 4),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = _suggestions[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.location_on_outlined),
                      title: Text(suggestion.displayName),
                      onTap: () => _selectSuggestion(suggestion),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  ),
                  onPressed: () => launchUrl(
                    Uri.parse('https://www.openstreetmap.org/copyright'),
                    mode: LaunchMode.externalApplication,
                  ),
                  child: Text(
                    l10n.addressSuggestionsAttribution,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: ctaColors(context).background,
                  foregroundColor: ctaColors(context).foreground,
                ),
                onPressed: _isSearching ? null : _search,
                icon: _isSearching
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ctaColors(context).foreground,
                        ),
                      )
                    : const Icon(Icons.search),
                label: Text(l10n.addressSearchSubmitButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
