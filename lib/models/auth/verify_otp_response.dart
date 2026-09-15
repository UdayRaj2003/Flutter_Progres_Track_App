import 'authenticated_user.dart';
import 'logged_in_device.dart';

class VerifyOtpResponse {
  final List<AuthenticatedUser> users;
  final int subscriptionId;
  final String subscriptionMode;
  final String email;
  final bool isUserFromWebsite;
  final String websiteVerifiedUserName;
  final String parentNumber;
  final bool isSubscriptionExpired;
  final DateTime subscriptionEndDate;
  final String planId;
  final String msg;
  final bool isVerified;
  final bool shouldShowDeviceBlockingPage;
  final List<LoggedInDevice> existingLoggedInDevices;
  final String refreshToken;
  final String accessToken;
  final bool isMaxAttemptReached;
  final bool receivedFcmToken;

  const VerifyOtpResponse({
    required this.users,
    required this.subscriptionId,
    required this.subscriptionMode,
    required this.email,
    required this.isUserFromWebsite,
    required this.websiteVerifiedUserName,
    required this.parentNumber,
    required this.isSubscriptionExpired,
    required this.subscriptionEndDate,
    required this.planId,
    required this.msg,
    required this.isVerified,
    required this.shouldShowDeviceBlockingPage,
    required this.existingLoggedInDevices,
    required this.refreshToken,
    required this.accessToken,
    required this.isMaxAttemptReached,
    required this.receivedFcmToken,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      users: (json['users'] as List?)
              ?.map(
                (user) => AuthenticatedUser.fromJson(
                  user as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      subscriptionId: json['subscriptionId'] as int? ?? 0,
      subscriptionMode: json['subscriptionMode'] as String? ?? '',
      email: json['email'] as String? ?? '',
      isUserFromWebsite: json['isUserFromWebsite'] as bool? ?? false,
      websiteVerifiedUserName:
          json['websiteVerifiedUserName'] as String? ?? '',
      parentNumber: json['parentNumber'] as String? ?? '',
      isSubscriptionExpired:
          json['isSubscriptionExpired'] as bool? ?? false,
      subscriptionEndDate: json['subscriptionEndDate'] != null
          ? DateTime.tryParse(json['subscriptionEndDate'] as String) ??
              DateTime.now()
          : DateTime.now(),
      planId: json['planId'] as String? ?? '',
      msg: json['msg'] as String? ?? '',
      isVerified: json['isVerified'] as bool? ?? false,
      shouldShowDeviceBlockingPage:
          json['shouldShowDeviceBlockingPage'] as bool? ?? false,
      existingLoggedInDevices: (json['exisitngLoggedIndevices'] as List?)
              ?.map(
                (device) => LoggedInDevice.fromJson(
                  device as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      refreshToken: json['refreshToken'] as String? ?? '',
      accessToken: json['accessToken'] as String? ?? '',
      isMaxAttemptReached:
          json['isMaxAttemptReached'] as bool? ?? false,
      receivedFcmToken: json['receivedFcmToken'] as bool? ?? false,
    );
  }
}