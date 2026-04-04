import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entites/user.dart';
import '../repositories/auth_repository.dart';

import 'logout_usecase.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<Either<Failure, UserEntity?>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}