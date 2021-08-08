import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/chart/chart_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/formatters.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/show_snackbar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

BlocListener<ChartBloc, ChartState> buildChart(
    ChartBloc chartBloc,
    Items item,
    DateTime chartInterval,
    bool convert,
    List<FlSpot> data,
    int days,
    String currency) {
  return BlocListener<ChartBloc, ChartState>(
    bloc: chartBloc,
    listener: (context, state) {
      if (state is ChartErrorState) {
        ScaffoldMessenger.of(context)
            .showSnackBar(buildSnackBar(context, state.message));
      }
    },
    child: BlocBuilder<ChartBloc, ChartState>(
        bloc: chartBloc
          ..add(GetChartEvent(
              itemId: item.id,
              interval: chartInterval.toUtc().toIso8601String(),
              convert: convert)),
        builder: (context, state) {
          if (state is ChartInitial) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is ChartLoadedState) {
            if (state.chart.isNotEmpty) {
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
                      lineTouchData: LineTouchData(
                          getTouchLineStart: (data, index) {
                            return 0;
                          },
                          getTouchLineEnd: (data, index) {
                            return double.infinity;
                          },
                          touchTooltipData: LineTouchTooltipData(
                              tooltipBgColor: Color.fromRGBO(255, 204, 0, 1),
                              fitInsideHorizontally: true,
                              getTooltipItems:
                                  (List<LineBarSpot> touchedBarSpots) {
                                return touchedBarSpots.map((barSpot) {
                                  final flSpot = barSpot;
                                  return LineTooltipItem(
                                      (days == 1)
                                          ? state.chart[0]
                                                  .timestamps[flSpot.x.toInt()]
                                                  .toString()
                                                  .substring(11, 16) +
                                              "\n"
                                          : formatDate(
                                                  state.chart[0].timestamps[
                                                      flSpot.x.toInt()],
                                                  context) +
                                              "\n",
                                      TextStyle(
                                          fontSize: 15,
                                          color: Color.fromRGBO(0, 0, 132, 1)),
                                      children: [
                                        TextSpan(
                                            text: ((flSpot.y <= 0.005)
                                                    ? (flSpot.y <= 0.00005)
                                                        ? flSpot.y
                                                            .toStringAsFixed(7)
                                                        : flSpot.y
                                                            .toStringAsFixed(5)
                                                    : flSpot.y
                                                        .toStringAsFixed(3)) +
                                                currency)
                                      ]);
                                }).toList();
                              })),
                      titlesData: FlTitlesData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                            spots: data,
                            barWidth: 3,
                            dotData: FlDotData(show: false)),
                      ],
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: false),
                    ),
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 20, right: 20, bottom: 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Center(
                    child: Text(
                      'No data found!',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              );
            }
          } else if (state is ChartErrorState) {
            return Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 20, right: 20, bottom: 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Center(
                    child: IconButton(
                        icon: Icon(
                          Icons.refresh,
                          size: 35,
                        ),
                        onPressed: () {
                          chartBloc.add(GetChartEvent(
                              itemId: item.id,
                              interval: chartInterval.toUtc().toIso8601String(),
                              convert: convert));
                        }),
                  ),
                ));
          }
          return Container();
        }),
  );
}
