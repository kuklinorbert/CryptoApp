import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/core/usecases/usecase.dart';
import 'package:cryptoapp/features/cryptoapp/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckAuth extends UseCase<void, NoParams> {
  final AuthRepository authRepository;

  CheckAuth(this.authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams noParams) async {
    return await authRepository.checkAuth();
  }
}
