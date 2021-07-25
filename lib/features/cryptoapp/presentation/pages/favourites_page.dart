import 'package:cryptoapp/features/cryptoapp/presentation/bloc/auth/auth_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/navigationbar/navigationbar_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      title: Text('CryptoApp'),
    ),
    body: BlocListener<AuthBloc, AuthState>(
      bloc: authBloc,
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/auth', (route) => false);
        }
      },
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Favourites')]),
      ),
    ),
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
