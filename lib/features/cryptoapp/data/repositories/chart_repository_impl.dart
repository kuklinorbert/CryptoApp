import 'package:cryptoapp/core/error/exceptions.dart';
import 'package:cryptoapp/features/cryptoapp/data/datasources/chart_data_source.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/chart.dart';
import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/features/cryptoapp/domain/repositories/chart_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class ChartRepositoryImpl implements ChartRepository {
  final ChartDataSource chartDataSource;

  ChartRepositoryImpl({@required this.chartDataSource});

  @override
  Future<Either<Failure, List<Chart>>> getChart(
      String itemId, String interval) async {
    try {
      final result = await chartDataSource.getChart(itemId, interval);
      return Right(result);
    } on ServerException {
      throw Left(ServerFailure());
    }
  }
}
