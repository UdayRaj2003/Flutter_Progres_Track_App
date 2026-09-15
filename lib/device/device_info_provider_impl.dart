
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

import 'device_info.dart';
import 'device_info_provider.dart';

class DeviceInfoProviderImpl implements DeviceInfoProvider {
  static const String _deviceIdKey = 'app_installation_device_id';

  final DeviceInfoPlugin _deviceInfoPlugin;
  final FlutterSecureStorage _secureStorage;
  final Uuid _uuid;

  DeviceInfoProviderImpl({
    DeviceInfoPlugin? deviceInfoPlugin,
    FlutterSecureStorage? secureStorage,
    Uuid? uuid,
  })  : _deviceInfoPlugin =
            deviceInfoPlugin ?? DeviceInfoPlugin(),
        _secureStorage =
            secureStorage ?? const FlutterSecureStorage(),
        _uuid = uuid ?? const Uuid();

  @override
  Future<DeviceInfo> getDeviceInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();

    final deviceId = await _getOrCreateDeviceId();

    if (Platform.isAndroid) {
      final androidInfo =
          await _deviceInfoPlugin.androidInfo;

      return DeviceInfo(
        deviceId: deviceId,
        deviceName: _buildAndroidDeviceName(
          manufacturer: androidInfo.manufacturer,
          model: androidInfo.model,
        ),
        deviceType: 'mobile',
        clientVersion: packageInfo.version,
        isDeviceSupported: true,
      );
    }

    if (Platform.isIOS) {
      final iosInfo =
          await _deviceInfoPlugin.iosInfo;

      return DeviceInfo(
        deviceId: deviceId,
        deviceName: iosInfo.name,
        deviceType: 'mobile',
        clientVersion: packageInfo.version,
        isDeviceSupported: true,
      );
    }

    throw UnsupportedError(
      'Authentication is not supported on this platform yet.',
    );
  }

  Future<String> _getOrCreateDeviceId() async {
    final existingDeviceId =
        await _secureStorage.read(
      key: _deviceIdKey,
    );

    if (existingDeviceId != null &&
        existingDeviceId.isNotEmpty) {
      return existingDeviceId;
    }

    final newDeviceId = _uuid.v4();

    await _secureStorage.write(
      key: _deviceIdKey,
      value: newDeviceId,
    );

    return newDeviceId;
  }

  String _buildAndroidDeviceName({
    required String manufacturer,
    required String model,
  }) {
    final normalizedManufacturer =
        manufacturer.trim();

    final normalizedModel = model.trim();

    if (normalizedManufacturer.isEmpty) {
      return normalizedModel;
    }

    if (normalizedModel
        .toLowerCase()
        .startsWith(
          normalizedManufacturer.toLowerCase(),
        )) {
      return normalizedModel;
    }

    return '$normalizedManufacturer $normalizedModel';
  }
}