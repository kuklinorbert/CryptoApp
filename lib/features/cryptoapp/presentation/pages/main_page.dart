import 'package:cryptoapp/features/cryptoapp/presentation/bloc/auth/auth_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/favourites/favourites_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/items/items_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/navigationbar/navigationbar_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/pages/crypto_items.page.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/pages/events_page.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/pages/favourites_page.dart';
import 'package:easy_localization/easy_localization.dart';
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
              Text(
                FirebaseAuth.instance.currentUser.phoneNumber,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 5,
              ),
              Divider(),
              SizedBox(
                height: 15,
              ),
              Text(
                "lang".tr(),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 5,
              ),
              ListTile(
                title: Text(
                  "en".tr(),
                  style: (EasyLocalization.of(context).locale.toString() ==
                          "en")
                      ? TextStyle(fontSize: 17, fontWeight: FontWeight.w500)
                      : TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                onTap: () {
                  EasyLocalization.of(context).setLocale(Locale('en'));
                },
              ),
              ListTile(
                title: Text('hu'.tr(),
                    style: (EasyLocalization.of(context).locale.toString() ==
                            "hu")
                        ? TextStyle(fontSize: 17, fontWeight: FontWeight.w500)
                        : TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                onTap: () {
                  EasyLocalization.of(context).setLocale(Locale('hu'));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text(
                  "logout".tr(),
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/auth', (route) => false);

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
              onPageChanged: (index) {
                if (index == 0) navbarBloc.add(HomeSelected());
                if (index == 1) navbarBloc.add(FavouritesSelected());
                if (index == 2) navbarBloc.add(EventsSelected());
              },
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
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'.tr()),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite), label: 'favourites'.tr()),
        BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'events'.tr()),
      ],
    );
  }
}
