import 'package:cryptoapp/core/error/exceptions.dart';
import 'package:cryptoapp/core/network/network_info.dart';
import 'package:cryptoapp/features/cryptoapp/data/datasources/items_data_source.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/features/cryptoapp/domain/repositories/converter_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class ConverterRepositoryImpl implements ConverterRepository {
  final NetworkInfo networkInfo;
  final ItemsDataSource itemsDataSource;

  List<Items> converted = [];

  ConverterRepositoryImpl(
      {@required this.networkInfo, @required this.itemsDataSource});

  @override
  Future<Either<Failure, List<Items>>> getConvertedItem(String itemId) async {
    if (converted.isNotEmpty) {
      if (converted[0].id == itemId) {
        return Right(converted);
      }
    }
    if (await networkInfo.isConnected) {
      try {
        final result = await itemsDataSource.getConvertedItem(itemId);
        converted = result;
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
