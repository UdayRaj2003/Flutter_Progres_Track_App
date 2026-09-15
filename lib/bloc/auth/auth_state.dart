import '../../models/auth/auth_session.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthChecking extends AuthState {}

class AuthLoading extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthOtpSent extends AuthState {
  final String phoneNumber;
  final String message;

  AuthOtpSent({
    required this.phoneNumber,
    required this.message,
  });
}

class AuthOtpLocked extends AuthState {
  final DateTime lockedUntil;

  AuthOtpLocked(this.lockedUntil);
}
class AuthAuthenticated extends AuthState {
  final AuthSession session;

  AuthAuthenticated(this.session);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}