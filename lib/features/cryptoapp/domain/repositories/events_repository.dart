import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/events.dart';
import 'package:dartz/dartz.dart';

abstract class EventsRepository {
  Future<Either<Failure, Events>> getEvents();
}
