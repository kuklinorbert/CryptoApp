import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/get_items.dart'
    as items;
import 'package:cryptoapp/features/cryptoapp/domain/usecases/get_search_result.dart'
    as search;
import 'package:cryptoapp/features/cryptoapp/domain/usecases/refresh_items.dart'
    as refresh;
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';

part 'items_event.dart';
part 'items_state.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final items.GetItems _getItems;
  final search.GetSearchResult _getSearchResult;
  final refresh.RefreshItems _refreshItems;
  int page = 1;
  bool isFetching = false;
  List<Items> itemList = [];
  String lastSearch;

  ItemsBloc(
      {@required items.GetItems getItems,
      @required search.GetSearchResult getSearchResult,
      @required refresh.RefreshItems refreshItems})
      : assert(getItems != null, getSearchResult != null),
        _getItems = getItems,
        _getSearchResult = getSearchResult,
        _refreshItems = refreshItems,
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
      yield Loading();
      lastSearch = event.searchText;
      final failureOrSearchResult = await _getSearchResult
          .call(search.Params(searchText: event.searchText));
      yield* _eitherSearchResultOrErrorState(failureOrSearchResult);
    }
    if (event is CancelSearchEvent) {
      yield LoadedItems(items: itemList);
    }
    if (event is RefreshSearchEvent) {
      yield Loading();
      final failureOrSearchResult =
          await _getSearchResult.call(search.Params(searchText: lastSearch));
      yield* _eitherSearchResultOrErrorState(failureOrSearchResult);
    }
    if (event is RefreshItemsEvent) {
      yield Loading();
      final failureOrItems =
          await _refreshItems.call(refresh.Params(page: page));
      yield* _eitherRefreshOrErrorState(failureOrItems);
    }
  }

  Stream<ItemsState> _eitherRefreshOrErrorState(
    Either<Failure, List<Items>> failureOrItem,
  ) async* {
    yield failureOrItem.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (items) {
        itemList = items;
        return LoadedItems(items: itemList);
      },
    );
  }

  Stream<ItemsState> _eitherSearchResultOrErrorState(
    Either<Failure, List<Items>> failureOrItem,
  ) async* {
    yield failureOrItem.fold(
      (failure) => SearchError(message: _mapFailureToMessage(failure)),
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
      case NetworkFailure:
        return "error_network".tr();
      case ServerFailure:
        return "error_server".tr();
      case SearchFailure:
        return "error_search".tr();
      default:
        return 'error_unexp'.tr();
    }
  }
}
