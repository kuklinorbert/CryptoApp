import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:dartz/dartz.dart';

abstract class ConverterRepository {
  Future<Either<Failure, List<Items>>> getConvertedItem(String itemId);
}
