import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class ItemsInterval extends Equatable {
  ItemsInterval({
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

  @override
  List<Object> get props => [
        volume,
        priceChange,
        priceChangePct,
        volumeChange,
        volumeChangePct,
        marketCapChange,
        marketCapChangePct
      ];
}
