import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/core/usecases/usecase.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/chart.dart';
import 'package:cryptoapp/features/cryptoapp/domain/repositories/chart_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class GetChart extends UseCase<List<Chart>, Params> {
  final ChartRepository chartRepository;

  GetChart(this.chartRepository);

  @override
  Future<Either<Failure, List<Chart>>> call(Params params) async {
    return await chartRepository.getChart(params.itemId, params.interval);
  }
}

class Params {
  final String itemId;
  final String interval;

  Params({@required this.itemId, @required this.interval});

  @override
  List<Object> get props => [interval, itemId];
}
