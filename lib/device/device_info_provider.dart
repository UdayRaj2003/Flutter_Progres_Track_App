import 'device_info.dart';

abstract interface class DeviceInfoProvider {
  Future<DeviceInfo> getDeviceInfo();
}