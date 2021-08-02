import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/items_interval.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/chart/chart_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/converter/converter_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/favourites/favourites_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/interval/interval_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../../injection_container.dart';

class CryptoDetailsPage extends StatelessWidget {
  const CryptoDetailsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FavouritesBloc favouritesBloc = sl<FavouritesBloc>();
    Items item = ModalRoute.of(context).settings.arguments;

    ConverterBloc converterBloc = sl<ConverterBloc>();

    return Scaffold(
        appBar: AppBar(
          title: Text(item.name),
          actions: [
            BlocBuilder<FavouritesBloc, FavouritesState>(
                bloc: favouritesBloc

                // ..add(CheckFavouriteEvent(
                //     uid: FirebaseAuth.instance.currentUser.uid,
                //     itemId: item.id))
                ,
                buildWhen: (previous, current) {
                  if (current is LoadingFavouritesState ||
                      current is FavouritesFetchedState) {
                    return false;
                  } else {
                    return true;
                  }
                },
                builder: (context, state) {
                  if (state is NotFavouriteState ||
                      state is ErrorFavouritesState) {
                    return IconButton(
                        onPressed: () {
                          favouritesBloc.add(AddFavouriteEvent(
                              itemId: item.id,
                              uid: FirebaseAuth.instance.currentUser.uid));
                        },
                        icon: Icon(Icons.favorite_outline));
                  }
                  if (state is YesFavouriteState) {
                    return IconButton(
                        onPressed: () {
                          favouritesBloc.add(RemoveFavouriteEvent(
                              itemId: item.id,
                              uid: FirebaseAuth.instance.currentUser.uid));
                        },
                        icon: Icon(Icons.favorite));
                  }
                  return Container();
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: BlocBuilder<ConverterBloc, ConverterState>(
              bloc: converterBloc..add(SwitchToUsdEvent()),
              builder: (context, state) {
                if (state is ConverterUSDState) {
                  return buildBody(item, context, converterBloc, false, "\$");
                }
                if (state is ConverterEURState) {
                  return buildBody(
                      state.item, context, converterBloc, true, "€");
                }
                return Container();
              },
            ),
          ),
        ));
  }
}

Column buildBody(Items item, BuildContext context, ConverterBloc converterBloc,
    bool convert, String currency) {
  String format = item.logoUrl.substring(item.logoUrl.length - 3);
  ChartBloc chartBloc = sl<ChartBloc>();
  IntervalBloc intervalBloc = sl<IntervalBloc>();
  DateTime today = new DateTime.now();
  TextStyle defaultStyle = TextStyle(fontSize: 16);
  ItemsInterval interval;

  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
                ),
                Text(item.currency + " • " + item.status,
                    style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 2.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.height * 0.10,
              height: MediaQuery.of(context).size.height * 0.10,
              child: (format == 'svg')
                  ? SvgPicture.network(
                      item.logoUrl,
                      fit: BoxFit.fill,
                    )
                  : Image.network(
                      item.logoUrl,
                      fit: BoxFit.fill,
                    ),
            ),
          ),
        ],
      ),
      SizedBox(
        height: 15,
      ),
      Text(
        double.parse(item.price).toStringAsFixed(3) + currency,
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
      Text(
        "Circulating supply: " + formatLongNumber(item.circulatingSupply),
        style: defaultStyle,
      ),
      SizedBox(
        height: 5,
      ),
      item.maxSupply != null
          ? Text("Max supply: " + formatLongNumber(item.maxSupply),
              style: defaultStyle)
          : Text("Max supply: " + " - ", style: defaultStyle),
      SizedBox(height: 5),
      Divider(),
      SizedBox(
        height: 5,
      ),
      Text(
        "All time high: " +
            NumberFormat("###,##0.00").format(double.parse(item.high)) +
            " $currency",
        style: defaultStyle,
      ),
      Text(
        "Date: " +
            item.highTimestamp
                .toIso8601String()
                .substring(0, 10)
                .replaceAll("-", "/"),
        style: defaultStyle,
      ),
      SizedBox(height: 5),
      Divider(),
      SizedBox(
        height: 5,
      ),
      Text("Num exchanges: " + item.numExchanges, style: defaultStyle),
      Text("Num pairs: " + item.numPairs, style: defaultStyle),
      Text("Num pairs unmapped: " + item.numPairsUnmapped, style: defaultStyle),
      SizedBox(height: 5),
      Divider(),
      SizedBox(
        height: 5,
      ),
      Text(
          "First trade: " +
              item.firstTrade
                  .toIso8601String()
                  .substring(0, 10)
                  .replaceAll("-", "/"),
          style: defaultStyle),
      Text(
          "First candle: " +
              item.firstCandle
                  .toIso8601String()
                  .substring(0, 10)
                  .replaceAll("-", "/"),
          style: defaultStyle),
      Text(
          "First order book: " +
              item.firstOrderBook
                  .toIso8601String()
                  .substring(0, 10)
                  .replaceAll("-", "/"),
          style: defaultStyle),
      SizedBox(height: 10),
    ],
  );
}

class buildSwitchCurrencies extends StatelessWidget {
  const buildSwitchCurrencies(
      {Key key,
      @required this.converterBloc,
      @required this.itemId,
      this.switchNum})
      : super(key: key);

  final ConverterBloc converterBloc;
  final String itemId;
  final bool switchNum;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ToggleSwitch(
        activeFgColor: Colors.white,
        activeBgColor: [Colors.green],
        inactiveBgColor: Colors.grey[300],
        totalSwitches: 2,
        cornerRadius: 25,
        initialLabelIndex: switchNum ? 1 : 0,
        labels: ['\$', '€'],
        onToggle: (index) {
          if (index == 0) {
            converterBloc.add(SwitchToUsdEvent());
          } else {
            converterBloc.add(SwitchToEurEvent(itemId: itemId));
          }
        },
      ),
    );
  }
}

class buildSwitchInterval extends StatelessWidget {
  const buildSwitchInterval({
    Key key,
    @required this.intervalBloc,
  }) : super(key: key);

  final IntervalBloc intervalBloc;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ToggleSwitch(
        totalSwitches: 5,
        initialLabelIndex: intervalBloc.index,
        borderColor: [Colors.blue],
        inactiveBgColor: Colors.grey[200],
        borderWidth: 2,
        cornerRadius: 25,
        labels: ['1D', '7D', '30D', '365D', 'ytd'],
        onToggle: (index) {
          intervalBloc.add(SwitchIntervalEvent(interval: index));
        },
      ),
    );
  }
}

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
  (days == 0)
      ? chartInterval = DateTime(DateTime.now().year)
      : chartInterval = today.subtract(Duration(days: days));

  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(
      children: [
        Text(formatNumber(interval.priceChange) + currency,
            style: styleText(interval.priceChange)),
        SizedBox(width: 15),
        Text(formatPercentage(interval.priceChangePct),
            style: styleText(interval.priceChangePct)),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            "Rank #" + item.rank,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 18),
          ),
        )
      ],
    ),
    Divider(),
    BlocBuilder<ChartBloc, ChartState>(
        bloc: chartBloc
          ..add(GetChartEvent(
              itemId: item.id,
              interval: chartInterval.toUtc().toIso8601String(),
              convert: convert)),
        buildWhen: (previous, current) {
          if (previous is ChartLoadedState) {
            return false;
          } else {
            return true;
          }
        },
        builder: (context, state) {
          if (state is ChartLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ChartLoadedState) {
            if (data.isNotEmpty) {
              data = [];
            }
            int index = 0;
            double min = double.parse(state.chart[0].prices[0]);
            double max = double.parse(state.chart[0].prices[0]);

            for (var priceData in state.chart[0].prices) {
              data.add(FlSpot(index.toDouble(), double.parse(priceData)));
              if (double.parse(priceData) < min) {
                min = double.parse(priceData);
              }
              if (double.parse(priceData) > max) {
                max = double.parse(priceData);
              }
              index++;
            }

            return Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
                child: LineChart(
                  LineChartData(
                    minY: min * 0.99,
                    maxY: max * 1.01,
                    lineTouchData: LineTouchData(getTouchLineStart:
                        (data, index) {
                      return 0;
                    }, getTouchLineEnd: (data, index) {
                      return double.infinity;
                    }, touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        final flSpot = barSpot;
                        return LineTooltipItem(
                            state.chart[0].timestamps[flSpot.x.toInt()]
                                    .toString()
                                    .substring(0, 10) +
                                "\n",
                            TextStyle(fontSize: 13, color: Colors.black),
                            children: [
                              TextSpan(
                                  text: flSpot.y.toStringAsFixed(3) + currency)
                            ]);
                      }).toList();
                    })),
                    titlesData: FlTitlesData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                          spots: data,
                          barWidth: 2,
                          dotData: FlDotData(show: false)),
                    ],
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                  ),
                ),
              ),
            );
          }
          return Container();
        }),
    Divider(),
    SizedBox(
      height: 15,
    ),
    buildSwitchInterval(intervalBloc: intervalBloc),
    SizedBox(
      height: 25,
    ),
    buildSwitchCurrencies(
      converterBloc: converterBloc,
      itemId: item.id.toString(),
      switchNum: convert,
    ),
    SizedBox(
      height: 10,
    ),
    Text("Volume: " + currency + formatLongNumber(interval.volume),
        style: TextStyle(fontSize: 20)),
    Row(
      children: [
        Text(
          "Change: ",
          style: TextStyle(fontSize: 18),
        ),
        Text(
            currency +
                formatLongNumber(
                  interval.volumeChange,
                ),
            style: styleText(interval.volumeChange)),
        SizedBox(width: 15),
        Text(formatPercentage(interval.volumeChangePct),
            style: styleText(interval.volumeChangePct))
      ],
    ),
    SizedBox(
      height: 10,
    ),
    Text("Market cap: " + currency + formatLongNumber(item.marketCap),
        style: TextStyle(fontSize: 20)),
    Row(
      children: [
        Text(
          "Change: ",
          style: TextStyle(fontSize: 18),
        ),
        Text(currency + formatLongNumber(interval.marketCapChange),
            style: styleText(interval.marketCapChange)),
        SizedBox(width: 15),
        Text(
          formatPercentage(interval.marketCapChangePct),
          style: styleText(interval.marketCapChangePct),
        )
      ],
    ),
    SizedBox(
      height: 5,
    ),
    Text(
      "Dominance: " +
          NumberFormat("#0.00%").format(double.parse(item.marketCapDominance)),
      style: TextStyle(fontSize: 16),
    ),
    SizedBox(
      height: 10,
    ),
    Divider()
  ]);
}

String formatPercentage(String number) {
  var percentagePlus = NumberFormat("+#0.00%");
  var percentageMinus = NumberFormat("#0.00%");
  var percent = double.parse(number);
  if (percent >= 0) {
    return percentagePlus.format(percent);
  } else {
    return percentageMinus.format(percent);
  }
}

String formatNumber(String number) {
  var numberPlus = NumberFormat("+#0.000");
  var numberMinus = NumberFormat("#0.000");
  var formatNum = double.parse(number);
  if (formatNum >= 0) {
    return numberPlus.format(formatNum);
  } else {
    return numberMinus.format(formatNum);
  }
}

TextStyle styleText(String number) {
  var styleNum = double.parse(number);
  if (styleNum >= 0) {
    return TextStyle(color: Colors.green, fontSize: 18);
  } else {
    return TextStyle(color: Colors.red, fontSize: 18);
  }
}

String formatLongNumber(String number) {
  var formatLong = NumberFormat.compactLong();
  var formatNum = double.parse(number);
  return formatLong.format(formatNum);
}
