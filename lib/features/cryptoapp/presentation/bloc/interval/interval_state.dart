part of 'interval_bloc.dart';

abstract class IntervalState extends Equatable {
  const IntervalState();

  @override
  List<Object> get props => [];
}

class OneDayState extends IntervalState {}

class OneWeekState extends IntervalState {}

class OneMonthState extends IntervalState {}

class OneYearState extends IntervalState {}

class YearToDayState extends IntervalState {}
