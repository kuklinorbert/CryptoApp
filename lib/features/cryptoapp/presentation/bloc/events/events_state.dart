part of 'events_bloc.dart';

abstract class EventsState extends Equatable {
  const EventsState();

  @override
  List<Object> get props => [];
}

class EventsInitial extends EventsState {}

class LoadingEvents extends EventsState {}

class LoadedEvents extends EventsState {
  final Events event;

  LoadedEvents({@required this.event});

  @override
  List<Object> get props => [event];
}

class ErrorEvents extends EventsState {
  final String message;

  ErrorEvents({@required this.message});

  @override
  List<Object> get props => [message];
}
