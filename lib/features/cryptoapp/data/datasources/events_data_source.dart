import 'package:cryptoapp/core/error/exceptions.dart';
import 'package:cryptoapp/features/cryptoapp/data/models/events_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract class EventsDataSource {
  Future<EventsModel> getEvents();
}

class EventsDataSourceImpl implements EventsDataSource {
  final http.Client client;

  EventsDataSourceImpl({@required this.client});

  @override
  Future<EventsModel> getEvents() => _getEventsFromUrl(
      'https://api.coingecko.com/api/v3/events?upcoming_events_only=true');

  Future<EventsModel> _getEventsFromUrl(String uri) async {
    final url = Uri.parse(uri);
    final response =
        await client.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return eventsModelFromJson(response.body);
    } else {
      throw ServerException();
    }
  }
}
