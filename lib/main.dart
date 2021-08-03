import 'package:cryptoapp/features/cryptoapp/domain/usecases/get_search_result.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/pages/auth_page.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/pages/crypto_details_page.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/pages/event_details_page.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/pages/main_page.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/pages/onboarding_page.dart';
import 'package:cryptoapp/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/cryptoapp/domain/usecases/get_items.dart';
import 'features/cryptoapp/domain/usecases/refresh_items.dart';
import 'features/cryptoapp/presentation/bloc/items/items_bloc.dart';
import 'injection_container.dart' as di;
import 'package:firebase_core/firebase_core.dart';

int initScreen;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = prefs.getInt('isViewed');
  runApp(EasyLocalization(
    supportedLocales: [Locale('en'), Locale('hu')],
    fallbackLocale: Locale('en'),
    path: 'assets/translations',
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => ItemsBloc(
            getItems: sl<GetItems>(),
            getSearchResult: sl<GetSearchResult>(),
            refreshItems: sl<RefreshItems>())
          ..add(GetItemsEvent()),
        child: MaterialApp(
            title: 'CryptoApp',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            home: initScreen == 0 ? OnboardingPage() : AuthPage(),
            routes: {
              '/auth': (context) => AuthPage(),
              '/main': (context) => MainPage(),
              '/eventdetails': (context) => EventDetailsPage(),
              '/cryptodetails': (context) => CryptoDetailsPage(),
            }));
  }
}
