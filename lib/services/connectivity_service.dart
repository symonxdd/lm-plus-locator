import 'package:connectivity_plus/connectivity_plus.dart';

/// Wraps [Connectivity] to expose a single boolean stream that emits the
/// current online state immediately, then re-emits on every change.
class ConnectivityService {
  static final _connectivity = Connectivity();

  /// Emits `true` when at least one network interface is available,
  /// `false` when the device has no connectivity at all.
  Stream<bool> get onlineStream async* {
    final initial = await _connectivity.checkConnectivity();
    yield _isOnline(initial);
    yield* _connectivity.onConnectivityChanged.map(_isOnline);
  }

  static bool _isOnline(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);
}
