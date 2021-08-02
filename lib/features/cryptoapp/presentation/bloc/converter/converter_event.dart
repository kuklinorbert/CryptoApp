part of 'converter_bloc.dart';

abstract class ConverterEvent extends Equatable {
  const ConverterEvent();

  @override
  List<Object> get props => [];
}

class SwitchToEurEvent extends ConverterEvent {
  final String itemId;

  SwitchToEurEvent({@required this.itemId});

  @override
  List<Object> get props => [itemId];
}

class SwitchToUsdEvent extends ConverterEvent {}
