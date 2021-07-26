import 'package:cryptoapp/features/cryptoapp/domain/entities/events.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

import 'events_data_model.dart';

// Map<String, EventsModel> itemFromJson(String str) => Map.from(json.decode(str))
//     .map((k, v) => MapEntry<String, EventsModel>(k, EventsModel.fromJson(v)));

// String itemToJson(Map<String, Events> data) => json.encode(
//     Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

EventsModel eventsModelFromJson(String str) =>
    EventsModel.fromJson(json.decode(str));

String eventsModelToJson(EventsModel data) => json.encode(data.toJson());

class EventsModel extends Events {
  EventsModel({
    @required this.data,
    @required this.count,
    @required this.page,
  }) : super(data: data, count: count, page: page);

  final List<EventsDataModel> data;
  final int count;
  final int page;

  factory EventsModel.fromJson(Map<String, dynamic> json) => EventsModel(
        data: json["data"] == null
            ? null
            : List<EventsDataModel>.from(
                json["data"].map((x) => EventsDataModel.fromJson(x))),
        count: json["count"] == null ? null : json["count"],
        page: json["page"] == null ? null : json["page"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
        "count": count == null ? null : count,
        "page": page == null ? null : page,
      };
}
