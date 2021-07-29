import 'package:cryptoapp/core/error/exceptions.dart';
import 'package:cryptoapp/core/network/network_info.dart';
import 'package:cryptoapp/features/cryptoapp/data/datasources/items_data_source.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/features/cryptoapp/domain/repositories/items_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class ItemsRepositoryImpl implements ItemsRepository {
  final NetworkInfo networkInfo;
  final ItemsDataSource itemsDataSource;

  ItemsRepositoryImpl(
      {@required this.networkInfo, @required this.itemsDataSource});

  @override
  Future<Either<Failure, List<Items>>> getItems(int page) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await itemsDataSource.getItems(page);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Items>>> getSearchResult(
      String searchText) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await itemsDataSource.getSearchResult(searchText);
        if (result.isNotEmpty) {
          return Right(result);
        } else {
          return Left(ServerFailure());
        }
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Items>>> refreshItems(int page) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await itemsDataSource.refreshItems(page);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }
}
