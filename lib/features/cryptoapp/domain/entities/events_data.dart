import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class EventsData extends Equatable {
  EventsData({
    @required this.type,
    @required this.title,
    @required this.description,
    @required this.organizer,
    @required this.startDate,
    @required this.endDate,
    @required this.website,
    @required this.email,
    @required this.venue,
    @required this.address,
    @required this.city,
    @required this.country,
    @required this.screenshot,
  });

  final String type;
  final String title;
  final String description;
  final String organizer;
  final DateTime startDate;
  final DateTime endDate;
  final String website;
  final String email;
  final String venue;
  final String address;
  final String city;
  final String country;
  final String screenshot;

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
}
