import 'package:dio/dio.dart';

import '../api/links.dart';
import '../singletons/storage.dart';

/// Attaches `Authorization: Bearer <accessToken>` to every outgoing request,
/// except for endpoints listed in [Endpoints.noAuthPaths] (login, register,
/// refresh — they either don't need auth or send credentials another way).
///
/// Also tags every request with a `lang` header so the backend can localise
/// responses. Add additional standard headers here.
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
