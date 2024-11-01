import 'package:flutter/material.dart';

class AppTheme {
  final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.amber,
    tabBarTheme: TabBarTheme(unselectedLabelColor: Colors.black),
    textTheme: ThemeData.dark()
        .textTheme
        .copyWith(
          headlineLarge: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          labelLarge: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        )
        //Applied font family generally to all text styles instead of specificly setting it for each one.
        .apply(fontFamily: "OpenSans"),
    appBarTheme: AppBarTheme(
      elevation: 2,
      titleTextStyle: TextStyle(
        fontSize: 24,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.amber),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.amber),
      ),
    ),
  );

  final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.amber,
    scaffoldBackgroundColor: Colors.white,
    //Set colorscheme seed to apply the main color to the entire app.
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
    textTheme: ThemeData.light()
        .textTheme
        .copyWith(
          headlineLarge: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          labelLarge: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        )
        //Applied font family generally to all text styles instead of specificly setting it for each one.
        .apply(fontFamily: "OpenSans"),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStatePropertyAll(Colors.white),
      trackOutlineColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.amber;
          }
          return Colors.grey.withOpacity(0.5);
        },
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.amber;
          }
          return Colors.grey.withOpacity(0.5);
        },
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
      labelColor: Colors.black,
      unselectedLabelColor: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.amber),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.amber),
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: Colors.amber),
    listTileTheme: ListTileThemeData(
      leadingAndTrailingTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontSize: 24,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
