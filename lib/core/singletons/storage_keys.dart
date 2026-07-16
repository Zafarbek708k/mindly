part of 'package:mindly/core/singletons/storage.dart';

abstract class StorageKeys {
  static const String intermediate = 'intermediate_token';
  static const String appName = 'app_name';
  static const String locale = 'locale';
  static const String theme = 'theme';
  static const String localeTitle = 'locale-title';
  static const String refreshDate = 'refresh_date';
  static const String onboarding = 'onboarding';
  static const String deviceId = 'device_id';
  static const String deviceName = 'device_name';
  static const String userAgent = 'user_agent';
  static const String appVersion = 'app_version';
  static const String versions = 'versions';
  static const String platform = 'platform';
  static const String fcmToken = 'fcm-token';
  static const String fcmDateTime = 'fcm-token-date-time';

  static const accessToken = 'access_token';
  static const refreshToken = 'refresh_token';
  static const onboardingSeen = 'onboarding_seen';

  static const coachMarkLogin = 'coach_mark_login';
  static const coachMarkOnlineToggle = 'coach_mark_online_toggle';
  static const coachMarkEarnings = 'coach_mark_earnings';
  static const coachMarkDailyActive = 'coach_mark_daily_active';
  static const coachMarkOrders = 'coach_mark_orders';
}
