import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Chart extends Equatable {
  Chart({
    @required this.currency,
    @required this.timestamps,
    @required this.prices,
  });

  final String currency;
  final List<DateTime> timestamps;
  final List<String> prices;

  @override
  List<Object> get props => [currency, timestamps, prices];
}
