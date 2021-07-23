part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class CheckAuthEvent extends AuthEvent {}

class SendCodeEvent extends AuthEvent {
  final String phoneNumber;

  SendCodeEvent({@required this.phoneNumber});

  List<Object> get props => [phoneNumber];
}

class VerifyEvent extends AuthEvent {
  final String smsCode;

  VerifyEvent({@required this.smsCode});

  List<Object> get props => [smsCode];
}

class LogoutEvent extends AuthEvent {}

class AuthenticatedEvent extends AuthEvent {}

class VerifyFailureEvent extends AuthEvent {
  final String message;

  VerifyFailureEvent({@required this.message});

  @override
  List<Object> get props => [message];
}

class CodeSentEvent extends AuthEvent {}

class JumpBackEvent extends AuthEvent {}
