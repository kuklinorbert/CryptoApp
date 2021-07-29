import 'package:cryptoapp/core/error/exceptions.dart';
import 'package:cryptoapp/features/cryptoapp/data/models/items_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

abstract class ItemsDataSource {
  Future<List<ItemsModel>> getItems(int page);
}

class ItemsDataSourceImpl implements ItemsDataSource {
  final http.Client client;
  final int perPage = 10;

  ItemsDataSourceImpl({@required this.client});

  @override
  Future<List<ItemsModel>> getItems(int page) => _getEventsFromUrl(
      'https://api.nomics.com/v1/currencies/ticker?key=9b477e525212e4d0ae32ca7dd6f17f9d3e1e4c95&sort=rank&per-page=$perPage&page=$page');

  Future<List<ItemsModel>> _getEventsFromUrl(String uri) async {
    final url = Uri.parse(uri);
    final response =
        await client.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return itemsModelFromJson(response.body);
    } else {
      throw ServerException();
    }
  }
}
