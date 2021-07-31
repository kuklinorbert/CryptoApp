import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/favourites/favourites_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class CryptoDetailsPage extends StatelessWidget {
  const CryptoDetailsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FavouritesBloc favouritesBloc = sl<FavouritesBloc>();
    Items item = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(item.name),
          actions: [
            BlocBuilder<FavouritesBloc, FavouritesState>(
                bloc: favouritesBloc
                  ..add(CheckFavouriteEvent(
                      uid: FirebaseAuth.instance.currentUser.uid,
                      itemId: item.id)),
                buildWhen: (previous, current) {
                  if (current is LoadingFavouritesState ||
                      current is FavouritesFetchedState) {
                    return false;
                  } else {
                    return true;
                  }
                },
                builder: (context, state) {
                  if (state is NotFavouriteState) {
                    return IconButton(
                        onPressed: () {
                          favouritesBloc.add(AddFavouriteEvent(
                              itemId: item.id,
                              uid: FirebaseAuth.instance.currentUser.uid));
                        },
                        icon: Icon(Icons.favorite_outline));
                  }
                  if (state is YesFavouriteState) {
                    return IconButton(
                        onPressed: () {
                          favouritesBloc.add(RemoveFavouriteEvent(
                              itemId: item.id,
                              uid: FirebaseAuth.instance.currentUser.uid));
                        },
                        icon: Icon(Icons.favorite));
                  }
                  return Container();
                })
          ],
        ),
        body: Container());
  }
}
