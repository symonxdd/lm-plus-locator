import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the user's saved offices, persisting locally when signed out and
/// syncing to Firestore when signed in.
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

  /// Call once from [main] after Firebase.initializeApp completes.
  Future<void> initialize() async {
    favorites.value = await _loadLocal();
    _authSub = FirebaseAuth.instance
        .authStateChanges()
        .listen(_onAuthStateChanged);
  }

  void dispose() {
    _authSub?.cancel();
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
    await _persist(updated);
  }

  bool isFavorite(String key) => favorites.value.contains(key);

  // ---------------------------------------------------------------------------
  // Auth state
  // ---------------------------------------------------------------------------

  Future<void> _onAuthStateChanged(User? user) async {
    if (user == null) {
      // Signed out: persist whatever is currently in memory locally so
      // favorites survive logout without losing any unsaved changes.
      await _saveLocal(favorites.value);
      return;
    }

    // Signed in: load cloud favorites, merge with local ones (additive only —
    // never delete remote favorites that may exist from another device), then
    // write the merged set back to both stores.
    final remote = await _loadFirestore(user.uid);
    final merged = {...favorites.value, ...remote};
    favorites.value = merged;
    await _persist(merged, uid: user.uid);
  }

  // ---------------------------------------------------------------------------
  // Persistence helpers
  // ---------------------------------------------------------------------------

  Future<void> _persist(Set<String> keys, {String? uid}) async {
    await _saveLocal(keys);
    final effectiveUid = uid ?? FirebaseAuth.instance.currentUser?.uid;
    if (effectiveUid != null) {
      await _saveFirestore(effectiveUid, keys);
    }
  }

  Future<Set<String>> _loadLocal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_prefsKey)?.toSet() ?? {};
  }

  Future<void> _saveLocal(Set<String> keys) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, keys.toList());
  }

  Future<Set<String>> _loadFirestore(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection(_collection)
          .doc(uid)
          .get();
      final raw = doc.data()?[_field];
      if (raw is List) return raw.cast<String>().toSet();
    } catch (_) {
      // Network failure — local copy remains the source of truth.
    }
    return {};
  }

  Future<void> _saveFirestore(String uid, Set<String> keys) async {
    try {
      await FirebaseFirestore.instance
          .collection(_collection)
          .doc(uid)
          .set({_field: keys.toList()});
    } catch (_) {
      // Best-effort: local copy is authoritative if the write fails.
    }
  }
}
