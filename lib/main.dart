import 'package:cryptoapp/features/cryptoapp/domain/usecases/get_search_result.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/pages/auth_page.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/pages/event_details_page.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/pages/main_page.dart';
import 'package:cryptoapp/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/cryptoapp/domain/usecases/get_items.dart';
import 'features/cryptoapp/presentation/bloc/items/items_bloc.dart';
import 'injection_container.dart' as di;
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => ItemsBloc(
            getItems: sl<GetItems>(), getSearchResult: sl<GetSearchResult>())
          ..add(GetItemsEvent()),
        child: MaterialApp(
            title: 'CryptoApp',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: AuthPage(),
            routes: {
              '/auth': (context) => AuthPage(),
              '/main': (context) => MainPage(),
              '/eventdetails': (context) => EventDetailsPage(),
            }));
  }
}
