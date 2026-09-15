class DeviceInfo {
  final String deviceId;
  final String deviceName;
  final String deviceType;
  final String clientVersion;
  final bool isDeviceSupported;

  const DeviceInfo({
    required this.deviceId,
    required this.deviceName,
    required this.deviceType,
    required this.clientVersion,
    required this.isDeviceSupported,
  });
}