import 'package:equatable/equatable.dart';
import 'package:mindly/core/exceptions/failures.dart';
import 'package:mindly/core/utils/either.dart';

abstract class UseCase<Type, Params> {
  const UseCase();

  Future<Either<Failure, Type>> call(Params params);
}

abstract class StreamUseCase<Type, Params> {
  Stream<Type> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
