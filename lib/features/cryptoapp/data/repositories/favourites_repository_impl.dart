import 'package:cryptoapp/core/error/exceptions.dart';
import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/features/cryptoapp/data/datasources/favourites_data_source.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/favourites.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/features/cryptoapp/domain/repositories/favourites_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class FavouritesRepositoryImpl implements FavouritesRepository {
  final FavouritesDataSource favouritesDataSource;

  FavouritesRepositoryImpl({@required this.favouritesDataSource});

  @override
  Future<Either<Failure, Response>> addFavourite(
      String uid, String itemId) async {
    try {
      final result = await favouritesDataSource.addFavourite(uid, itemId);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Items>>> getFavourites(String uid) async {
    try {
      final result = await favouritesDataSource.getFavourites(uid);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Response>> removeFavourite(String uid, String itemId) {
    // TODO: implement removeFavourite
    throw UnimplementedError();
  }
}
