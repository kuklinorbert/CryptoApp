import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/core/usecases/usecase.dart';
import 'package:cryptoapp/features/cryptoapp/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class Logout extends UseCase<void, NoParams> {
  final AuthRepository authRepository;

  Logout(this.authRepository);

  @override
  Future<Either<Failure, void>> call(NoParams noParams) async {
    return await authRepository.logout();
  }
}
