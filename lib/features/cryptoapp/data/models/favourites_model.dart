import 'package:cryptoapp/features/cryptoapp/domain/entities/favourites.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

FavouritesModel favouritesModelFromJson(String str) =>
    FavouritesModel.fromJson(json.decode(str));

String favouritesModelToJson(FavouritesModel data) =>
    json.encode(data.toJson());

class FavouritesModel extends Favourites {
  FavouritesModel({
    @required this.favourites,
  });

  final List<String> favourites;

  factory FavouritesModel.fromJson(Map<String, dynamic> json) =>
      FavouritesModel(
        favourites: json["favourites"] == null
            ? null
            : List<String>.from(json["favourites"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "favourites": favourites == null
            ? null
            : List<dynamic>.from(favourites.map((x) => x)),
      };
}
