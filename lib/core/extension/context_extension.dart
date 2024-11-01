import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  ThemeData get theme => Theme.of(this);
  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;
  double get fHeight => MediaQuery.of(this).size.height;
  double get fWidth => MediaQuery.of(this).size.width;
  dynamic get arguments => ModalRoute.of(this)!.settings.arguments;
}
