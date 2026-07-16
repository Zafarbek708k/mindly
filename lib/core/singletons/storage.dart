import 'package:shared_preferences/shared_preferences.dart';

part 'package:mindly/core/singletons/storage_keys.dart';

class StorageRepository {
  // StorageKeys
  StorageRepository._();

  static StorageRepository? _instance;
  static SharedPreferences? _prefs;

  static Future<StorageRepository> getInstance() async {
    if (_instance == null) {
      _instance = StorageRepository._();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  static SharedPreferences get _safePrefs {
    final p = _prefs;
    if (p == null) {
      throw StateError(
        'StorageRepository accessed before getInstance() completed. '
        'Make sure setupLocator() finishes before any read/write.',
      );
    }
    return p;
  }

  // ─── Primitives ──────────────────────────────────────────────────────────

  static Future<bool> putString(String key, String value) => _safePrefs.setString(key, value);

  static String getString(String key, {String defValue = ''}) => _safePrefs.getString(key) ?? defValue;

  static Future<bool> putBool(String key, bool value) => _safePrefs.setBool(key, value);

  static bool getBool(String key, {bool defValue = false}) => _safePrefs.getBool(key) ?? defValue;

  static Future<bool> putInt(String key, int value) => _safePrefs.setInt(key, value);

  static int getInt(String key, {int defValue = -1}) => _safePrefs.getInt(key) ?? defValue;

  static Future<bool> putDouble(String key, double value) => _safePrefs.setDouble(key, value);

  static double getDouble(String key, {double defValue = 0.0}) => _safePrefs.getDouble(key) ?? defValue;

  static Future<bool> putList(String key, List<String> value) => _safePrefs.setStringList(key, value);

  static List<String> getList(String key, {List<String>? defValue}) =>
      _safePrefs.getStringList(key) ?? defValue ?? const [];

  static Future<bool> remove(String key) => _safePrefs.remove(key);

  static Future<bool> clearAll() => _safePrefs.clear();

  // ─── Auth helpers ────────────────────────────────────────────────────────
  // Tokens live here so [HeaderInterceptor] and [RefreshTokenInterceptor]
  // don't need to know any key strings.

  static String get accessToken => getString(StorageKeys.accessToken);

  static String get refreshToken => getString(StorageKeys.refreshToken);

  static Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    await putString(StorageKeys.accessToken, accessToken);
    await putString(StorageKeys.refreshToken, refreshToken);
  }

  static Future<void> clearAuth() async {
    await remove(StorageKeys.accessToken);
    await remove(StorageKeys.refreshToken);
  }

  static bool get hasTokens => accessToken.isNotEmpty && refreshToken.isNotEmpty;

  // ─── Onboarding ──────────────────────────────────────────────────────────

  static bool get hasSeenOnboarding => getBool(StorageKeys.onboardingSeen, defValue: false);

  static Future<void> markOnboardingSeen() => putBool(StorageKeys.onboardingSeen, true);
}
