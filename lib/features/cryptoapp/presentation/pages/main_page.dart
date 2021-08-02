import 'dart:async';

import 'package:cryptoapp/features/cryptoapp/presentation/bloc/auth/auth_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/favourites/favourites_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/items/items_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/navigationbar/navigationbar_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/pages/crypto_items.page.dart';
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
  ItemsBloc itemsBloc;
  FavouritesBloc favouritesBloc;
  PageController _pageController;

  @override
  void initState() {
    itemsBloc = sl<ItemsBloc>();
    authBloc = sl<AuthBloc>();
    navbarBloc = sl<NavigationbarBloc>();
    favouritesBloc = sl<FavouritesBloc>();
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    authBloc.close();
    navbarBloc.close();
    itemsBloc.close();
    favouritesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawerEnableOpenDragGesture: false,
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
        body: BlocListener<NavigationbarBloc, NavigationbarState>(
            bloc: navbarBloc,
            listener: (context, state) {
              if (state is NavigationbarHome || state is NavigationbarInitial) {
                _pageController.jumpToPage(0);
              }
              if (state is NavigationbarFavourites) {
                _pageController.jumpToPage(1);
              }
              if (state is NavigationbarEvents) {
                _pageController.jumpToPage(2);
              }
            },
            child: PageView(
              physics: BouncingScrollPhysics(),
              controller: _pageController,
              children: [
                CryptoItemsPage(
                  authBloc: authBloc,
                  itemsBloc: itemsBloc,
                ),
                FavouritesPage(
                  authBloc: authBloc,
                  favouritesBloc: favouritesBloc,
                ),
                EventsPage(
                  authBloc: authBloc,
                ),
              ],
            )),
        bottomNavigationBar: BlocBuilder<NavigationbarBloc, NavigationbarState>(
          bloc: navbarBloc,
          builder: (context, state) {
            if (state is NavigationbarHome || state is NavigationbarInitial) {
              return buildNavBar(navbarBloc: navbarBloc, index: 0);
            }
            if (state is NavigationbarFavourites) {
              return buildNavBar(navbarBloc: navbarBloc, index: 1);
            }
            if (state is NavigationbarEvents) {
              return buildNavBar(navbarBloc: navbarBloc, index: 2);
            }
            return Container();
          },
        ));

    // BlocBuilder(
    //     bloc: navbarBloc,
    //     builder: (context, state) {
    //       if (state is NavigationbarHome || state is NavigationbarInitial) {
    //         return GestureDetector(
    //           onTap: () => FocusScope.of(context).unfocus(),
    //           child: buildHomePage(
    //               authBloc, navbarBloc, itemsBloc, context, _textController),
    //         );
    //       } else if (state is NavigationbarFavourites) {
    //         return buildFavouritesPage(authBloc, navbarBloc, favouritesBloc);
    //       } else if (state is NavigationbarEvents) {
    //         return buildEventsPage(authBloc, navbarBloc);
    //       } else {
    //         return Container();
    //       }
    //     });
  }
}

class buildNavBar extends StatelessWidget {
  const buildNavBar({
    Key key,
    @required this.navbarBloc,
    @required this.index,
  }) : super(key: key);

  final NavigationbarBloc navbarBloc;
  final int index;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
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
    );
  }
}
