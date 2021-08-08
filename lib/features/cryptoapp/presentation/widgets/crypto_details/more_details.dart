import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/formatters.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

Column buildMoreDetails(Items item, BuildContext context, String currency) {
  TextStyle defaultStyle = TextStyle(fontSize: 16);
  double highest = double.parse(item.high);
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "circ_supply".tr() +
            ((item.circulatingSupply == null)
                ? " - "
                : formatLongNumber(item.circulatingSupply, context)),
        style: defaultStyle,
      ),
      SizedBox(
        height: 5,
      ),
      item.maxSupply != null
          ? Text("max_supply".tr() + formatLongNumber(item.maxSupply, context),
              style: defaultStyle)
          : Text("max_supply".tr() + " - ", style: defaultStyle),
      SizedBox(height: 5),
      Divider(),
      SizedBox(
        height: 5,
      ),
      Text(
        "highest".tr() +
            ((highest <= 0.005)
                ? (highest <= 0.00005)
                    ? NumberFormat("###,##0.000####").format(highest)
                    : NumberFormat("###,##0.000##").format(highest)
                : NumberFormat("###,##0.000").format(highest)) +
            " $currency",
        style: defaultStyle,
      ),
      Text(
        "date".tr() + formatDate(item.highTimestamp, context),
        style: defaultStyle,
      ),
      SizedBox(height: 5),
      Divider(),
      SizedBox(
        height: 5,
      ),
      Text("num_exch".tr() + item.numExchanges, style: defaultStyle),
      Text("num_pairs".tr() + item.numPairs, style: defaultStyle),
      Text("num_pairs_unmap".tr() + item.numPairsUnmapped, style: defaultStyle),
      SizedBox(height: 5),
      Divider(),
      SizedBox(
        height: 5,
      ),
      Text(
          "first_trade".tr() +
              ((item.firstTrade == null)
                  ? " - "
                  : formatDate(item.firstTrade, context)),
          style: defaultStyle),
      Text(
          "first_candle".tr() +
              ((item.firstCandle == null)
                  ? " - "
                  : formatDate(item.firstCandle, context)),
          style: defaultStyle),
      Text(
          "first_order".tr() +
              ((item.firstOrderBook == null)
                  ? " - "
                  : formatDate(item.firstOrderBook, context)),
          style: defaultStyle),
      SizedBox(height: 10),
    ],
  );
}
