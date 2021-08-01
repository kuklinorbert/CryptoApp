import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/chart.dart';
import 'package:dartz/dartz.dart';

abstract class ChartRepository {
  Future<Either<Failure, List<Chart>>> getChart(String itemId, String interval);
}
