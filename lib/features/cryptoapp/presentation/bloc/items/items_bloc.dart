import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/get_items.dart'
    as items;
import 'package:cryptoapp/features/cryptoapp/domain/usecases/get_search_result.dart'
    as search;
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

part 'items_event.dart';
part 'items_state.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final items.GetItems _getItems;
  final search.GetSearchResult _getSearchResult;
  int page = 1;
  bool isFetching = false;
  List<Items> itemList = [];

  ItemsBloc(
      {@required items.GetItems getItems,
      @required search.GetSearchResult getSearchResult})
      : assert(getItems != null, getSearchResult != null),
        _getItems = getItems,
        _getSearchResult = getSearchResult,
        super(ItemsInitial());

  @override
  Stream<ItemsState> mapEventToState(
    ItemsEvent event,
  ) async* {
    if (event is GetItemsEvent) {
      yield LoadingItems();
      final failureOrItems = await _getItems.call(items.Params(page: page));
      yield* _eitherLoadedOrErrorState(failureOrItems);
    }
    if (event is GetSearchedItemEvent) {
      yield LoadingSearchResult();
      final failureOrSearchResult = await _getSearchResult
          .call(search.Params(searchText: event.searchText));
      yield* _eitherSearchResultOrErrorState(failureOrSearchResult);
    }
    if (event is CancelSearchEvent) {
      yield LoadedItems(items: itemList);
    }
  }

  Stream<ItemsState> _eitherSearchResultOrErrorState(
    Either<Failure, List<Items>> failureOrItem,
  ) async* {
    yield failureOrItem.fold(
      (failure) => ErrorItems(message: _mapFailureToMessage(failure)),
      (item) {
        return LoadedSearchItem(searchedItem: item);
      },
    );
  }

  Stream<ItemsState> _eitherLoadedOrErrorState(
    Either<Failure, List<Items>> failureOrItem,
  ) async* {
    yield failureOrItem.fold(
      (failure) => ErrorItems(message: _mapFailureToMessage(failure)),
      (items) {
        page++;
        itemList.addAll(items);
        return LoadedItems(items: itemList);
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
