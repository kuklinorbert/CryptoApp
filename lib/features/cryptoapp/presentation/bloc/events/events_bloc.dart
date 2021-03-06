import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/core/usecases/usecase.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/events.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/get_events.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

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
      yield LoadingEvents();
      final failureOrEvents = await _getEvents.call(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrEvents);
    }
  }

  Stream<EventsState> _eitherLoadedOrErrorState(
    Either<Failure, Events> failureOrItem,
  ) async* {
    yield failureOrItem.fold(
      (failure) => ErrorEvents(message: _mapFailureToMessage(failure)),
      (event) => LoadedEvents(event: event),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return "error_network".tr();
      case ServerFailure:
        return "error_server".tr();
      default:
        return 'error_unexp'.tr();
    }
  }
}
