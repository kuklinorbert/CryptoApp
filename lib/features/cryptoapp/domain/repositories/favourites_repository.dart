import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/favourites.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';

abstract class FavouritesRepository {
  Future<Either<Failure, List<Items>>> getFavourites(String uid);
  Future<Either<Failure, Response>> addFavourite(String uid, String itemId);
  Future<Either<Failure, Response>> removeFavourite(String uid, String itemId);
}
