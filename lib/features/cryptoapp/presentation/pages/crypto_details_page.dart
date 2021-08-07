import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:cryptoapp/features/cryptoapp/domain/entities/items_interval.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/chart/chart_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/converter/converter_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/favourites/favourites_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/interval/interval_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/build_interval.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/formatters.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/show_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

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
            BlocListener<FavouritesBloc, FavouritesState>(
              bloc: favouritesBloc,
              listener: (context, state) {
                if (state is ErrorModifyingFavouritesState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(buildSnackBar(context, state.message));
                }
              },
              child: BlocBuilder<FavouritesBloc, FavouritesState>(
                  bloc: favouritesBloc
                    ..add(CheckFavouriteEvent(
                        uid: FirebaseAuth.instance.currentUser.uid,
                        itemId: item.id)),
                  buildWhen: (previous, current) {
                    if (current is LoadingFavouritesState ||
                        current is FavouritesFetchedState ||
                        current is ErrorModifyingFavouritesState ||
                        previous is FavouritesState &&
                            current is ErrorFavouritesState ||
                        current is SwitchingFavouriteState) {
                      return false;
                    } else {
                      return true;
                    }
                  },
                  builder: (context, state) {
                    print("favourite details: " + state.toString());
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
                  }),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: BlocListener<ConverterBloc, ConverterState>(
              bloc: converterBloc,
              listener: (context, state) {
                if (state is ConverterErrorState) {
                  converterBloc.add(SwitchToUsdEvent());
                  ScaffoldMessenger.of(context)
                      .showSnackBar(buildSnackBar(context, state.message));
                }
              },
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
          ),
        ));
  }
}

Column buildBody(Items item, BuildContext context, ConverterBloc converterBloc,
    bool convert, String currency) {
  String format;

  ChartBloc chartBloc = sl<ChartBloc>();
  IntervalBloc intervalBloc = sl<IntervalBloc>();
  DateTime today = new DateTime.now();
  TextStyle defaultStyle = TextStyle(fontSize: 16);
  ItemsInterval interval;

  if (item.logoUrl.isNotEmpty) {
    format = item.logoUrl.substring(item.logoUrl.length - 3);
  } else {
    format = "null";
  }

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
                Text(item.currency + " • " + item.status.tr(),
                    style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 2.0),
            child: SizedBox(
              width:
                  (MediaQuery.of(context).orientation == Orientation.portrait)
                      ? MediaQuery.of(context).size.height * 0.10
                      : MediaQuery.of(context).size.height * 0.20,
              height:
                  (MediaQuery.of(context).orientation == Orientation.portrait)
                      ? MediaQuery.of(context).size.height * 0.10
                      : MediaQuery.of(context).size.height * 0.20,
              child: (format == 'svg')
                  ? SvgPicture.network(
                      item.logoUrl,
                      fit: BoxFit.fill,
                    )
                  : (format == 'null')
                      ? Container()
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
            NumberFormat("###,##0.00").format(double.parse(item.high)) +
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
