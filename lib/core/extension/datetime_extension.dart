import 'package:intl/intl.dart';

extension DatetimeExtension on DateTime {
  String get ymd => DateFormat('yyyy-MM-dd').format(this);
  bool isSameDay(DateTime date2) => year == date2.year && month == date2.month && day == date2.day;
  bool isToday(DateTime date) {
    final DateTime now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}
