import 'package:cryptoapp/core/error/exceptions.dart';
import 'package:cryptoapp/features/cryptoapp/data/models/items_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

abstract class ItemsDataSource {
  Future<List<ItemsModel>> getItems(int page);
  Future<List<ItemsModel>> getSearchResult(String searchText);
  Future<List<ItemsModel>> refreshItems(int page);
  Future<List<ItemsModel>> getConvertedItem(String itemId);
}

class ItemsDataSourceImpl implements ItemsDataSource {
  final http.Client client;
  final int perPage = 10;
  int refreshCount;

  ItemsDataSourceImpl({@required this.client});

  @override
  Future<List<ItemsModel>> getItems(int page) => _getItemsFromUrl(
      'https://api.nomics.com/v1/currencies/ticker?key=9b477e525212e4d0ae32ca7dd6f17f9d3e1e4c95&sort=rank&per-page=$perPage&page=$page');

  Future<List<ItemsModel>> _getItemsFromUrl(String uri) async {
    final url = Uri.parse(uri);
    final response =
        await client.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return itemsModelFromJson(response.body);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<ItemsModel>> getSearchResult(String searchText) {
    searchText = searchText.toUpperCase();
    searchText = searchText.replaceAll(" ", "");
    return _getItemsFromUrl(
        'https://api.nomics.com/v1/currencies/ticker?key=9b477e525212e4d0ae32ca7dd6f17f9d3e1e4c95&ids=$searchText');
  }

  @override
  Future<List<ItemsModel>> refreshItems(int page) {
    (page > 3) ? refreshCount = 30 : refreshCount = page * 10;
    return _getItemsFromUrl(
        'https://api.nomics.com/v1/currencies/ticker?key=9b477e525212e4d0ae32ca7dd6f17f9d3e1e4c95&sort=rank&per-page=$refreshCount');
  }

  @override
  Future<List<ItemsModel>> getConvertedItem(String itemId) => _getItemsFromUrl(
      'https://api.nomics.com/v1/currencies/ticker?key=9b477e525212e4d0ae32ca7dd6f17f9d3e1e4c95&ids=$itemId&convert=EUR');
}
