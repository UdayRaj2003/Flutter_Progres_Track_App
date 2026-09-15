class LoggedInDevice {
  final String deviceId;
  final String deviceName;
  final String deviceType;
  final String lastTimeUsed;

  const LoggedInDevice({
    required this.deviceId,
    required this.deviceName,
    required this.deviceType,
    required this.lastTimeUsed,
  });

  factory LoggedInDevice.fromJson(Map<String, dynamic> json) {
    return LoggedInDevice(
      deviceId: json['deviceId'] as String? ?? '',
      deviceName: json['deviceName'] as String? ?? '',
      deviceType: json['deviceType'] as String? ?? '',
      lastTimeUsed: json['lastTimeUsed'] as String? ?? '',
    );
  }
}