import 'dart:async';

import 'package:dio/dio.dart';

import '../api/links.dart';
import '../exceptions/exceptions.dart';
import '../singletons/storage.dart';

/// Handles 401 responses by silently refreshing the access token and retrying
/// the original request.
///
/// Subtleties this implementation gets right (and many naive ones don't):
///
/// 1. **Single-flight refresh.** When 5 requests fire in parallel and all
///    get 401, we don't trigger 5 refresh calls. The first 401 starts a
///    refresh future and the rest `await` the same future via [_refreshing].
///
/// 2. **No retry loop.** If a refreshed request itself returns 401, we
///    don't try to refresh again — we give up and emit unauthenticated.
///    The `_isRetry` flag on `RequestOptions.extra` guards against this.
///
/// 3. **Refresh failure → logout signal.** When refresh itself fails, we
///    clear stored tokens and call [onAuthFailure]. The cubit at the top of
///    the app listens to this hook (wired up in DI) and flips the app to the
///    login screen.
///
/// 4. **Refresh endpoint short-circuit.** If the failing request was already
///    the refresh endpoint, we don't recurse — straight to logout.
class RefreshTokenInterceptor extends Interceptor {
  final Dio _dio;
  final void Function() onAuthFailure;

  Future<bool>? _refreshing;

  RefreshTokenInterceptor({required this._dio, required this.onAuthFailure});

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;
    final originalRequest = err.requestOptions;

    final isUnauthorized = status == 401;
    final alreadyRetried = originalRequest.extra['_isRetry'] == true;
    final isRefreshCall = originalRequest.path.endsWith(Endpoints.refreshToken);

    if (!isUnauthorized || alreadyRetried || isRefreshCall) {
      return handler.next(err);
    }

    if (StorageRepository.refreshToken.isEmpty) {
      await _logout();
      return handler.next(err);
    }

    final ok = await (_refreshing ??= _refreshTokens());
    _refreshing = null;

    if (!ok) {
      return handler.next(err);
    }

    try {
      final retried = await _dio.fetch<dynamic>(
        originalRequest
          ..extra['_isRetry'] = true
          ..headers['Authorization'] = 'Bearer ${StorageRepository.accessToken}',
      );
      return handler.resolve(retried);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  Future<bool> _refreshTokens() async {
    try {
      final bareDio = Dio(
        BaseOptions(
          baseUrl: Links.baseUrl,
          responseType: ResponseType.json,
          headers: const {'Content-Type': 'application/json'},
        ),
      );
      final response = await bareDio.post<Map<String, dynamic>>(
        Endpoints.refreshToken,
        data: {'refresh_token': StorageRepository.refreshToken},
      );

      final data = response.data;
      if (data == null) throw const UnauthorizedException();

      await StorageRepository.saveTokens(
        accessToken: data['access_token'] as String,
        refreshToken: data['refresh_token'] as String,
      );
      return true;
    } catch (_) {
      await _logout();
      return false;
    }
  }

  Future<void> _logout() async {
    await StorageRepository.clearAuth();
    onAuthFailure();
  }
}
