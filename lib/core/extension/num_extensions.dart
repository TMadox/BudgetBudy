import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:intl/intl.dart';

extension NumExtensions on num {
  // this is to decide of the screen is wider or higher than 450x850
  Widget get space => Gap(toDouble());
  String get toPrice => "₹${NumberFormat.decimalPattern().format(this)}";
}
