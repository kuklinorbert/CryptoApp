part of 'chart_bloc.dart';

abstract class ChartState extends Equatable {
  const ChartState();

  @override
  List<Object> get props => [];
}

class ChartInitial extends ChartState {}

class ChartLoadedState extends ChartState {
  final List<Chart> chart;

  ChartLoadedState({@required this.chart});

  @override
  List<Object> get props => [chart];
}

class ChartErrorState extends ChartState {
  final String message;

  ChartErrorState({@required this.message});

  @override
  List<Object> get props => [message];
}
