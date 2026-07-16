import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:mindly/core/singletons/storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class MyFunctions {
  static double getRoundedCap(double value, [double base = 1]) {
    while (value >= base * 10) {
      base *= 10;
    }
    return base;
  }

  static double getInterval(List<double> values, [double base = 1]) {
    if (values.isEmpty) {
      return 0;
    }
    final max = values.reduce((a, b) => a > b ? a : b);
    final rounded = getRoundedCap(max);
    return rounded;
  }

  static Future<void> initDeviceInfo() async {
    try {
      final uDid = await FlutterUdid.udid;
      await StorageRepository.putString(StorageKeys.deviceId, uDid);
      log("DEVICE ID ==> $uDid ");
    } catch (e) {
      log("DEVICE ID ERROR ==> $e ");
    }
    final deviceInfo = DeviceInfoPlugin();

    final deviceName = await getDeviceName(deviceInfo);
    await StorageRepository.putString(StorageKeys.deviceName, deviceName!);

    final userAgent = await getUserAgent(deviceInfo);
    await StorageRepository.putString(StorageKeys.userAgent, userAgent!);

    final appVersion = await getAppVersion();
    await StorageRepository.putString(StorageKeys.appVersion, appVersion);

    final versions = StorageRepository.getList(StorageKeys.versions);
    final newVersions = {...versions, appVersion};
    await StorageRepository.putList(StorageKeys.versions, newVersions.toList());

    final platform = await getPlatform();
    await StorageRepository.putString(StorageKeys.platform, platform);

    log('\n');
    log('==================================================================================');
    log('******** DEVICE INFO ********');
    log('### deviceName: $deviceName');
    log('### userAgent: $userAgent');
    log('### deviceType: $platform');
    log('### appVersion: $appVersion');
    log('### versions: $newVersions');
    log('==================================================================================\n');
  }

  static Future<String?> getDeviceName(DeviceInfoPlugin deviceInfo) async {
    if (Platform.isIOS) {
      final iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.name;
    } else if (Platform.isAndroid) {
      final androidDeviceInfo = await deviceInfo.androidInfo;
      return "${androidDeviceInfo.brand} ${androidDeviceInfo.model}";
    }
    return null;
  }

  static Future<String?> getUserAgent(DeviceInfoPlugin deviceInfo) async {
    if (Platform.isIOS) {
      final iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.utsname.machine;
    } else if (Platform.isAndroid) {
      final androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.model;
    }
    return null;
  }

  static Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();

    return packageInfo.version;
  }

  static Future<String> getPlatform() async {
    if (Platform.isIOS) {
      return "IOS";
    }
    if (Platform.isMacOS) {
      return "MACOS";
    }

    return "ANDROID";
  }

  static String formatPhoneText(String input) {
    input = input.replaceAll(RegExp(r'\D'), '');

    if (input.length <= 2) return input;
    List<int> groups = [2, 3, 2, 2];
    int start = 0;
    List<String> parts = [];

    for (int i = 0; i < groups.length; i++) {
      int length = groups[i];
      if (start >= input.length) break;

      int end = (start + length < input.length) ? start + length : input.length;
      parts.add(input.substring(start, end));
      start = end;
    }
    return [parts.take(2).join(' '), parts.skip(2).join('-')].where((e) => e.isNotEmpty).join('-');
  }

  static String formatDate({required int timestamp}) {
    if (timestamp == 0) return '--.--.----';
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    return '$day.$month.$year';
  }

  static String formatTime({required int timestamp}) {
    if (timestamp == 0) {
      return '--:--';
    }
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static Future<void> callPhone(String phoneNumber) async {
    final uri = Uri.parse(phoneNumber);

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
