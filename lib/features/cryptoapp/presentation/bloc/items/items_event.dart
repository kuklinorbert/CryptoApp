part of 'items_bloc.dart';

abstract class ItemsEvent extends Equatable {
  const ItemsEvent();

  @override
  List<Object> get props => [];
}

class GetItemsEvent extends ItemsEvent {}

class GetSearchedItemEvent extends ItemsEvent {
  final String searchText;

  GetSearchedItemEvent({@required this.searchText});

  @override
  List<Object> get props => [searchText];
}

class CancelSearchEvent extends ItemsEvent {}
