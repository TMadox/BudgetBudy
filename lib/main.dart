import 'package:daily_spending/core/extension/context_extension.dart';
import 'package:daily_spending/core/style/app_theme.dart';
import 'package:daily_spending/features/intro/pages/splash_page.dart';
import 'package:daily_spending/features/savings/controllers/savings_controller.dart';
import 'package:daily_spending/features/savings/models/targets.dart';
import 'package:daily_spending/features/savings/pages/savings_page.dart';
import 'package:daily_spending/features/savings/pages/targets_page.dart';
import 'package:daily_spending/features/transactions/controllers/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:provider/provider.dart';

import 'features/transactions/pages/home_screen.dart';
import 'features/transactions/pages/new_transaction_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  // await DBHelper.instance.drop(savingsTableName);
  // await DBHelper.instance.drop(targetsTableName);
  // await DBHelper.instance.drop(transactionsTableName);
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 30.0
    ..radius = 10.0
    ..textPadding = EdgeInsets.zero
    ..progressColor = Colors.amber
    ..backgroundColor = Colors.white
    ..indicatorColor = Colors.amber
    ..textColor = Colors.amber
    ..maskColor = Colors.grey.withOpacity(0.3)
    ..maskType = EasyLoadingMaskType.custom
    ..userInteractions = false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => TransactionsController()),
          ChangeNotifierProvider(create: (context) => SavingsController()),
        ],
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            ...GlobalMaterialLocalizations.delegates,
            GlobalWidgetsLocalizations.delegate,
            FormBuilderLocalizations.delegate,
          ],
          title: 'Money Tracker',
          theme: AppTheme().lightTheme,
          darkTheme: AppTheme().darkTheme,
          themeMode: ThemeMode.light,
          builder: EasyLoading.init(),
          routes: {
            SplashPage.routeName: (_) => SplashPage(),
            HomeScreen.routeName: (_) => HomeScreen(),
            NewTransaction.routeName: (_) => NewTransaction(),
            TargetsPage.routeName: (_) => TargetsPage(),
            SavingsPage.routeName: (context) => SavingsPage(target: context.arguments as Target),
          },
        ),
      ),
    );
  }
}
