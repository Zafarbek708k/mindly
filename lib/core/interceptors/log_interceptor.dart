import 'dart:developer' as dev;

import 'package:dio/dio.dart';

/// Pretty-prints request/response/error to the dev console.
///
/// In your original code you implemented [Interceptor] from scratch and left
/// every method with a `// TODO` — that crashes any request because
/// `handler.next(...)` is never called. Inherit from [Interceptor] (which is
/// concrete, not abstract) so all base methods default to passing through,
/// or call the relevant `handler.next/...` from every override.
class AppLogInterceptor extends Interceptor {
  final bool logRequestBody;
  final bool logResponseBody;

  AppLogInterceptor({
    this.logRequestBody = true,
    this.logResponseBody = true,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    dev.log(
      '→ ${options.method} ${options.uri}'
      '${logRequestBody && options.data != null ? '\n  body: ${options.data}' : ''}',
      name: 'http',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    dev.log(
      '← ${response.statusCode} ${response.requestOptions.path}'
      '${logResponseBody ? '\n  data: ${response.data}' : ''}',
      name: 'http',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    dev.log(
      '✗ ${err.response?.statusCode ?? '---'} ${err.requestOptions.path}'
      '\n  type: ${err.type}'
      '\n  msg : ${err.message}',
      name: 'http',
      error: err,
    );
    handler.next(err);
  }
}
