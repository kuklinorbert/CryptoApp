import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/items_interval.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/chart/chart_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/converter/converter_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/interval/interval_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/crypto_details/chart.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/formatters.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/toggle_switch_currencies.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/toggle_switch_intervals.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

Column buildInterval(
    BuildContext context,
    ItemsInterval interval,
    Items item,
    ChartBloc chartBloc,
    DateTime today,
    int days,
    IntervalBloc intervalBloc,
    ConverterBloc converterBloc,
    bool convert,
    String currency) {
  List<FlSpot> data = [];
  DateTime chartInterval;
  TextStyle defaultTextStyle = TextStyle(fontSize: 16);

  (days == 0)
      ? chartInterval = DateTime(DateTime.now().year)
      : chartInterval = today.subtract(Duration(days: days));

  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(
      children: [
        (interval == null || interval.priceChange == null)
            ? Container()
            : Text(formatNumber(interval.priceChange) + currency,
                style: styleText(interval.priceChange)),
        SizedBox(width: 15),
        (interval == null || interval.priceChangePct == null)
            ? Container()
            : Text(formatPercentage(interval.priceChangePct),
                style: styleText(interval.priceChangePct)),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            "rank".tr() + ((item.rank == null) ? " - " : item.rank),
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 18),
          ),
        )
      ],
    ),
    Divider(),
    buildChart(chartBloc, item, chartInterval, convert, data, days, currency),
    Divider(),
    SizedBox(
      height: 15,
    ),
    buildSwitchInterval(intervalBloc),
    SizedBox(
      height: 25,
    ),
    buildSwitchCurrencies(
      converterBloc,
      item.id.toString(),
      convert,
    ),
    SizedBox(
      height: 10,
    ),
    Text(
        "volume".tr() +
            ((interval == null || interval.volume == null)
                ? " - "
                : currency + formatLongNumber(interval.volume, context)),
        style: TextStyle(fontSize: 20)),
    Row(
      children: [
        Text(
          "change".tr(),
          style: TextStyle(fontSize: 18),
        ),
        (interval == null || interval.volumeChange == null)
            ? Text(
                " - ",
                style: defaultTextStyle,
              )
            : Text(currency + formatLongNumber(interval.volumeChange, context),
                style: styleText(interval.volumeChange)),
        SizedBox(width: 15),
        (interval == null || interval.volumeChangePct == null)
            ? Container()
            : Text(formatPercentage(interval.volumeChangePct),
                style: styleText(interval.volumeChangePct))
      ],
    ),
    SizedBox(
      height: 10,
    ),
    Text(
        "market_cap".tr() +
            ((item.marketCap == null)
                ? " - "
                : currency + formatLongNumber(item.marketCap, context)),
        style: TextStyle(fontSize: 20)),
    Row(
      children: [
        Text(
          "change".tr(),
          style: TextStyle(fontSize: 18),
        ),
        (interval == null || interval.marketCapChange == null)
            ? Text(
                " - ",
                style: defaultTextStyle,
              )
            : Text(
                currency + formatLongNumber(interval.marketCapChange, context),
                style: styleText(interval.marketCapChange)),
        SizedBox(width: 15),
        (interval == null || interval.marketCapChangePct == null)
            ? Container()
            : Text(
                formatPercentage(interval.marketCapChangePct),
                style: styleText(interval.marketCapChangePct),
              )
      ],
    ),
    SizedBox(
      height: 5,
    ),
    Text(
      "dominance".tr() +
          ((item.marketCapDominance == null)
              ? " - "
              : NumberFormat("#0.00%")
                  .format(double.parse(item.marketCapDominance))),
      style: defaultTextStyle,
    ),
    SizedBox(
      height: 10,
    ),
    Divider()
  ]);
}
