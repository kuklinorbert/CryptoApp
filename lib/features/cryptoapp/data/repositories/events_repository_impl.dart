import 'package:cryptoapp/core/error/exceptions.dart';
import 'package:cryptoapp/core/network/network_info.dart';
import 'package:cryptoapp/features/cryptoapp/data/datasources/events_data_source.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/events.dart';
import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/features/cryptoapp/domain/repositories/events_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class EventsRepositoryImpl implements EventsRepository {
  final NetworkInfo networkInfo;
  final EventsDataSource eventsDataSource;

  EventsRepositoryImpl(
      {@required this.eventsDataSource, @required this.networkInfo});

  @override
  Future<Either<Failure, Events>> getEvents() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await eventsDataSource.getEvents();
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }
}
