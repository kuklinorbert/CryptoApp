import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/items_interval.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/chart/chart_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/converter/converter_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/interval/interval_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/crypto_details/header.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/crypto_details/interval.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/crypto_details/more_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../injection_container.dart';

Column buildBody(Items item, BuildContext context, ConverterBloc converterBloc,
    bool convert, String currency) {
  String format;
  ChartBloc chartBloc = sl<ChartBloc>();
  IntervalBloc intervalBloc = sl<IntervalBloc>();
  DateTime today = new DateTime.now();
  ItemsInterval interval;
  double price = double.parse(item.price);

  if (item.logoUrl.isNotEmpty) {
    format = item.logoUrl.substring(item.logoUrl.length - 3);
  } else {
    format = "null";
  }

  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildHeader(item, context, format),
      SizedBox(
        height: 15,
      ),
      Text(
        ((price <= 0.005)
                ? (price <= 0.00005)
                    ? price.toStringAsFixed(7)
                    : price.toStringAsFixed(5)
                : price.toStringAsFixed(3)) +
            currency,
        style: TextStyle(fontSize: 26),
      ),
      BlocBuilder<IntervalBloc, IntervalState>(
        bloc: intervalBloc,
        builder: (context, state) {
          if (state is OneDayState) {
            interval = item.the1D;
            return buildInterval(context, interval, item, chartBloc, today, 1,
                intervalBloc, converterBloc, convert, currency);
          }
          if (state is OneWeekState) {
            interval = item.the7D;
            return buildInterval(context, interval, item, chartBloc, today, 7,
                intervalBloc, converterBloc, convert, currency);
          }
          if (state is OneMonthState) {
            interval = item.the30D;
            return buildInterval(context, interval, item, chartBloc, today, 30,
                intervalBloc, converterBloc, convert, currency);
          }
          if (state is OneYearState) {
            interval = item.the365D;
            return buildInterval(context, interval, item, chartBloc, today, 365,
                intervalBloc, converterBloc, convert, currency);
          }
          if (state is YearToDayState) {
            interval = item.ytd;
            return buildInterval(context, interval, item, chartBloc, today, 0,
                intervalBloc, converterBloc, convert, currency);
          }
          return Container();
        },
      ),
      SizedBox(
        height: 15,
      ),
      buildMoreDetails(item, context, currency)
    ],
  );
}
