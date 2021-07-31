import 'package:cryptoapp/core/error/exceptions.dart';
import 'package:cryptoapp/features/cryptoapp/data/models/favourites_model.dart';
import 'package:cryptoapp/features/cryptoapp/data/models/items_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract class FavouritesDataSource {
  Future<List<ItemsModel>> getFavourites(String uid);
  Future<http.Response> addFavourite(
      String uid, FavouritesModel favouritesModel);
  Future<http.Response> removeFavourite(
      String uid, FavouritesModel favouritesModel);
  Future<FavouritesModel> checkFavourites(String uid);
}

class FavouritesDataSourceImpl implements FavouritesDataSource {
  final http.Client client;

  FavouritesDataSourceImpl({@required this.client});

  @override
  Future<List<ItemsModel>> getFavourites(String uid) async {
    String uri =
        'https://cryptoapp-582a9-default-rtdb.europe-west1.firebasedatabase.app/userFavourites/$uid.json';

    String uriItems =
        'https://api.nomics.com/v1/currencies/ticker?key=9b477e525212e4d0ae32ca7dd6f17f9d3e1e4c95&ids=';

    final url = Uri.parse(uri);
    final response =
        await client.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      FavouritesModel model = favouritesModelFromJson(response.body);
      for (final fav in model.favourites) {
        uriItems = uriItems + fav.toUpperCase() + ',';
      }
    } else {
      throw ServerException();
    }
    final urlFinal = Uri.parse(uriItems);

    final responseFinal = await client
        .get(urlFinal, headers: {'Content-Type': 'application/json'});

    if (responseFinal.statusCode == 200) {
      return itemsModelFromJson(responseFinal.body);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<http.Response> removeFavourite(
      String uid, FavouritesModel favouritesModel) async {
    String uri =
        'https://cryptoapp-582a9-default-rtdb.europe-west1.firebasedatabase.app/userFavourites/$uid.json';
    final url = Uri.parse(uri);
    final response = await client.put(url,
        headers: {'Content-Type': 'application/json'},
        body: favouritesModelToJson(favouritesModel));
    if (response.statusCode == 200) {
      return response;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<http.Response> addFavourite(
      String uid, FavouritesModel favouritesModel) async {
    String uri =
        'https://cryptoapp-582a9-default-rtdb.europe-west1.firebasedatabase.app/userFavourites/$uid.json';
    final url = Uri.parse(uri);
    final response = await client.put(url,
        headers: {'Content-Type': 'application/json'},
        body: favouritesModelToJson(favouritesModel));
    if (response.statusCode == 200) {
      return response;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<FavouritesModel> checkFavourites(String uid) async {
    String uri =
        'https://cryptoapp-582a9-default-rtdb.europe-west1.firebasedatabase.app/userFavourites/$uid.json';

    final url = Uri.parse(uri);
    final response =
        await client.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return favouritesModelFromJson(response.body);
    } else {
      throw ServerException();
    }
  }
}
