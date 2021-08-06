import 'package:cryptoapp/features/cryptoapp/presentation/bloc/auth/auth_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/favourites/favourites_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/crypto_item.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/show_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage(
      {Key key, @required this.authBloc, @required this.favouritesBloc})
      : super(key: key);

  final AuthBloc authBloc;
  final FavouritesBloc favouritesBloc;

  @override
  _FavouritesPage1State createState() => _FavouritesPage1State();
}

class _FavouritesPage1State extends State<FavouritesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var userId = FirebaseAuth.instance.currentUser.uid;
    return BlocListener<AuthBloc, AuthState>(
        bloc: widget.authBloc,
        listener: (context, state) {
          if (state is Unauthenticated) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/auth', (route) => false);
          }
        },
        child: BlocListener<FavouritesBloc, FavouritesState>(
            bloc: widget.favouritesBloc,
            listenWhen: (previous, current) {
              if (previous is SwitchingFavouriteState &&
                      current is NotFavouriteState ||
                  previous is SwitchingFavouriteState &&
                      current is YesFavouriteState) {
                return true;
              } else {
                return false;
              }
            },
            listener: (context, state) {
              print("favourites listener: " + state.toString());

              if (state is YesFavouriteState || state is NotFavouriteState) {
                widget.favouritesBloc.add(GetFavouritesEvent(uid: userId));
              }
              if (state is ErrorFavouritesState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(buildSnackBar(context, state.message));
              }
            },
            child: BlocBuilder<FavouritesBloc, FavouritesState>(
              bloc: widget.favouritesBloc..add(GetFavouritesEvent(uid: userId)),
              buildWhen: (previous, current) {
                if (current is YesFavouriteState ||
                    current is CheckingFavouriteState ||
                    current is NotFavouriteState) {
                  return false;
                } else {
                  return true;
                }
              },
              builder: (context, state) {
                print("favourites builder: " + state.toString());
                if (state is LoadingFavouritesState) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is FavouritesFetchedState) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: (state.favourites.isEmpty)
                        ? Center(
                            child: Text(
                              "no_fav".tr(),
                              style: TextStyle(fontSize: 20),
                            ),
                          )
                        : ListView.separated(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return CryptoItem(state.favourites[index]);
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemCount: state.favourites.length),
                  );
                }
                if (state is ErrorFavouritesState) {
                  return Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.refresh,
                        size: 35,
                      ),
                      onPressed: () {
                        widget.favouritesBloc
                            .add(GetFavouritesEvent(uid: userId));
                      },
                    ),
                  );
                }
                return Container();
              },
            )));
  }
}
