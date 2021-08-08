import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/converter/converter_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/favourites/favourites_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/crypto_details/details_body.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/show_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class CryptoDetailsPage extends StatelessWidget {
  const CryptoDetailsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FavouritesBloc favouritesBloc = sl<FavouritesBloc>();
    Items item = ModalRoute.of(context).settings.arguments;
    ConverterBloc converterBloc = sl<ConverterBloc>();

    return Scaffold(
        appBar: AppBar(
          title: Text(item.name),
          actions: [
            BlocListener<FavouritesBloc, FavouritesState>(
              bloc: favouritesBloc,
              listener: (context, state) {
                if (state is ErrorModifyingFavouritesState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(buildSnackBar(context, state.message));
                }
              },
              child: BlocBuilder<FavouritesBloc, FavouritesState>(
                  bloc: favouritesBloc
                    ..add(CheckFavouriteEvent(
                        uid: FirebaseAuth.instance.currentUser.uid,
                        itemId: item.id)),
                  buildWhen: (previous, current) {
                    if (current is LoadingFavouritesState ||
                        current is FavouritesFetchedState ||
                        current is ErrorModifyingFavouritesState ||
                        previous is FavouritesState &&
                            current is ErrorFavouritesState ||
                        current is SwitchingFavouriteState) {
                      return false;
                    } else {
                      return true;
                    }
                  },
                  builder: (context, state) {
                    if (state is NotFavouriteState ||
                        state is ErrorFavouritesState) {
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
                  }),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: BlocListener<ConverterBloc, ConverterState>(
              bloc: converterBloc,
              listener: (context, state) {
                if (state is ConverterErrorState) {
                  converterBloc.add(SwitchToUsdEvent());
                  ScaffoldMessenger.of(context)
                      .showSnackBar(buildSnackBar(context, state.message));
                }
              },
              child: BlocBuilder<ConverterBloc, ConverterState>(
                bloc: converterBloc..add(SwitchToUsdEvent()),
                builder: (context, state) {
                  if (state is ConverterUSDState) {
                    return buildBody(item, context, converterBloc, false, "\$");
                  }
                  if (state is ConverterEURState) {
                    return buildBody(
                        state.item, context, converterBloc, true, "€");
                  }
                  return Container();
                },
              ),
            ),
          ),
        ));
  }
}
