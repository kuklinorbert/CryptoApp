part of 'favourites_bloc.dart';

abstract class FavouritesState extends Equatable {
  const FavouritesState();

  @override
  List<Object> get props => [];
}

class FavouritesInitial extends FavouritesState {}

class LoadingFavouritesState extends FavouritesState {}

class FavouritesFetchedState extends FavouriteState {
  final List<Items> favourites;

  FavouritesFetchedState({@required this.favourites});

  List<Object> get props => [favourites];
}

class FavouriteState extends FavouritesState {}

class NotFavouriteState extends FavouriteState {}

class ErrorFavouritesState extends FavouriteState {
  final String message;

  ErrorFavouritesState({@required this.message});

  @override
  List<Object> get props => [message];
}
