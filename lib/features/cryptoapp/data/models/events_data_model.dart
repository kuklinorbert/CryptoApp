import 'package:cryptoapp/features/cryptoapp/domain/entities/events_data.dart';
import 'package:flutter/foundation.dart';

class EventsDataModel extends EventsData {
  EventsDataModel({
    @required type,
    @required title,
    @required description,
    @required organizer,
    @required startDate,
    @required endDate,
    @required website,
    @required email,
    @required venue,
    @required address,
    @required city,
    @required country,
    @required screenshot,
  }) : super(
            type: type,
            title: title,
            description: description,
            organizer: organizer,
            startDate: startDate,
            endDate: endDate,
            website: website,
            email: email,
            venue: venue,
            address: address,
            city: city,
            country: country,
            screenshot: screenshot);

  @override
  List<Object> get props => [
        type,
        title,
        description,
        organizer,
        startDate,
        endDate,
        website,
        email,
        venue,
        address,
        city,
        country,
        screenshot
      ];

  factory EventsDataModel.fromJson(Map<String, dynamic> json) =>
      EventsDataModel(
        type: json["type"] == null ? null : json["type"],
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
        organizer: json["organizer"] == null ? null : json["organizer"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        website: json["website"] == null ? null : json["website"],
        email: json["email"] == null ? null : json["email"],
        venue: json["venue"] == null ? null : json["venue"],
        address: json["address"] == null ? null : json["address"],
        city: json["city"] == null ? null : json["city"],
        country: json["country"] == null ? null : json["country"],
        screenshot: json["screenshot"] == null ? null : json["screenshot"],
      );

  Map<String, dynamic> toJson() => {
        "type": type == null ? null : type,
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "organizer": organizer == null ? null : organizer,
        "start_date": startDate == null
            ? null
            : "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "end_date": endDate == null
            ? null
            : "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "website": website == null ? null : website,
        "email": email == null ? null : email,
        "venue": venue == null ? null : venue,
        "address": address == null ? null : address,
        "city": city == null ? null : city,
        "country": country == null ? null : country,
        "screenshot": screenshot == null ? null : screenshot,
      };
}
