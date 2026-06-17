import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/office.dart';
import '../services/favorites_service.dart';
import '../services/office_service.dart';
import '../widgets/account_sheet.dart';
import '../widgets/office_card.dart';

/// Tab showing the user's saved offices, loaded from [FavoritesService].
///
/// Offices are matched against the bundled asset list by their lat/lng key,
/// so no network request is needed to display them. Distance is omitted
/// because there is no active location search in this view.
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // Loaded once and kept alive for the lifetime of the IndexedStack tab.
  final Future<List<Office>> _officesFuture = OfficeService().loadOffices();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        const _SyncNotice(),
        Expanded(
          child: ValueListenableBuilder<Set<String>>(
            valueListenable: FavoritesService.instance.favorites,
            builder: (context, favoriteKeys, _) {
              if (favoriteKeys.isEmpty) {
                return _EmptyState(l10n: l10n);
              }

              return FutureBuilder<List<Office>>(
                future: _officesFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final saved = snapshot.data!
                      .where((o) => favoriteKeys.contains('${o.lat},${o.lng}'))
                      .map((o) => OfficeWithDistance(office: o))
                      .toList();

                  if (saved.isEmpty) {
                    return _EmptyState(l10n: l10n);
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: saved.length,
                    itemBuilder: (context, index) =>
                        OfficeCard(officeWithDistance: saved[index]),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SyncNotice extends StatelessWidget {
  const _SyncNotice();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: FirebaseAuth.instance.currentUser,
      builder: (context, snapshot) {
        final isSignedIn = snapshot.data != null;

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: isSignedIn
                    ? null
                    : () => showModalBottomSheet<bool>(
                          context: context,
                          showDragHandle: true,
                          isScrollControlled: true,
                          builder: (_) => const AccountSheet(),
                        ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSignedIn ? Icons.cloud_done : Icons.cloud_off,
                        size: 13,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        isSignedIn
                            ? l10n.favoritesSyncedNotice
                            : l10n.favoritesSignInToSync,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (!isSignedIn) ...[
                        const SizedBox(width: 2),
                        Icon(
                          Icons.chevron_right,
                          size: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bookmark_outline,
              size: 48,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.favoritesEmptyTitle,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.favoritesEmptySubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
