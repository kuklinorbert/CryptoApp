import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/auth/auth_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/items/items_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/navigationbar/navigationbar_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/crypto_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class CryptoItemsPage extends StatefulWidget {
  const CryptoItemsPage(
      {Key key, @required this.authBloc, @required this.itemsBloc})
      : super(key: key);

  final AuthBloc authBloc;
  final ItemsBloc itemsBloc;

  @override
  _CryptoItemsPageState createState() => _CryptoItemsPageState();
}

class _CryptoItemsPageState extends State<CryptoItemsPage>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);

    textController.addListener(() {
      setState(() {});
    });

    List<Items> _items = [];

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocListener<AuthBloc, AuthState>(
        bloc: widget.authBloc,
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
                controller: textController,
                decoration: InputDecoration(
                    labelText: 'search'.tr(),
                    suffixIcon: textController.text.length > 0
                        ? Padding(
                            padding: EdgeInsets.only(
                              top: 15,
                            ),
                            child: IconButton(
                                onPressed: () {
                                  textController.clear();
                                  BlocProvider.of<ItemsBloc>(context)
                                    ..add(RefreshItemsEvent());
                                  Future.delayed(Duration.zero, () {
                                    FocusScope.of(context).unfocus();
                                  });
                                },
                                icon: Icon(Icons.cancel, color: Colors.grey)),
                          )
                        : null),
                onChanged: (value) {
                  if (value.isEmpty) {
                    BlocProvider.of<ItemsBloc>(context)
                      ..add(CancelSearchEvent());
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
            child:
                BlocConsumer<ItemsBloc, ItemsState>(listener: (context, state) {
              print(state);
            }, builder: (context, state) {
              if (state is LoadingItems && _items.isEmpty ||
                  state is LoadingSearchResult) {
                return Center(child: CircularProgressIndicator());
              } else if (state is LoadedItems) {
                _items = state.items;
                widget.itemsBloc.isFetching = false;
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
              } else if (state is ErrorItems) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('error_load'.tr()),
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () {
                        BlocProvider.of<ItemsBloc>(context)
                          ..add(GetItemsEvent());
                      },
                    )
                  ],
                );
              } else if (state is ErrorItems && _items.isEmpty) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('error_load'.tr()),
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () {
                        BlocProvider.of<ItemsBloc>(context)
                          ..add(GetItemsEvent());
                      },
                    )
                  ],
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  BlocProvider.of<ItemsBloc>(context)..add(RefreshItemsEvent());
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListView.separated(
                      controller: _scrollController
                        ..addListener(() {
                          if (_scrollController.offset ==
                                  _scrollController.position.maxScrollExtent &&
                              !widget.itemsBloc.isFetching) {
                            BlocProvider.of<ItemsBloc>(context)
                                .add(GetItemsEvent());
                            widget.itemsBloc.isFetching = true;
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
    );
  }
}
