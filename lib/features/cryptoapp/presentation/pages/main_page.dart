import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/features/cryptoapp/domain/usecases/get_items.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/auth/auth_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/items/items_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/navigationbar/navigationbar_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/pages/events_page.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/pages/favourites_page.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/crypto_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

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

  @override
  void initState() {
    itemsBloc = sl<ItemsBloc>();
    authBloc = sl<AuthBloc>();
    navbarBloc = sl<NavigationbarBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: navbarBloc,
        builder: (context, state) {
          if (state is NavigationbarHome || state is NavigationbarInitial) {
            return buildHomePage(authBloc, navbarBloc, itemsBloc);
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

Scaffold buildHomePage(
    AuthBloc authBloc, NavigationbarBloc navbarBloc, ItemsBloc itemsBloc) {
  final List<Items> _items = [];
  final ScrollController _scrollController = ScrollController();

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
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(children: [
            Flexible(child: TextField()),
            IconButton(icon: Icon(Icons.sort), onPressed: () {}),
            IconButton(
              icon: Icon(Icons.attach_money),
              onPressed: () {},
            ),
            IconButton(
                icon: Icon(Icons.local_fire_department),
                onPressed: () {
                  itemsBloc..add(GetItemsEvent());
                }),
          ]),
        ),
        Expanded(
          child: BlocConsumer<ItemsBloc, ItemsState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is ItemsInitial ||
                    state is LoadingItems && _items.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is LoadedItems) {
                  _items.addAll(state.items);
                  itemsBloc.isFetching = false;
                } else if (state is ErrorItems && _items.isEmpty) {
                  return Center(
                    child: Text('Error loading items'),
                  );
                }
                return Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.separated(
                            shrinkWrap: true,
                            controller: _scrollController
                              ..addListener(() {
                                if (_scrollController.offset ==
                                        _scrollController
                                            .position.maxScrollExtent &&
                                    !itemsBloc.isFetching) {
                                  BlocProvider.of<ItemsBloc>(context)
                                      .add(GetItemsEvent());
                                  itemsBloc.isFetching = true;
                                }
                              }),
                            itemBuilder: (context, index) {
                              return index >= _items.length - 1
                                  ? Center(child: CircularProgressIndicator())
                                  : CryptoItem(_items[index]);
                            },
                            // itemBuilder: (context, index) =>
                            //     CryptoItem(_items[index]),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemCount: _items.length),
                      ),
                    ),
                  ],
                );
              }),
        ),
        // BlocBuilder<ItemsBloc, ItemsState>(
        //     bloc: itemsBloc..add(GetItemsEvent()),
        //     buildWhen: (previous, current) {
        //       if (previous is LoadedItems) {
        //         return false;
        //       } else {
        //         return true;
        //       }
        //     },
        //     builder: (context, state) {
        //       if (state is ItemsInitial) {
        //         return Center(child: Text('Items'));
        //       } else if (state is LoadingItems) {
        //         return Center(
        //           child: CircularProgressIndicator(),
        //         );
        //       } else if (state is LoadedItems) {
        //         return Center(
        //           child: Text(state.items[0].name),
        //         );
        //       } else {
        //         return Container();
        //       }
        //     }),
      ]),
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
