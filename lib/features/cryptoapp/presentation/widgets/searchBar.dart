import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/items/items_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

Padding searchBar(List<Items> items, BuildContext context,
    TextEditingController textController) {
  return Padding(
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
                          LoadedItems(items: items);
                          BlocProvider.of<ItemsBloc>(context)
                            ..add(CancelSearchEvent());
                          Future.delayed(Duration.zero, () {
                            FocusScope.of(context).unfocus();
                          });
                        },
                        icon: Icon(Icons.cancel, color: Colors.grey)),
                  )
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
      IconButton(icon: Icon(Icons.local_fire_department), onPressed: () {}),
    ]),
  );
}
