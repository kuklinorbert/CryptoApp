import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/core/usecases/usecase.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/events.dart';
import 'package:cryptoapp/features/cryptoapp/domain/repositories/events_repository.dart';
import 'package:dartz/dartz.dart';

class GetEvents extends UseCase<Events, NoParams> {
  final EventsRepository eventsRepository;

  GetEvents(this.eventsRepository);

  @override
  Future<Either<Failure, Events>> call(NoParams noParams) async {
    return await eventsRepository.getEvents();
  }
}
