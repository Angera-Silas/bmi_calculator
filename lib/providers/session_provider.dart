import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/session_service.dart';

/// Immutable snapshot of the current user session.
///
/// This is the Riverpod-idiomatic surface over [SessionService]. The service
/// remains the single source of truth for "who is the current user"; the
/// notifier mirrors its state so widgets can react to session changes without
/// touching static state directly.
class SessionState {
  const SessionState({
    this.userId,
    this.isGuest = false,
    this.userEmail,
  });

  final String? userId;
  final bool isGuest;
  final String? userEmail;

  bool get hasSession => userId != null;
  bool get isAuthenticated => userId != null && !isGuest;

  /// Mirrors the current [SessionService] state.
  static SessionState fromService() => SessionState(
        userId: SessionService.userId,
        isGuest: SessionService.isGuest,
        userEmail: SessionService.userEmail,
      );
}

class SessionNotifier extends Notifier<SessionState> {
  @override
  SessionState build() => SessionState.fromService();

  Future<void> startGuest() async {
    await SessionService.startGuest();
    state = SessionState.fromService();
  }

  Future<void> startUser({
    required String uid,
    required String name,
    required String email,
    String? phone,
  }) async {
    await SessionService.startUser(
      uid: uid,
      name: name,
      email: email,
      phone: phone,
    );
    state = SessionState.fromService();
  }

  Future<void> clear() async {
    await SessionService.clear();
    state = SessionState.fromService();
  }

  /// Re-reads [SessionService] into state. Call after an auth operation that
  /// changes the underlying session without going through this notifier.
  void refresh() => state = SessionState.fromService();
}

final sessionProvider =
    NotifierProvider<SessionNotifier, SessionState>(SessionNotifier.new);
