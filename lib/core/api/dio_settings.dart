import 'package:dio/dio.dart';
import 'package:mindly/core/interceptors/header_interceptor.dart';
import 'package:mindly/core/interceptors/log_interceptor.dart';
import 'package:mindly/core/interceptors/refresh_token_interceptor.dart';

import 'links.dart';

class DioSettings {
  static final DioSettings _instance = DioSettings._internal();

  factory DioSettings() => _instance;

  late final Dio dio;
  bool _authAttached = false;

  DioSettings._internal() {
    dio = Dio(_baseOptions);
    dio.interceptors.add(HeaderInterceptor());
    dio.interceptors.add(AppLogInterceptor());
  }

  BaseOptions get _baseOptions => BaseOptions(
    baseUrl: Links.baseUrl,
    connectTimeout: const Duration(seconds: 35),
    receiveTimeout: const Duration(seconds: 35),
    sendTimeout: const Duration(seconds: 35),
    responseType: ResponseType.json,
    followRedirects: false,
    headers: const {'Accept': 'application/json', 'Content-Type': 'application/json'},
    validateStatus: (status) => status != null && status >= 200 && status < 300,
  );

  void attachAuth({required void Function() onAuthFailure}) {
    if (_authAttached) return;
    _authAttached = true;
    final logIndex = dio.interceptors.indexWhere((i) => i.runtimeType.toString() == 'AppLogInterceptor');
    final refresh = RefreshTokenInterceptor(dio: dio, onAuthFailure: onAuthFailure);
    if (logIndex >= 0) {
      dio.interceptors.insert(logIndex, refresh);
    } else {
      dio.interceptors.add(refresh);
    }
  }
}
