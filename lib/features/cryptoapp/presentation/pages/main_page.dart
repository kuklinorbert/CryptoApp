import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/auth/auth_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/items/items_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/navigationbar/navigationbar_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/pages/events_page.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/pages/favourites_page.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/crypto_item.dart';
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
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    itemsBloc = sl<ItemsBloc>();
    authBloc = sl<AuthBloc>();
    navbarBloc = sl<NavigationbarBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _textController.addListener(() {
      setState(() {});
    });

    return BlocBuilder(
        bloc: navbarBloc,
        builder: (context, state) {
          if (state is NavigationbarHome || state is NavigationbarInitial) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: buildHomePage(
                  authBloc, navbarBloc, itemsBloc, context, _textController),
            );
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
    AuthBloc authBloc,
    NavigationbarBloc navbarBloc,
    ItemsBloc itemsBloc,
    BuildContext context,
    TextEditingController _textController) {
  List<Items> _items = [];
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
            Flexible(
                child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                  labelText: 'Search Text',
                  suffixIcon: _textController.text.length > 0
                      ? IconButton(
                          onPressed: () {
                            _textController.clear();
                            BlocProvider.of<ItemsBloc>(context)
                              ..add(CancelSearchEvent());
                            Future.delayed(Duration.zero, () {
                              FocusScope.of(context).unfocus();
                            });
                          },
                          icon: Icon(Icons.cancel, color: Colors.grey))
                      : null),
              onChanged: (value) {
                if (value.isEmpty) {
                  BlocProvider.of<ItemsBloc>(context)..add(CancelSearchEvent());
                  FocusScope.of(context).unfocus();
                }
              },
              onSubmitted: (value) {
                BlocProvider.of<ItemsBloc>(context)
                  ..add(GetSearchedItemEvent(searchText: value));
              },
            )),
            IconButton(icon: Icon(Icons.sort), onPressed: () {}),
            IconButton(
              icon: Icon(Icons.attach_money),
              onPressed: () {},
            ),
            IconButton(
                icon: Icon(Icons.local_fire_department), onPressed: () {}),
          ]),
        ),
        Expanded(
          child: BlocConsumer<ItemsBloc, ItemsState>(
              listener: (context, state) {},
              builder: (context, state) {
                print(state);
                if (state is LoadingItems && _items.isEmpty ||
                    state is LoadingSearchResult) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is LoadedItems) {
                  _items = state.items;
                  itemsBloc.isFetching = false;
                } else if (state is LoadedSearchItem) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        BlocProvider.of<ItemsBloc>(context)
                          ..add(RefreshSearchEvent());
                      },
                      child: ListView.separated(
                          physics: AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return CryptoItem(state.searchedItem[index]);
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          itemCount: state.searchedItem.length),
                    ),
                  );
                } else if (state is ErrorItems && _items.isEmpty) {
                  return Center(
                    child: Text('Error loading items'),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    BlocProvider.of<ItemsBloc>(context)
                      ..add(RefreshItemsEvent());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListView.separated(
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
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemCount: _items.length),
                  ),
                );
              }),
        ),
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
