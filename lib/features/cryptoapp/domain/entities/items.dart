import 'package:cryptoapp/features/cryptoapp/domain/entities/items_interval.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Items extends Equatable {
  Items({
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
  final ItemsInterval the1D;
  final ItemsInterval the7D;
  final ItemsInterval the30D;
  final ItemsInterval the365D;
  final ItemsInterval ytd;

  @override
  // TODO: implement props
  List<Object> get props => [
        id,
        currency,
        symbol,
        name,
        logoUrl,
        status,
        price,
        priceDate,
        priceTimestamp,
        circulatingSupply,
        maxSupply,
        marketCap,
        marketCapDominance,
        numExchanges,
        numPairs,
        numPairsUnmapped,
        firstCandle,
        firstTrade,
        firstOrderBook,
        rank,
        rankDelta,
        high,
        highTimestamp,
        the1D,
        the7D,
        the30D,
        the365D,
        ytd
      ];
}
