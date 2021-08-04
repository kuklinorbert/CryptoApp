part of 'favourites_bloc.dart';

abstract class FavouritesState extends Equatable {
  const FavouritesState();

  @override
  List<Object> get props => [];
}

class FavouritesInitial extends FavouritesState {}

class LoadingFavouritesState extends FavouritesState {}

class FavouritesFetchedState extends FavouritesState {
  final List<Items> favourites;

  FavouritesFetchedState({@required this.favourites});

  List<Object> get props => [favourites];
}

class YesFavouriteState extends FavouritesState {}

class NotFavouriteState extends FavouritesState {}

class SwitchingFavouriteState extends FavouritesState {}

class CheckingFavouriteState extends FavouritesState {}

class ErrorFavouritesState extends FavouritesState {
  final String message;

  ErrorFavouritesState({@required this.message});

  @override
  List<Object> get props => [message];
}

class ErrorModifyingFavouritesState extends FavouritesState {
  final String message;

  ErrorModifyingFavouritesState({@required this.message});

  @override
  List<Object> get props => [message];
}
