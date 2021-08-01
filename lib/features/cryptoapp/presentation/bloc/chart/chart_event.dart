part of 'chart_bloc.dart';

abstract class ChartEvent extends Equatable {
  const ChartEvent();

  @override
  List<Object> get props => [];
}

class GetChartEvent extends ChartEvent {
  final String itemId;
  final String interval;

  GetChartEvent({@required this.itemId, @required this.interval});

  List<Object> get props => [itemId, interval];
}
