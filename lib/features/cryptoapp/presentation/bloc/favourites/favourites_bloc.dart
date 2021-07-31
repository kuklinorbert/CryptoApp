import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/favourites.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/add_favourite.dart'
    as add;
import 'package:cryptoapp/features/cryptoapp/domain/usecases/get_favourites.dart'
    as getfav;
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

part 'favourites_event.dart';
part 'favourites_state.dart';

class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {
  final add.AddFavourite _addFavourite;
  final getfav.GetFavourites _getFavourites;

  Favourites favourites;

  FavouritesBloc(
      {@required add.AddFavourite addFavourite,
      @required getfav.GetFavourites getFavourites})
      : assert(getFavourites != null, addFavourite != null),
        _addFavourite = addFavourite,
        _getFavourites = getFavourites,
        super(FavouritesInitial());

  @override
  Stream<FavouritesState> mapEventToState(
    FavouritesEvent event,
  ) async* {
    if (event is GetFavouritesEvent) {
      yield LoadingFavouritesState();
      final failureOrFavourites =
          await _getFavourites.call(getfav.Params(uid: event.uid));
      yield* _eitherListOrErrorState(failureOrFavourites);
    }
    if (event is AddFavouriteEvent) {
      final failureOrResponse = await _addFavourite
          .call(add.Params(uid: event.uid, itemId: event.itemId));
      yield* _eitherFavouriteOrErrorState(failureOrResponse);
    }
  }

  Stream<FavouriteState> _eitherListOrErrorState(
    Either<Failure, List<Items>> failureOrFavourites,
  ) async* {
    yield failureOrFavourites.fold(
      (failure) => ErrorFavouritesState(message: _mapFailureToMessage(failure)),
      (response) {
        return FavouritesFetchedState(favourites: response);
      },
    );
  }

  Stream<FavouriteState> _eitherFavouriteOrErrorState(
    Either<Failure, Response> failureOrResponse,
  ) async* {
    yield failureOrResponse.fold(
      (failure) => ErrorFavouritesState(message: _mapFailureToMessage(failure)),
      (response) => FavouriteState(),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      default:
        return 'Unexpected error';
    }
  }
}
