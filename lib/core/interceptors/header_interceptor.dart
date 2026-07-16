import 'package:dio/dio.dart';

import '../api/links.dart';
import '../singletons/storage.dart';

class HeaderInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final lang = StorageRepository.getString(StorageKeys.locale, defValue: 'uz');
    options.headers['Accept-Language'] = lang;

    final needsAuth = !Endpoints.noAuthPaths.any((p) => options.path.endsWith(p));
    if (needsAuth) {
      final token = StorageRepository.accessToken;
      if (token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }
}
