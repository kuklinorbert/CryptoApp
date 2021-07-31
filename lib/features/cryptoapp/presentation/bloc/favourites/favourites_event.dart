part of 'favourites_bloc.dart';

abstract class FavouritesEvent extends Equatable {
  const FavouritesEvent();

  @override
  List<Object> get props => [];
}

class GetFavouritesEvent extends FavouritesEvent {
  final String uid;

  GetFavouritesEvent({@required this.uid});

  @override
  List<Object> get props => [uid];
}

class CheckFavouriteEvent extends FavouritesEvent {
  final String uid;
  final String itemId;

  CheckFavouriteEvent({@required this.uid, @required this.itemId});

  @override
  List<Object> get props => [uid, itemId];
}

class AddFavouriteEvent extends FavouritesEvent {
  final String uid;
  final String itemId;

  AddFavouriteEvent({@required this.uid, @required this.itemId});

  @override
  List<Object> get props => [uid, itemId];
}

class RemoveFavouriteEvent extends FavouritesEvent {
  final String uid;
  final String itemId;

  RemoveFavouriteEvent({@required this.uid, @required this.itemId});

  @override
  List<Object> get props => [uid, itemId];
}
