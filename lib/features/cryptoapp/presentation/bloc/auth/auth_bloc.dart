import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/core/usecases/usecase.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/check_auth.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/logout.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/send_code.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/verify_code.dart'
    as verify;
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendCode _sendCode;
  final CheckAuth _checkAuth;
  final Logout _logout;
  final verify.VerifyCode _verifyCode;

  AuthBloc(
      {@required SendCode sendCode,
      @required CheckAuth checkAuth,
      @required verify.VerifyCode verifyCode,
      @required Logout logout})
      : assert(sendCode != null, checkAuth != null),
        _sendCode = sendCode,
        _checkAuth = checkAuth,
        _verifyCode = verifyCode,
        _logout = logout,
        super(AuthInitial());

  StreamSubscription subscription;
  String verID = "";
  bool secondPage = false;

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is CheckAuthEvent) {
      final result = await _checkAuth.call(NoParams());
      yield* _eitherAuthOrErrorState(result);
    } else if (event is SendCodeEvent) {
      subscription = sendCode(event.phoneNumber).listen((event) {
        add(event);
      });
      yield LoadingState();
    } else if (event is CodeSentEvent) {
      yield CodeSentState();
      secondPage = true;
    } else if (event is VerifyEvent) {
      final result = await _verifyCode
          .call(verify.Params(verifiactionId: verID, smsCode: event.smsCode));
      yield LoadingState();
      yield* _eitherUserOrErrorState(result);
    } else if (event is LogoutEvent) {
      final result = await (_logout.call(NoParams()));
      yield* _eitherLogoutOrErrorState(result);
    } else if (event is AuthenticatedEvent) {
      yield Authenticated();
    } else if (event is VerifyFailureEvent) {
      yield VerifyErrorState(message: event.message);
    } else if (event is JumpBackEvent) {
      if (secondPage) {
        yield CodeSentState();
      } else {
        yield Unauthenticated();
      }
    }
  }

  Stream<AuthState> _eitherLogoutOrErrorState(
    Either<Failure, void> failureOrLogout,
  ) async* {
    yield failureOrLogout.fold(
      (failure) => ErrorLoggedState(message: _mapFailureToMessage(failure)),
      (logout) {
        secondPage = false;
        return Unauthenticated();
      },
    );
  }

  Stream<AuthState> _eitherUserOrErrorState(
      Either<Failure, UserCredential> failureOrLogin) async* {
    yield failureOrLogin.fold(
        (failure) => ErrorLoggedState(message: _mapFailureToMessage(failure)),
        (login) => Authenticated());
  }

  Stream<AuthState> _eitherAuthOrErrorState(
    Either<Failure, User> failureOrAuth,
  ) async* {
    yield failureOrAuth.fold(
      (failure) => Unauthenticated(),
      (user) {
        return Authenticated();
      },
    );
  }

  Stream<AuthEvent> sendCode(String phoneNumber) async* {
    StreamController<AuthEvent> eventStream = StreamController();
    final phoneVerificationCompleted = (AuthCredential authCredential) {
      eventStream.add(AuthenticatedEvent());
      eventStream.close();
    };
    final phoneVerificationFailed = (FirebaseAuthException authException) {
      print(authException.message);
      eventStream.add(VerifyFailureEvent(message: authException.message));
      eventStream.close();
    };
    final phoneCodeSent = (String verId, [int forceResent]) {
      this.verID = verId;
      eventStream.add(CodeSentEvent());
    };
    final phoneCodeAutoRetrievalTimeout = (String verid) {
      this.verID = verid;
      eventStream.close();
    };

    await _sendCode.call(Params(
        phoneNumber: phoneNumber,
        timeOut: Duration(seconds: 30),
        phoneVerificationFailed: phoneVerificationFailed,
        phoneVerificationCompleted: phoneVerificationCompleted,
        phoneCodeSent: phoneCodeSent,
        autoRetrievalTimeout: phoneCodeAutoRetrievalTimeout));

    yield* eventStream.stream;
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case CheckAuthFailure:
        return 'checkauth_fail'; //.tr();
      case CodeSendFailure:
        return 'codesend_fail'; //.tr();
      case LogoutFailure:
        return 'logout_fail'; //.tr();
      case VerifyFailure:
        return 'verify_fail';
      default:
        return 'unexp_error'; //.tr();
    }
  }
}
