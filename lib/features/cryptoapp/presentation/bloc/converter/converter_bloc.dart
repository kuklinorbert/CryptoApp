import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/get_converted_item.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

part 'converter_event.dart';
part 'converter_state.dart';

class ConverterBloc extends Bloc<ConverterEvent, ConverterState> {
  final GetConvertedItem _getConvertedItem;
  ConverterBloc({@required GetConvertedItem getConvertedItem})
      : _getConvertedItem = getConvertedItem,
        super(ConverterInitial());

  @override
  Stream<ConverterState> mapEventToState(
    ConverterEvent event,
  ) async* {
    if (event is SwitchToUsdEvent) {
      yield ConverterUSDState();
    }
    if (event is SwitchToEurEvent) {
      final failureOrItem =
          await _getConvertedItem.call(Params(itemId: event.itemId));
      yield* _eitherItemOrErrorState(failureOrItem);
    }
  }

  Stream<ConverterState> _eitherItemOrErrorState(
    Either<Failure, List<Items>> failureOrItem,
  ) async* {
    yield failureOrItem.fold(
      (failure) => ConverterErrorState(message: _mapFailureToMessage(failure)),
      (item) {
        return ConverterEURState(item: item[0]);
      },
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
