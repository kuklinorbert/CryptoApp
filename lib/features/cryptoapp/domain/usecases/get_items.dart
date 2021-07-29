import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/core/usecases/usecase.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/features/cryptoapp/domain/repositories/items_repository.dart';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GetItems extends UseCase<List<Items>, Params> {
  final ItemsRepository itemsRepository;

  GetItems(this.itemsRepository);

  @override
  Future<Either<Failure, List<Items>>> call(Params params) async {
    return await itemsRepository.getItems(params.page);
  }
}

class Params extends Equatable {
  final int page;

  Params({@required this.page});

  @override
  List<Object> get props => [page];
}
