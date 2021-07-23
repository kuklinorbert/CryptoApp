import 'package:cryptoapp/features/cryptoapp/presentation/pages/auth_page.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';
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
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthPage(),
        routes: {
          '/auth': (context) => AuthPage(),
          '/main': (context) => MainPage(),
        });
  }
}
