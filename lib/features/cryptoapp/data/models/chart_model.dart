import 'package:cryptoapp/features/cryptoapp/domain/entities/chart.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

List<ChartModel> chartModelFromJson(String str) =>
    List<ChartModel>.from(json.decode(str).map((x) => ChartModel.fromJson(x)));

String chartModelToJson(List<ChartModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChartModel extends Chart {
  ChartModel({
    @required this.currency,
    @required this.timestamps,
    @required this.prices,
  });

  final String currency;
  final List<DateTime> timestamps;
  final List<String> prices;

  factory ChartModel.fromJson(Map<String, dynamic> json) => ChartModel(
        currency: json["currency"] == null ? null : json["currency"],
        timestamps: json["timestamps"] == null
            ? null
            : List<DateTime>.from(
                json["timestamps"].map((x) => DateTime.parse(x))),
        prices: json["prices"] == null
            ? null
            : List<String>.from(json["prices"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "currency": currency == null ? null : currency,
        "timestamps": timestamps == null
            ? null
            : List<dynamic>.from(timestamps.map((x) => x.toIso8601String())),
        "prices":
            prices == null ? null : List<dynamic>.from(prices.map((x) => x)),
      };
}
