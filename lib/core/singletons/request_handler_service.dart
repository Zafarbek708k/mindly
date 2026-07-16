import 'dart:developer' as dev;

import 'package:dio/dio.dart';
import 'package:mindly/core/exceptions/exceptions.dart';
import 'package:mindly/core/exceptions/failures.dart';
import 'package:mindly/core/utils/either.dart';

enum RequestMethod { get, post, put, delete, patch }

class RequestHandlerService {
  final Dio dio;

  const RequestHandlerService(this.dio);

  Future<T> handleRequest<T>({
    required T Function(Response response) fromJson,
    required String path,
    RequestMethod method = RequestMethod.get,
    Options? options,
    Map<String, dynamic>? queryParameters,
    Object? data,
    Dio? overrideDio,
    CancelToken? cancelToken,
  }) async {
    try {
      final effectiveOptions = (options ?? Options()).copyWith(method: options?.method ?? method.name.toUpperCase());
      final response = await (overrideDio ?? dio).request(
        path,
        options: effectiveOptions,
        queryParameters: queryParameters,
        data: data,
        cancelToken: cancelToken,
      );
      return fromJson(response);
    } on DioException catch (e) {
      throw CustomDioException(
        errorMessage: _describeDioError(e),
        type: e.type,
        statusCode: e.response?.statusCode ?? 0,
      );
    } on ParsingException {
      rethrow;
    } on UnauthorizedException {
      rethrow;
    } catch (e) {
      throw ParsingException(errorMessage: e.toString());
    }
  }

  /// Converts thrown exceptions into [Either.Left] for the repository layer.
  Future<Either<Failure, T>> handleRequestInRepository<T>({
    required Future<T> Function() onRequest,
    String debugLabel = '',
  }) async {
    try {
      final result = await onRequest();
      return Right(result);
    } on ParsingException catch (e) {
      _log('ParsingException', debugLabel, e.errorMessage);
      return Left(ParsingFailure(errorMessage: e.errorMessage));
    } on CustomDioException catch (e) {
      _log('CustomDioException', debugLabel, '${e.errorMessage} (status ${e.statusCode})');
      return Left(DioFailure(errorMessage: e.errorMessage, type: e.type, statusCode: e.statusCode));
    } on UnauthorizedException catch (e) {
      _log('UnauthorizedException', debugLabel, e.errorMessage);
      return Left(DioFailure(errorMessage: e.errorMessage, type: DioExceptionType.badResponse, statusCode: 401));
    } catch (e) {
      _log('Exception', debugLabel, e.toString());
      return Left(ParsingFailure(errorMessage: e.toString()));
    }
  }

  void _log(String kind, String label, String message) {
    dev.log('[$kind${label.isEmpty ? '' : ' / $label'}] $message', name: 'repo');
  }

  String _describeDioError(DioException e) {
    final responseBody = e.response?.data;
    if (responseBody is Map<String, dynamic>) {
      // Common shapes: {detail: "..."}, {message: "..."}, {error: "..."}
      final detail = responseBody['detail'] ?? responseBody['message'] ?? responseBody['error'];
      if (detail is String && detail.isNotEmpty) return detail;
    }
    if (responseBody is String && responseBody.isNotEmpty) {
      return responseBody;
    }
    return e.message ?? 'Network error';
  }
}
