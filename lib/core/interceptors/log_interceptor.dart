import 'dart:developer' as dev;

import 'package:dio/dio.dart';

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
