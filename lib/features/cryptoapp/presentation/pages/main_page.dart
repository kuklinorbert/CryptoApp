import 'package:cryptoapp/features/cryptoapp/presentation/bloc/auth/auth_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/navigationbar/navigationbar_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/pages/events_page.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/pages/favourites_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  AuthBloc authBloc;
  NavigationbarBloc navbarBloc;

  @override
  void initState() {
    authBloc = sl<AuthBloc>();
    navbarBloc = sl<NavigationbarBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: navbarBloc,
        builder: (context, state) {
          print(state);
          if (state is NavigationbarHome || state is NavigationbarInitial) {
            return buildHomePage(authBloc, navbarBloc);
          } else if (state is NavigationbarFavourites) {
            return buildFavouritesPage(authBloc, navbarBloc);
          } else if (state is NavigationbarEvents) {
            return buildEventsPage(authBloc, navbarBloc);
          } else {
            return Container();
          }
        });
  }
}

Scaffold buildHomePage(AuthBloc authBloc, NavigationbarBloc navbarBloc) {
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
        child:
            Column(mainAxisAlignment: MainAxisAlignment.center, children: []),
      ),
    ),
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: 0,
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
