import 'package:cryptoapp/core/error/exceptions.dart';
import 'package:cryptoapp/features/cryptoapp/data/models/chart_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract class ChartDataSource {
  Future<List<ChartModel>> getChart(String itemId, String interval);
}

class ChartDataSourceImpl implements ChartDataSource {
  final http.Client client;

  ChartDataSourceImpl({@required this.client});

  @override
  Future<List<ChartModel>> getChart(String itemId, String interval) async {
    final url =
        'https://api.nomics.com/v1/currencies/sparkline?key=9b477e525212e4d0ae32ca7dd6f17f9d3e1e4c95&ids=$itemId&start=$interval';
    final uri = Uri.parse(url);
    final response =
        await client.get(uri, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return chartModelFromJson(response.body);
    } else {
      throw ServerException();
    }
  }
}
