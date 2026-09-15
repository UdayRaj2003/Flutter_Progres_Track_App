import 'authenticated_user.dart';

class AuthSession {
  final String accessToken;
  final String refreshToken;
  final List<AuthenticatedUser> users;

  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.users,
  });
}