import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/core/usecases/usecase.dart';
import 'package:cryptoapp/features/cryptoapp/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SendCode implements UseCase<void, Params> {
  final AuthRepository authRepository;

  SendCode(this.authRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await authRepository.sendCode(
        params.phoneNumber,
        params.timeOut,
        params.phoneVerificationFailed,
        params.phoneVerificationCompleted,
        params.phoneCodeSent,
        params.autoRetrievalTimeout);
  }
}

class Params extends Equatable {
  final String phoneNumber;
  final Duration timeOut;
  final PhoneVerificationFailed phoneVerificationFailed;
  final PhoneVerificationCompleted phoneVerificationCompleted;
  final PhoneCodeSent phoneCodeSent;
  final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout;

  Params(
      {@required this.phoneNumber,
      @required this.timeOut,
      @required this.phoneVerificationFailed,
      @required this.phoneVerificationCompleted,
      @required this.phoneCodeSent,
      @required this.autoRetrievalTimeout});

  @override
  List<Object> get props => [
        phoneNumber,
        timeOut,
        phoneVerificationFailed,
        phoneVerificationCompleted,
        phoneCodeSent,
        autoRetrievalTimeout
      ];
}
