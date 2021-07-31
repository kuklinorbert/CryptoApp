import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/core/usecases/usecase.dart';
import 'package:cryptoapp/features/cryptoapp/domain/repositories/favourites_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class CheckFavourite extends UseCase<bool, Params> {
  final FavouritesRepository favouritesRepository;

  CheckFavourite(this.favouritesRepository);
  @override
  Future<Either<Failure, bool>> call(Params params) async {
    return await favouritesRepository.checkFavourite(params.uid, params.itemId);
  }
}

class Params {
  final String uid;
  final String itemId;

  Params({@required this.uid, @required this.itemId});

  List<Object> get props => [uid, itemId];
}
