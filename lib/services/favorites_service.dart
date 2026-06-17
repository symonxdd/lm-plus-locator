import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the user's saved offices.
///
/// Signed out: favorites are stored in SharedPreferences (device-local).
/// Signed in: favorites are stored in Firestore. The Firestore SDK caches
/// reads and writes locally and syncs them automatically when connectivity
/// is restored, so add/remove operations made while offline are queued and
/// applied correctly instead of being lost or overwritten.
///
/// Firestore structure:
///   collection: userFavorites
///   document:   {uid}          ← one document per user, keyed by Firebase UID
///   fields:     keys: [...]    ← list of office keys ("lat,lng" strings)
///
/// Access via [FavoritesService.instance]. Call [initialize] once from
/// [main] after Firebase is ready.
class FavoritesService {
  FavoritesService._();
  static final instance = FavoritesService._();

  static const _prefsKey = 'local_favorites';
  static const _collection = 'userFavorites';
  static const _field = 'keys';

  /// Reactive set of saved office keys. Listen with [ValueListenableBuilder].
  final favorites = ValueNotifier<Set<String>>({});

  StreamSubscription<User?>? _authSub;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _firestoreSub;

  /// Call once from [main] after Firebase.initializeApp completes.
  Future<void> initialize() async {
    favorites.value = await _loadLocal();
    _authSub = FirebaseAuth.instance
        .authStateChanges()
        .listen(_onAuthStateChanged);
  }

  void dispose() {
    _authSub?.cancel();
    _firestoreSub?.cancel();
    favorites.dispose();
  }

  /// Adds [key] to saved offices if absent, removes it if present.
  Future<void> toggle(String key) async {
    final updated = Set<String>.from(favorites.value);
    if (updated.contains(key)) {
      updated.remove(key);
    } else {
      updated.add(key);
    }
    favorites.value = updated;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      _writeFirestore(uid, updated);
    } else {
      await _saveLocal(updated);
    }
  }

  bool isFavorite(String key) => favorites.value.contains(key);

  // ---------------------------------------------------------------------------
  // Auth state
  // ---------------------------------------------------------------------------

  Future<void> _onAuthStateChanged(User? user) async {
    await _firestoreSub?.cancel();
    _firestoreSub = null;

    if (user == null) {
      // Signed out: snapshot whatever is currently in memory locally so
      // favorites survive logout without losing any unsaved changes.
      await _saveLocal(favorites.value);
      return;
    }

    // Signed in: if there are favorites saved locally from being signed out,
    // merge them into Firestore once (additive only, so we never delete
    // favorites that may already exist there from another device).
    final local = await _loadLocal();
    if (local.isNotEmpty) {
      var remote = <String>{};
      try {
        final doc = await FirebaseFirestore.instance
            .collection(_collection)
            .doc(user.uid)
            .get();
        final raw = doc.data()?[_field];
        if (raw is List) remote = raw.cast<String>().toSet();
      } catch (_) {
        // Offline with no cached doc yet — proceed with local only.
      }
      final merged = {...local, ...remote};
      favorites.value = merged;
      _writeFirestore(user.uid, merged);
      await _saveLocal({});
    }

    // From here on, Firestore is the source of truth. The SDK serves this
    // stream from its local cache when offline and reconciles automatically
    // once connectivity returns, so later add/remove calls behave correctly
    // even if made entirely offline.
    _firestoreSub = FirebaseFirestore.instance
        .collection(_collection)
        .doc(user.uid)
        .snapshots()
        .listen((doc) {
          final raw = doc.data()?[_field];
          favorites.value = raw is List ? raw.cast<String>().toSet() : {};
        });
  }

  // ---------------------------------------------------------------------------
  // Persistence helpers
  // ---------------------------------------------------------------------------

  Future<Set<String>> _loadLocal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_prefsKey)?.toSet() ?? {};
  }

  Future<void> _saveLocal(Set<String> keys) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, keys.toList());
  }

  /// Fire-and-forget: the Firestore SDK queues this write locally when
  /// offline and syncs it once connectivity is restored.
  void _writeFirestore(String uid, Set<String> keys) {
    FirebaseFirestore.instance
        .collection(_collection)
        .doc(uid)
        .set({_field: keys.toList()})
        .catchError((_) {});
  }
}
