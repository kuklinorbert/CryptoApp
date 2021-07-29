import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:dartz/dartz.dart';

abstract class ItemsRepository {
  Future<Either<Failure, List<Items>>> getItems(int page);
  Future<Either<Failure, List<Items>>> getSearchResult(String searchText);
}
