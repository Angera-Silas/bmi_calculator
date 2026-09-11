import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import 'session_provider.dart';

/// Tracks the in-flight state of auth operations.
class AuthState {
  const AuthState({this.isBusy = false, this.error});

  final bool isBusy;
  final String? error;

  bool get hasError => error != null;

  AuthState copyWith({bool? isBusy, String? error}) => AuthState(
        isBusy: isBusy ?? this.isBusy,
        error: error ?? this.error,
      );
}

/// Facade over [AuthService] for widget consumption.
///
/// Methods delegate to [AuthService] and keep [AuthState] in sync with the
/// operation lifecycle. The current user/session is exposed via
/// [sessionProvider]; this notifier only reports busy/error state so screens
/// can show spinners and error messages consistently.
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  /// Starts a local-only guest session.
  Future<bool> loginAsGuest() async {
    state = const AuthState(isBusy: true);
    try {
      await AuthService.loginAsGuest();
      ref.read(sessionProvider.notifier).refresh();
      state = const AuthState();
      return true;
    } catch (e) {
      state = AuthState(error: 'Could not start guest session.');
      return false;
    }
  }

  /// Logs in with email/password. Returns a non-null error message on failure.
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    state = const AuthState(isBusy: true);
    final error = await AuthService.login(email: email, password: password);
    ref.read(sessionProvider.notifier).refresh();
    state = AuthState(error: error);
    return error;
  }

  /// Signs in through an OAuth provider (google/apple/facebook/etc).
  Future<String?> loginWithProvider(String provider) async {
    state = const AuthState(isBusy: true);
    final error = await AuthService.loginWithProvider(provider);
    ref.read(sessionProvider.notifier).refresh();
    state = AuthState(error: error);
    return error;
  }

  /// Creates a Firebase account. Returns a non-null error message on failure.
  Future<String?> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    state = const AuthState(isBusy: true);
    final error = await AuthService.register(
      name: name,
      email: email,
      phone: phone,
      password: password,
    );
    ref.read(sessionProvider.notifier).refresh();
    state = AuthState(error: error);
    return error;
  }

  /// Sends a password-reset email. Returns a non-null error on failure.
  Future<String?> sendPasswordReset(String email) async {
    state = const AuthState(isBusy: true);
    final error = await AuthService.sendPasswordReset(email);
    state = AuthState(error: error);
    return error;
  }

  /// Signs out / clears the session and navigates to /login.
  Future<void> logout() async {
    state = const AuthState(isBusy: true);
    await AuthService.logout();
    ref.read(sessionProvider.notifier).clear();
    state = const AuthState();
  }

  /// Deletes the account + all local data. Returns a non-null error on failure.
  Future<String?> deleteAccount() async {
    state = const AuthState(isBusy: true);
    final error = await AuthService.deleteAccount();
    ref.read(sessionProvider.notifier).refresh();
    state = AuthState(error: error);
    return error;
  }
}

final authProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
