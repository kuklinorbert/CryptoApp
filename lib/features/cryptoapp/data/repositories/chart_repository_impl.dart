import 'package:cryptoapp/core/error/exceptions.dart';
import 'package:cryptoapp/core/network/network_info.dart';
import 'package:cryptoapp/features/cryptoapp/data/datasources/chart_data_source.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/chart.dart';
import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/features/cryptoapp/domain/repositories/chart_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class ChartRepositoryImpl implements ChartRepository {
  final NetworkInfo networkInfo;
  final ChartDataSource chartDataSource;

  ChartRepositoryImpl(
      {@required this.chartDataSource, @required this.networkInfo});

  @override
  Future<Either<Failure, List<Chart>>> getChart(
      String itemId, String interval, bool convert) async {
    if (await networkInfo.isConnected) {
      try {
        final result =
            await chartDataSource.getChart(itemId, interval, convert);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      } on TooManyRequestException {
        return Left(TooManyRequestFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
