import 'package:animate_do/animate_do.dart';
import 'package:daily_spending/core/utils/db_helper.dart';
import 'package:daily_spending/features/transactions/pages/home_screen.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  static const String routeName = '/';
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Future<void> didChangeDependencies() async {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await DBHelper.instance.initDatabase();
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      },
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeIn(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Image.asset(
              'assets/images/app_icon.png',
            ),
          ),
        ),
      ),
    );
  }
}
