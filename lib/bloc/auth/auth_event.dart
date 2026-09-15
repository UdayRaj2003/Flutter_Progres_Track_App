sealed class AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

class SendOtp extends AuthEvent {
  final String phoneNumber;

  SendOtp(this.phoneNumber);
}

class VerifyOtp extends AuthEvent {
  final String phoneNumber;
  final String otp;

  VerifyOtp({
    required this.phoneNumber,
    required this.otp,
  });
}

class Logout extends AuthEvent {}