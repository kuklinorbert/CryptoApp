import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/items/items_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/crypto_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

ListView listViewSeparated(
    BuildContext context, List<Items> items, ItemsBloc itemsBloc) {
  final ScrollController _scrollController = ScrollController();
  return ListView.separated(
      controller: _scrollController
        ..addListener(() {
          if (_scrollController.offset ==
                  _scrollController.position.maxScrollExtent &&
              !itemsBloc.isFetching) {
            BlocProvider.of<ItemsBloc>(context).add(GetItemsEvent());
            itemsBloc.isFetching = true;
          }
        }),
      itemBuilder: (context, index) {
        return index >= items.length - 1
            ? (itemsBloc.isError == false)
                ? Center(
                    child: Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: CircularProgressIndicator(),
                  ))
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: IconButton(
                        icon: Icon(
                          Icons.refresh,
                          size: 35,
                        ),
                        onPressed: () {
                          itemsBloc.isError = false;
                          BlocProvider.of<ItemsBloc>(context)
                              .add(GetItemsEvent());
                        },
                      ),
                    ),
                  )
            : CryptoItem(items[index]);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: items.length);
}
