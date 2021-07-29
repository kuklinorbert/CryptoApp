import 'package:cryptoapp/features/cryptoapp/domain/entities/items_interval.dart';
import 'package:flutter/foundation.dart';

class ItemsIntervalModel extends ItemsInterval {
  ItemsIntervalModel({
    @required this.volume,
    @required this.priceChange,
    @required this.priceChangePct,
    @required this.volumeChange,
    @required this.volumeChangePct,
    @required this.marketCapChange,
    @required this.marketCapChangePct,
  });

  final String volume;
  final String priceChange;
  final String priceChangePct;
  final String volumeChange;
  final String volumeChangePct;
  final String marketCapChange;
  final String marketCapChangePct;

  factory ItemsIntervalModel.fromJson(Map<String, dynamic> json) =>
      ItemsIntervalModel(
        volume: json["volume"] == null ? null : json["volume"],
        priceChange: json["price_change"] == null ? null : json["price_change"],
        priceChangePct:
            json["price_change_pct"] == null ? null : json["price_change_pct"],
        volumeChange:
            json["volume_change"] == null ? null : json["volume_change"],
        volumeChangePct: json["volume_change_pct"] == null
            ? null
            : json["volume_change_pct"],
        marketCapChange: json["market_cap_change"] == null
            ? null
            : json["market_cap_change"],
        marketCapChangePct: json["market_cap_change_pct"] == null
            ? null
            : json["market_cap_change_pct"],
      );

  Map<String, dynamic> toJson() => {
        "volume": volume == null ? null : volume,
        "price_change": priceChange == null ? null : priceChange,
        "price_change_pct": priceChangePct == null ? null : priceChangePct,
        "volume_change": volumeChange == null ? null : volumeChange,
        "volume_change_pct": volumeChangePct == null ? null : volumeChangePct,
        "market_cap_change": marketCapChange == null ? null : marketCapChange,
        "market_cap_change_pct":
            marketCapChangePct == null ? null : marketCapChangePct,
      };
}
