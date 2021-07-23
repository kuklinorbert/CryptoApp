import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  Failure([List properties = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class CheckAuthFailure extends Failure {}

class CodeSendFailure extends Failure {}

class LogoutFailure extends Failure {}

class VerifyFailure extends Failure {}
