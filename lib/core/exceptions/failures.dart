import 'package:dio/dio.dart';

/// Failures are the value-typed mirror of exceptions: they don't throw, they
/// flow up through [Either.Left]. Use [Failure.message] for user-facing copy.
sealed class Failure {
  final String errorMessage;

  const Failure({required this.errorMessage});

  /// Convenience friendly message — override in subclasses when the raw
  /// [errorMessage] would be too technical to show in the UI.
  String get message => errorMessage;
}

class DioFailure extends Failure {
  final DioExceptionType type;
  final int statusCode;

  const DioFailure({required super.errorMessage, required this.type, required this.statusCode});

  bool get isUnauthorized => statusCode == 401;

  bool get isForbidden => statusCode == 403;

  bool get isNotFound => statusCode == 404;

  bool get isServerError => statusCode >= 500;

  bool get isTimeout =>
      type == DioExceptionType.connectionTimeout ||
      type == DioExceptionType.receiveTimeout ||
      type == DioExceptionType.sendTimeout;

  bool get isNoConnection => type == DioExceptionType.connectionError;
}

class ParsingFailure extends Failure {
  const ParsingFailure({required super.errorMessage});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.errorMessage});
}
