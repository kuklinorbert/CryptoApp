import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/core/usecases/usecase.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/events.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/get_events.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final GetEvents _getEvents;

  EventsBloc({@required GetEvents getEvents})
      : assert(getEvents != null),
        _getEvents = getEvents,
        super(EventsInitial());

  @override
  Stream<EventsState> mapEventToState(
    EventsEvent event,
  ) async* {
    if (event is GetEventsEvent) {
      yield Loading();
      final failureOrEvents = await _getEvents.call(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrEvents);
    }
  }

  Stream<EventsState> _eitherLoadedOrErrorState(
    Either<Failure, Events> failureOrItem,
  ) async* {
    yield failureOrItem.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (event) => Loaded(event: event),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      default:
        return 'Unexpected error';
    }
  }
}
