import 'dart:developer' as dev;

import 'package:get_it/get_it.dart';
import 'package:mindly/core/api/dio_settings.dart';
import 'package:mindly/core/singletons/request_handler_service.dart';
import 'package:mindly/core/singletons/storage.dart';
import 'package:mindly/core/utils/my_functions.dart';
import 'package:mindly/feature/quiz/data/datasources/quiz_local_datasource.dart';
import 'package:mindly/feature/quiz/data/datasources/quiz_remote_datasource.dart';
import 'package:mindly/feature/quiz/data/repositories/quiz_repository_impl.dart';
import 'package:mindly/feature/quiz/domain/repositories/quiz_repository.dart';
import 'package:mindly/feature/quiz/domain/usecases/load_quiz_usecase.dart';

final serviceLocator = GetIt.I;

Future<void> setupLocator() async {
  await StorageRepository.getInstance();
  await MyFunctions.initDeviceInfo();

  // Core
  serviceLocator.registerLazySingleton(() => DioSettings());
  serviceLocator.registerLazySingleton(() => RequestHandlerService(serviceLocator<DioSettings>().dio));

  _registerQuiz();

  serviceLocator<DioSettings>().attachAuth(onAuthFailure: () => dev.log('auth failure — tokens cleared', name: 'auth'));
}

Future<void> resetLocator() async {
  await serviceLocator.reset();
  await setupLocator();
}

void _registerQuiz() {
  serviceLocator.registerLazySingleton<QuizLocalDataSource>(() => const QuizLocalDataSourceImpl());
  serviceLocator.registerLazySingleton<QuizRemoteDataSource>(
    () => QuizRemoteDataSourceImpl(service: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<QuizRepository>(
    () => QuizRepositoryImpl(
      localDataSource: serviceLocator(),
      remoteDataSource: serviceLocator(),
      service: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(() => LoadQuizUseCase(repository: serviceLocator()));
}
