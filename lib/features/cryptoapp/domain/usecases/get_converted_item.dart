import 'package:cryptoapp/core/error/failures.dart';
import 'package:cryptoapp/core/usecases/usecase.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/features/cryptoapp/domain/repositories/converter_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GetConvertedItem extends UseCase<List<Items>, Params> {
  final ConverterRepository converterRepository;

  GetConvertedItem(this.converterRepository);
  @override
  Future<Either<Failure, List<Items>>> call(Params params) async {
    return await converterRepository.getConvertedItem(params.itemId);
  }
}

class Params extends Equatable {
  final String itemId;

  Params({@required this.itemId});

  @override
  List<Object> get props => [itemId];
}
