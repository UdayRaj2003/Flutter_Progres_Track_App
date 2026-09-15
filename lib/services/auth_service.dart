import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/logging/app_logger.dart';
import '../core/config/app_config.dart';
import '../models/auth/send_otp_response.dart';
import '../models/auth/verify_otp_response.dart';

class AuthService {
  final http.Client client;

  AuthService({http.Client? client}) : client = client ?? http.Client();

  Future<SendOtpResponse> sendOtp({required String phoneNumber}) async {
    final response = await client.post(
      Uri.parse('${AppConfig.authBaseUrl}${AppConfig.getOtpEndpoint}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phoneNumber': phoneNumber}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Get OTP request failed with status '
        '${response.statusCode}.',
      );
    }

    final responseData = jsonDecode(response.body) as Map<String, dynamic>;

    return SendOtpResponse.fromJson(responseData);
  }

  Future<VerifyOtpResponse> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String deviceId,
    required String deviceName,
    required String deviceType,
    required String clientVersion,
    required bool isDeviceSupported,
  }) async {
    final response = await client.post(
      Uri.parse('${AppConfig.authBaseUrl}${AppConfig.verifyOtpEndpoint}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'PhoneNumber': phoneNumber,
        'Otp': otp,
        'deviceId': deviceId,
        'deviceName': deviceName,
        'deviceType': deviceType,
        'clientVersion': clientVersion,
        'isDeviceSupported': isDeviceSupported,
      }),
    );
    appLogger.d(
      'Get OTP request: ${AppConfig.authBaseUrl}${AppConfig.getOtpEndpoint}',
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Verify OTP request failed with status '
        '${response.statusCode}.',
      );
    }

    final responseData = jsonDecode(response.body) as Map<String, dynamic>;

    return VerifyOtpResponse.fromJson(responseData);
  }

  void dispose() {
    client.close();
  }
}
