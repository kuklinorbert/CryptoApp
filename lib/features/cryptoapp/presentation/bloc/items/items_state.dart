part of 'items_bloc.dart';

abstract class ItemsState extends Equatable {
  const ItemsState();

  @override
  List<Object> get props => [];
}

class ItemsInitial extends ItemsState {}

class LoadingItems extends ItemsState {}

class LoadedItems extends ItemsState {
  final List<Items> items;

  LoadedItems({@required this.items});

  @override
  List<Object> get props => [items];
}

class ErrorItems extends ItemsState {
  final String message;

  ErrorItems({@required this.message});

  @override
  List<Object> get props => [message];
}

class LoadingSearchResult extends ItemsState {}

class LoadedSearchItem extends ItemsState {
  final List<Items> searchedItem;

  LoadedSearchItem({@required this.searchedItem});

  @override
  List<Object> get props => [searchedItem];
}
