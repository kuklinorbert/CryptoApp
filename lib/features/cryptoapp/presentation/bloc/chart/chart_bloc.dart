import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/chart.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/get_chart.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';

part 'chart_event.dart';
part 'chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final GetChart _getChart;

  ChartBloc({@required GetChart getChart})
      : assert(getChart != null),
        _getChart = getChart,
        super(ChartInitial());

  @override
  Stream<ChartState> mapEventToState(
    ChartEvent event,
  ) async* {
    if (event is GetChartEvent) {
      // yield ChartLoadingState();
      final failureOrChart = await _getChart.call(Params(
          itemId: event.itemId,
          interval: event.interval,
          convert: event.convert));
      yield* _eitherChartOrErrorState(failureOrChart);
    }
  }

  Stream<ChartState> _eitherChartOrErrorState(
    Either<Failure, List<Chart>> failureOrItem,
  ) async* {
    yield failureOrItem.fold(
        (failure) => ChartErrorState(message: _mapFailureToMessage(failure)),
        (chart) => ChartLoadedState(chart: chart));
  }
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
