import 'package:cryptoapp/features/cryptoapp/presentation/bloc/auth/auth_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/favourites/favourites_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/navigationbar/navigationbar_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/crypto_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

Scaffold buildFavouritesPage(AuthBloc authBloc, NavigationbarBloc navbarBloc) {
  return Scaffold(
    drawer: Drawer(
      child: ListView(
        padding: EdgeInsets.only(top: 50, left: 15),
        children: [
          Text(FirebaseAuth.instance.currentUser.phoneNumber),
          Divider(),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              authBloc.add(LogoutEvent());
            },
          )
        ],
      ),
    ),
    appBar: AppBar(
      title: Text('Favourites'),
    ),
    body: BlocListener<AuthBloc, AuthState>(
        bloc: authBloc,
        listener: (context, state) {
          if (state is Unauthenticated) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/auth', (route) => false);
          }
        },
        child: BlocBuilder<FavouritesBloc, FavouritesState>(
          bloc: sl<FavouritesBloc>()
            ..add(
                GetFavouritesEvent(uid: FirebaseAuth.instance.currentUser.uid)),
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
        )),
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: 1,
      onTap: (index) {
        if (index == 0) navbarBloc.add(HomeSelected());
        if (index == 1) navbarBloc.add(FavouritesSelected());
        if (index == 2) navbarBloc.add(EventsSelected());
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite), label: 'Favourites'),
        BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Events'),
      ],
    ),
  );
}
