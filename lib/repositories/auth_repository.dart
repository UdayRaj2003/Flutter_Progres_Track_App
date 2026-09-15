import '../models/auth/auth_session.dart';
import '../models/auth/send_otp_response.dart';

abstract interface class AuthRepository {
  Future<SendOtpResponse> sendOtp({
    required String phoneNumber,
  });

  Future<AuthSession> verifyOtp({
    required String phoneNumber,
    required String otp,
  });

  Future<bool> hasSession();

  Future<void> logout();
}
class OtpMaxAttemptsException implements Exception {
  final String message;
  OtpMaxAttemptsException(this.message);
}

class InvalidOtpException implements Exception {
  final String message;
  InvalidOtpException(this.message);
}