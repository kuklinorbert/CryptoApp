import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/core/network/network_info.dart';
import 'package:cryptoapp/features/cryptoapp/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({FirebaseAuth firebaseAuth, @required this.networkInfo})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<Either<Failure, User>> checkAuth() async {
    try {
      final result = FirebaseAuth.instance.currentUser;
      if (result != null) {
        return Right(result);
      } else {
        throw Exception();
      }
    } on Exception {
      return Left(CheckAuthFailure());
    }
  }

  @override
  Future<Either<Failure, void>> sendCode(
      String phoneNumber,
      Duration timeOut,
      PhoneVerificationFailed phoneVerificationFailed,
      PhoneVerificationCompleted phoneVerificationCompleted,
      PhoneCodeSent phoneCodeSent,
      PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout) async {
    try {
      final result = _firebaseAuth.verifyPhoneNumber(
          phoneNumber: "+" + phoneNumber,
          timeout: timeOut,
          verificationCompleted: phoneVerificationCompleted,
          verificationFailed: phoneVerificationFailed,
          codeSent: phoneCodeSent,
          codeAutoRetrievalTimeout: autoRetrievalTimeout);
      return Right(result);
    } catch (e) {
      return Left(CodeSendFailure());
    }
  }

  @override
  Future<Either<Failure, void>> resendCode(
      String phoneNumber,
      Duration timeOut,
      PhoneVerificationFailed phoneVerificationFailed,
      PhoneVerificationCompleted phoneVerificationCompleted,
      PhoneCodeSent phoneCodeSent,
      PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout,
      int forceResendingToken) async {
    try {
      final result = _firebaseAuth.verifyPhoneNumber(
          phoneNumber: "+" + phoneNumber,
          timeout: timeOut,
          verificationCompleted: phoneVerificationCompleted,
          verificationFailed: phoneVerificationFailed,
          codeSent: phoneCodeSent,
          codeAutoRetrievalTimeout: autoRetrievalTimeout,
          forceResendingToken: forceResendingToken);
      return Right(result);
    } catch (e) {
      return Left(CodeSendFailure());
    }
  }

  @override
  Future<Either<Failure, UserCredential>> verifyCode(
      String verificationId, String smsCode) async {
    if (await networkInfo.isConnected) {
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);
        final result = await _firebaseAuth.signInWithCredential(credential);
        return Right(result);
      } catch (e) {
        return Left(VerifyFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final result = await Future.wait([_firebaseAuth.signOut()]);
      return Right(result);
    } on Exception {
      return Left(LogoutFailure());
    }
  }
}
