part of 'events_bloc.dart';

abstract class EventsState extends Equatable {
  const EventsState();

  @override
  List<Object> get props => [];
}

class EventsInitial extends EventsState {}

class Loading extends EventsState {}

class Loaded extends EventsState {
  final Events event;

  Loaded({@required this.event});

  @override
  List<Object> get props => [event];
}

class Error extends EventsState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}
