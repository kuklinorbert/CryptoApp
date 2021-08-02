import 'package:cryptoapp/features/cryptoapp/presentation/bloc/auth/auth_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/favourites/favourites_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/crypto_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            listener: (context, state) {
              print(state);
              if (state is YesFavouriteState) {
                widget.favouritesBloc.add(GetFavouritesEvent(
                    uid: FirebaseAuth.instance.currentUser.uid));
              }
              if (state is NotFavouriteState) {
                widget.favouritesBloc.add(GetFavouritesEvent(
                    uid: FirebaseAuth.instance.currentUser.uid));
              }
            },
            child: BlocBuilder<FavouritesBloc, FavouritesState>(
              bloc: widget.favouritesBloc
                ..add(GetFavouritesEvent(
                    uid: FirebaseAuth.instance.currentUser.uid)),
              builder: (context, state) {
                if (state is LoadingFavouritesState) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is FavouritesFetchedState) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return CryptoItem(state.favourites[index]);
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemCount: state.favourites.length),
                  );
                }
                return Center(
                  child: Text('No favourites added yet!'),
                );
              },
            )));
  }
}
