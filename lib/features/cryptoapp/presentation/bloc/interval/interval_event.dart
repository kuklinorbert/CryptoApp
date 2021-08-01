part of 'interval_bloc.dart';

abstract class IntervalEvent extends Equatable {
  const IntervalEvent();

  @override
  List<Object> get props => [];
}

class SwitchIntervalEvent extends IntervalEvent {
  final int interval;
  SwitchIntervalEvent({@required this.interval});

  List<Object> get props => [interval];
}
