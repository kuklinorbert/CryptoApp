import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/get_items.dart'
    as items;
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

part 'items_event.dart';
part 'items_state.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final items.GetItems _getItems;
  int page = 1;
  bool isFetching = false;

  ItemsBloc({@required items.GetItems getItems})
      : assert(getItems != null),
        _getItems = getItems,
        super(ItemsInitial());

  @override
  Stream<ItemsState> mapEventToState(
    ItemsEvent event,
  ) async* {
    if (event is GetItemsEvent) {
      print('im in getitemsevent');
      yield LoadingItems();
      final failureOrItems = await _getItems.call(items.Params(page: page));
      yield* _eitherLoadedOrErrorState(failureOrItems);
    }
  }

  Stream<ItemsState> _eitherLoadedOrErrorState(
    Either<Failure, List<Items>> failureOrItem,
  ) async* {
    yield failureOrItem.fold(
      (failure) => ErrorItems(message: _mapFailureToMessage(failure)),
      (items) {
        page++;
        return LoadedItems(items: items);
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      default:
        return 'Unexpected error';
    }
  }
}
