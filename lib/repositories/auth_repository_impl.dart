import '../device/device_info_provider.dart';
import '../models/auth/auth_session.dart';
import '../models/auth/send_otp_response.dart';
import '../services/auth_service.dart';
import '../storage/auth_storage.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final AuthStorage _authStorage;
  final DeviceInfoProvider _deviceInfoProvider;
  AuthRepositoryImpl({
    required this._authService,
    required this._authStorage,
    required this._deviceInfoProvider,
  });
  @override
  Future<SendOtpResponse> sendOtp({required String phoneNumber}) {
    return _authService.sendOtp(phoneNumber: phoneNumber);
  }

  @override
  Future<AuthSession> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    final deviceInfo = await _deviceInfoProvider.getDeviceInfo();

    final response = await _authService.verifyOtp(
      phoneNumber: phoneNumber,
      otp: otp,
      deviceId: deviceInfo.deviceId,
      deviceName: deviceInfo.deviceName,
      deviceType: deviceInfo.deviceType,
      clientVersion: deviceInfo.clientVersion,
      isDeviceSupported: deviceInfo.isDeviceSupported,
    );
    if (response.isMaxAttemptReached) {
      throw OtpMaxAttemptsException(
        response.msg.isNotEmpty ? response.msg : 'Too many attempts.',
      );
    }
    if (!response.isVerified) {
      throw InvalidOtpException(
        response.msg.isNotEmpty ? response.msg : 'Invalid OTP.',
      );
    }

    if (response.accessToken.isEmpty) {
      throw Exception(
        'Authentication succeeded but no access token was returned.',
      );
    }

    await _authStorage.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );

    return AuthSession(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      users: response.users,
    );
  }

  @override
  Future<bool> hasSession() {
    return _authStorage.hasSession();
  }

  @override
  Future<void> logout() {
    return _authStorage.clearSession();
  }
}
