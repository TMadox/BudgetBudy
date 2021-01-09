import 'package:daily_spending/screens/home_screen.dart';
import 'package:daily_spending/screens/splash_screen.dart';
import 'package:daily_spending/screens/stats_screen.dart';
import 'package:daily_spending/screens/new_transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart' as preview;

import './models/transaction.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(preview.DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // Create the initialization Future outside of `build`:

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => Transactions(),
        builder: (context, child) {
          return MaterialApp(
            locale: preview.DevicePreview.of(context).locale,
            builder: preview.DevicePreview.appBuilder,
            debugShowCheckedModeBanner: false,
            title: 'Money Tracker',
            theme: ThemeData(
              primaryColor: Colors.amber,
              accentColor: Colors.amberAccent,
              fontFamily: 'Quicksand',
              textTheme: ThemeData.light().textTheme.copyWith(
                    headline1: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    button: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
              appBarTheme: AppBarTheme(
                textTheme: ThemeData.light().textTheme.copyWith(
                      headline1: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
              ),
            ),
            home: FutureBuilder(
              future: Provider.of<Transactions>(context, listen: false)
                  .fetchTransactions(),
              builder: (ctx, snapshot) =>
                  (snapshot.connectionState == ConnectionState.waiting)
                      ? SplashScreen()
                      : HomeScreen(),
            ),
            routes: {
              // HomeScreen.routeName: (_) => HomeScreen(),
              StatsScreen.routeName: (_) => StatsScreen(),
              NewTransaction.routeName: (_) => NewTransaction(),
            },
          );
        });
  }
}
