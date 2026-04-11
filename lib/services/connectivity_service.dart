import 'package:connectivity_plus/connectivity_plus.dart';

/// Wraps [connectivity_plus] to expose a simple online/offline API.
///
/// Used by [SyncService] to trigger background sync when the device
/// comes back online after being offline.
class ConnectivityService {
  static final Connectivity _connectivity = Connectivity();

  /// One-shot check — returns true if any non-none connection is detected.
  static Future<bool> get isOnline async {
    final results = await _connectivity.checkConnectivity();
    return _hasConnection(results);
  }

  /// Stream that emits `true` when online, `false` when offline.
  static Stream<bool> get onlineStream =>
      _connectivity.onConnectivityChanged.map(_hasConnection);

  static bool _hasConnection(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);
}
