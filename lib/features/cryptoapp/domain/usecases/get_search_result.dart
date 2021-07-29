import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/core/usecases/usecase.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/features/cryptoapp/domain/repositories/items_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class GetSearchResult extends UseCase<List<Items>, Params> {
  final ItemsRepository itemsRepository;
  GetSearchResult(this.itemsRepository);
  @override
  Future<Either<Failure, List<Items>>> call(params) async {
    return await itemsRepository.getSearchResult(params.searchText);
  }
}

class Params extends Equatable {
  final String searchText;

  Params({@required this.searchText});

  @override
  List<Object> get props => [searchText];
}
