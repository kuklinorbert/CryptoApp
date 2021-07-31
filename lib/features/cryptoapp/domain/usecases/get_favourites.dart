import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/core/usecases/usecase.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/favourites.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/features/cryptoapp/domain/repositories/favourites_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class GetFavourites extends UseCase<List<Items>, Params> {
  final FavouritesRepository favouritesRepository;

  GetFavourites(this.favouritesRepository);

  @override
  Future<Either<Failure, List<Items>>> call(Params params) async {
    return await favouritesRepository.getFavourites(params.uid);
  }
}

class Params {
  final String uid;
  Params({@required this.uid});

  @override
  List<Object> get props => [uid];
}
