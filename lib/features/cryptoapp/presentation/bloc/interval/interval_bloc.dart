import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'interval_event.dart';
part 'interval_state.dart';

class IntervalBloc extends Bloc<IntervalEvent, IntervalState> {
  IntervalBloc() : super(OneWeekState());

  int index = 1;

  @override
  Stream<IntervalState> mapEventToState(
    IntervalEvent event,
  ) async* {
    if (event is SwitchIntervalEvent) {
      if (event.interval == 0) {
        index = 0;
        yield OneDayState();
      }
      if (event.interval == 1) {
        index = 1;
        yield OneWeekState();
      }
      if (event.interval == 2) {
        index = 2;
        yield OneMonthState();
      }
      if (event.interval == 3) {
        index = 3;
        yield OneYearState();
      }
      if (event.interval == 4) {
        index = 4;
        yield YearToDayState();
      }
    }
  }
}
