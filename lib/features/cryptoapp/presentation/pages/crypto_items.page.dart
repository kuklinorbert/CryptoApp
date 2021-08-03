import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/auth/auth_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/items/items_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/crypto_item.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/searchBar.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    List<Items> items = [];

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
          searchBar(items, context, textController),
          Expanded(
            child:
                BlocConsumer<ItemsBloc, ItemsState>(listener: (context, state) {
              if (state is ErrorItems) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(buildSnackBar(context, state.message));
              }
              if (state is Error) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(buildSnackBar(context, state.message));
              }
            }, builder: (context, state) {
              if (state is LoadingItems && items.isEmpty || state is Loading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is LoadedItems) {
                items = state.items;
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
              } else if (state is ErrorItems && items.isEmpty) {
                return IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    BlocProvider.of<ItemsBloc>(context)..add(GetItemsEvent());
                  },
                );
              } else if (state is SearchError) {
                return Center(
                    child: Text(state.message, style: TextStyle(fontSize: 20)));
              }
              return RefreshIndicator(
                onRefresh: () async {
                  BlocProvider.of<ItemsBloc>(context)..add(RefreshItemsEvent());
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: listViewSeparated(context, items),
                ),
              );
            }),
          ),
        ]),
      ),
    );
  }

  ListView listViewSeparated(BuildContext context, List<Items> items) {
    return ListView.separated(
        controller: _scrollController
          ..addListener(() {
            if (_scrollController.offset ==
                    _scrollController.position.maxScrollExtent &&
                !widget.itemsBloc.isFetching) {
              BlocProvider.of<ItemsBloc>(context).add(GetItemsEvent());
              widget.itemsBloc.isFetching = true;
            }
          }),
        itemBuilder: (context, index) {
          return index >= items.length - 1
              ? Center(child: CircularProgressIndicator())
              : CryptoItem(items[index]);
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: items.length);
  }
}
