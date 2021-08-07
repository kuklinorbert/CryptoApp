import 'package:cryptoapp/core/error/exceptions.dart';
import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/core/network/network_info.dart';
import 'package:cryptoapp/features/cryptoapp/data/datasources/favourites_data_source.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/favourites.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/features/cryptoapp/domain/repositories/favourites_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class FavouritesRepositoryImpl implements FavouritesRepository {
  final FavouritesDataSource favouritesDataSource;
  Favourites savedFav = Favourites(favourites: []);
  final NetworkInfo networkInfo;

  FavouritesRepositoryImpl(
      {@required this.favouritesDataSource, @required this.networkInfo});

  @override
  Future<Either<Failure, Response>> addFavourite(
      String uid, String itemId) async {
    if (await networkInfo.isConnected) {
      try {
        savedFav.favourites.add(itemId);
        final result = await favouritesDataSource.addFavourite(uid, savedFav);
        return Right(result);
      } on ServerException {
        savedFav.favourites.remove(itemId);
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Items>>> getFavourites(String uid) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await favouritesDataSource.getFavourites(uid);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Response>> removeFavourite(
      String uid, String itemId) async {
    if (await networkInfo.isConnected) {
      try {
        savedFav.favourites.remove(itemId);
        final result = await favouritesDataSource.addFavourite(uid, savedFav);
        return Right(result);
      } on ServerException {
        savedFav.favourites.add(itemId);
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> checkFavourite(
      String uid, String itemId) async {
    if (savedFav.favourites.isEmpty) {
      if (await networkInfo.isConnected) {
        try {
          final result = await favouritesDataSource.checkFavourites(uid);
          savedFav = result;
        } on ServerException {
          return Left(ServerFailure());
        }
      } else {
        return Left(NetworkFailure());
      }
    }
    if (savedFav.favourites.contains(itemId)) {
      return Right(true);
    } else {
      return Right(false);
    }
  }
}
