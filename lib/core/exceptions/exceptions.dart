import 'package:dio/dio.dart';

/// Base for everything that the network / parsing layer can throw.
sealed class AppException implements Exception {
  final String errorMessage;

  const AppException({required this.errorMessage});

  @override
  String toString() => '$runtimeType: $errorMessage';
}

/// Wraps a [DioException] with status + type so the repository layer can
/// translate it to a [DioFailure] without re-importing Dio.
class CustomDioException extends AppException {
  final DioExceptionType type;
  final int statusCode;

  const CustomDioException({required super.errorMessage, required this.type, required this.statusCode});
}

/// Thrown when JSON shape doesn't match what the model expected.
class ParsingException extends AppException {
  const ParsingException({required super.errorMessage});
}

/// Thrown by the auth layer when a token refresh attempt fails. Triggers a
/// logout in [AppStartupCubit].
class UnauthorizedException extends AppException {
  const UnauthorizedException({super.errorMessage = 'Session expired'});
}
