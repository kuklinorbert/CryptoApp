import 'package:cryptoapp/features/cryptoapp/domain/entities/events_data.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Events extends Equatable {
  Events({
    @required this.data,
    @required this.count,
    @required this.page,
  });

  final List<EventsData> data;
  final int count;
  final int page;

  @override
  List<Object> get props => [data, count, page];
}
