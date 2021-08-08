import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/auth/auth_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/items/items_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/crypto_item.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/list_view.dart';
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
      onTap: () => FocusManager.instance.primaryFocus.unfocus(),
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
                widget.itemsBloc.isError = true;
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
                widget.itemsBloc.isError = false;
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
                  icon: Icon(
                    Icons.refresh,
                    size: 35,
                  ),
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
                  child: listViewSeparated(context, items, widget.itemsBloc),
                ),
              );
            }),
          ),
        ]),
      ),
    );
  }
}
