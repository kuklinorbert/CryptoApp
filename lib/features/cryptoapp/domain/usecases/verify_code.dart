import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/core/usecases/usecase.dart';
import 'package:cryptoapp/features/cryptoapp/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyCode implements UseCase<UserCredential, Params> {
  final AuthRepository authRepository;

  VerifyCode(this.authRepository);

  @override
  Future<Either<Failure, UserCredential>> call(Params params) async {
    return await authRepository.verifyCode(
        params.verifiactionId, params.smsCode);
  }
}

class Params extends Equatable {
  final String verifiactionId;
  final String smsCode;

  Params({@required this.verifiactionId, @required this.smsCode});

  @override
  List<Object> get props => [verifiactionId, smsCode];
}
