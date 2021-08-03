import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/favourites.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/add_favourite.dart'
    as add;
import 'package:cryptoapp/features/cryptoapp/domain/usecases/check_favourite.dart'
    as check;
import 'package:cryptoapp/features/cryptoapp/domain/usecases/get_favourites.dart'
    as getfav;
import 'package:cryptoapp/features/cryptoapp/domain/usecases/remove_favourite.dart'
    as remove;
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:easy_localization/easy_localization.dart';

part 'favourites_event.dart';
part 'favourites_state.dart';

class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {
  final add.AddFavourite _addFavourite;
  final getfav.GetFavourites _getFavourites;
  final check.CheckFavourite _checkFavourite;
  final remove.RemoveFavourite _removeFavourite;

  Favourites favourites;

  FavouritesBloc(
      {@required add.AddFavourite addFavourite,
      @required getfav.GetFavourites getFavourites,
      @required check.CheckFavourite checkFavourite,
      @required remove.RemoveFavourite removeFavourite})
      : assert(getFavourites != null, checkFavourite != null),
        _addFavourite = addFavourite,
        _getFavourites = getFavourites,
        _checkFavourite = checkFavourite,
        _removeFavourite = removeFavourite,
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
      yield* _eitherAddOrErrorState(failureOrResponse);
    }
    if (event is RemoveFavouriteEvent) {
      final failureOrResponse = await _removeFavourite
          .call(remove.Params(uid: event.uid, itemId: event.itemId));
      yield* _eitherRemoveOrErrorState(failureOrResponse);
    }
    if (event is CheckFavouriteEvent) {
      yield LoadingFavouritesState();
      final failureOrBool = await _checkFavourite
          .call(check.Params(uid: event.uid, itemId: event.itemId));
      yield* _eitherBoolOrErrorState(failureOrBool);
    }
  }

  Stream<FavouritesState> _eitherBoolOrErrorState(
    Either<Failure, bool> failureOrBool,
  ) async* {
    yield failureOrBool.fold(
      (failure) => ErrorFavouritesState(message: _mapFailureToMessage(failure)),
      (bool) {
        if (bool) {
          return YesFavouriteState();
        } else {
          return NotFavouriteState();
        }
      },
    );
  }

  Stream<FavouritesState> _eitherListOrErrorState(
    Either<Failure, List<Items>> failureOrFavourites,
  ) async* {
    yield failureOrFavourites.fold(
      (failure) => ErrorFavouritesState(message: _mapFailureToMessage(failure)),
      (response) {
        return FavouritesFetchedState(favourites: response);
      },
    );
  }

  Stream<FavouritesState> _eitherAddOrErrorState(
    Either<Failure, Response> failureOrAdd,
  ) async* {
    yield failureOrAdd.fold(
      (failure) =>
          ErrorModifyingFavouritesState(message: _mapFailureToMessage(failure)),
      (response) => YesFavouriteState(),
    );
  }

  Stream<FavouritesState> _eitherRemoveOrErrorState(
    Either<Failure, Response> failureOrRemove,
  ) async* {
    yield failureOrRemove.fold(
      (failure) =>
          ErrorModifyingFavouritesState(message: _mapFailureToMessage(failure)),
      (response) => NotFavouriteState(),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return "error_network".tr();
      case ServerFailure:
        return "error_server".tr();
      default:
        return 'error_unexp'.tr();
    }
  }
}
