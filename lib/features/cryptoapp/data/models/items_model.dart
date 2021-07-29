import 'package:cryptoapp/features/cryptoapp/data/models/items_interval_model.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

List<ItemsModel> itemsModelFromJson(String str) =>
    List<ItemsModel>.from(json.decode(str).map((x) => ItemsModel.fromJson(x)));

String itemsModelToJson(List<ItemsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemsModel extends Items {
  ItemsModel({
    @required this.id,
    @required this.currency,
    @required this.symbol,
    @required this.name,
    @required this.logoUrl,
    @required this.status,
    @required this.price,
    @required this.priceDate,
    @required this.priceTimestamp,
    @required this.circulatingSupply,
    @required this.maxSupply,
    @required this.marketCap,
    @required this.marketCapDominance,
    @required this.numExchanges,
    @required this.numPairs,
    @required this.numPairsUnmapped,
    @required this.firstCandle,
    @required this.firstTrade,
    @required this.firstOrderBook,
    @required this.rank,
    @required this.rankDelta,
    @required this.high,
    @required this.highTimestamp,
    @required this.the1D,
    @required this.the7D,
    @required this.the30D,
    @required this.the365D,
    @required this.ytd,
  });

  final String id;
  final String currency;
  final String symbol;
  final String name;
  final String logoUrl;
  final String status;
  final String price;
  final DateTime priceDate;
  final DateTime priceTimestamp;
  final String circulatingSupply;
  final String maxSupply;
  final String marketCap;
  final String marketCapDominance;
  final String numExchanges;
  final String numPairs;
  final String numPairsUnmapped;
  final DateTime firstCandle;
  final DateTime firstTrade;
  final DateTime firstOrderBook;
  final String rank;
  final String rankDelta;
  final String high;
  final DateTime highTimestamp;
  final ItemsIntervalModel the1D;
  final ItemsIntervalModel the7D;
  final ItemsIntervalModel the30D;
  final ItemsIntervalModel the365D;
  final ItemsIntervalModel ytd;

  factory ItemsModel.fromJson(Map<String, dynamic> json) => ItemsModel(
        id: json["id"] == null ? null : json["id"],
        currency: json["currency"] == null ? null : json["currency"],
        symbol: json["symbol"] == null ? null : json["symbol"],
        name: json["name"] == null ? null : json["name"],
        logoUrl: json["logo_url"] == null ? null : json["logo_url"],
        status: json["status"] == null ? null : json["status"],
        price: json["price"] == null ? null : json["price"],
        priceDate: json["price_date"] == null
            ? null
            : DateTime.parse(json["price_date"]),
        priceTimestamp: json["price_timestamp"] == null
            ? null
            : DateTime.parse(json["price_timestamp"]),
        circulatingSupply: json["circulating_supply"] == null
            ? null
            : json["circulating_supply"],
        maxSupply: json["max_supply"] == null ? null : json["max_supply"],
        marketCap: json["market_cap"] == null ? null : json["market_cap"],
        marketCapDominance: json["market_cap_dominance"] == null
            ? null
            : json["market_cap_dominance"],
        numExchanges:
            json["num_exchanges"] == null ? null : json["num_exchanges"],
        numPairs: json["num_pairs"] == null ? null : json["num_pairs"],
        numPairsUnmapped: json["num_pairs_unmapped"] == null
            ? null
            : json["num_pairs_unmapped"],
        firstCandle: json["first_candle"] == null
            ? null
            : DateTime.parse(json["first_candle"]),
        firstTrade: json["first_trade"] == null
            ? null
            : DateTime.parse(json["first_trade"]),
        firstOrderBook: json["first_order_book"] == null
            ? null
            : DateTime.parse(json["first_order_book"]),
        rank: json["rank"] == null ? null : json["rank"],
        rankDelta: json["rank_delta"] == null ? null : json["rank_delta"],
        high: json["high"] == null ? null : json["high"],
        highTimestamp: json["high_timestamp"] == null
            ? null
            : DateTime.parse(json["high_timestamp"]),
        the1D:
            json["1d"] == null ? null : ItemsIntervalModel.fromJson(json["1d"]),
        the7D:
            json["7d"] == null ? null : ItemsIntervalModel.fromJson(json["7d"]),
        the30D: json["30d"] == null
            ? null
            : ItemsIntervalModel.fromJson(json["30d"]),
        the365D: json["365d"] == null
            ? null
            : ItemsIntervalModel.fromJson(json["365d"]),
        ytd: json["ytd"] == null
            ? null
            : ItemsIntervalModel.fromJson(json["ytd"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "currency": currency == null ? null : currency,
        "symbol": symbol == null ? null : symbol,
        "name": name == null ? null : name,
        "logo_url": logoUrl == null ? null : logoUrl,
        "status": status == null ? null : status,
        "price": price == null ? null : price,
        "price_date": priceDate == null ? null : priceDate.toIso8601String(),
        "price_timestamp":
            priceTimestamp == null ? null : priceTimestamp.toIso8601String(),
        "circulating_supply":
            circulatingSupply == null ? null : circulatingSupply,
        "max_supply": maxSupply == null ? null : maxSupply,
        "market_cap": marketCap == null ? null : marketCap,
        "market_cap_dominance":
            marketCapDominance == null ? null : marketCapDominance,
        "num_exchanges": numExchanges == null ? null : numExchanges,
        "num_pairs": numPairs == null ? null : numPairs,
        "num_pairs_unmapped":
            numPairsUnmapped == null ? null : numPairsUnmapped,
        "first_candle":
            firstCandle == null ? null : firstCandle.toIso8601String(),
        "first_trade": firstTrade == null ? null : firstTrade.toIso8601String(),
        "first_order_book":
            firstOrderBook == null ? null : firstOrderBook.toIso8601String(),
        "rank": rank == null ? null : rank,
        "rank_delta": rankDelta == null ? null : rankDelta,
        "high": high == null ? null : high,
        "high_timestamp":
            highTimestamp == null ? null : highTimestamp.toIso8601String(),
        "1d": the1D == null ? null : the1D.toJson(),
        "7d": the7D == null ? null : the7D.toJson(),
        "30d": the30D == null ? null : the30D.toJson(),
        "365d": the365D == null ? null : the365D.toJson(),
        "ytd": ytd == null ? null : ytd.toJson(),
      };
}
