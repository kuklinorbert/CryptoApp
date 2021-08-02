part of 'converter_bloc.dart';

abstract class ConverterState extends Equatable {
  const ConverterState();

  @override
  List<Object> get props => [];
}

class ConverterInitial extends ConverterState {}

class ConverterLoadingState extends ConverterState {}

class ConverterUSDState extends ConverterState {}

class ConverterEURState extends ConverterState {
  final Items item;

  ConverterEURState({@required this.item});

  @override
  List<Object> get props => [item];
}

class ConverterErrorState extends ConverterState {
  final String message;

  ConverterErrorState({@required this.message});

  @override
  List<Object> get props => [message];
}
