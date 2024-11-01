import 'package:collection/collection.dart';
import 'package:daily_spending/features/transactions/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class PieData {
  final String name;
  final double percent;
  final Color color;
  final num price;
  //Removed the input parameter as it is not needed,
  //we can directly call this function using the an instance of the class
  const PieData({
    required this.name,
    required this.percent,
    required this.color,
    required this.price,
  });

  static List<PieData> pieChartData(List<Transaction> transactions) {
    final num total = transactions.fold(0, (previousValue, element) => previousValue + element.amount);
    final List<Map<String, dynamic>> finalData = sortedPieData(transactions);
    final RandomColor _randomColor = RandomColor();
    return finalData
        .mapIndexed(
          (index, element) => PieData(
            name: element['title'],
            percent: (((element['amount']) * 100) / total).round().ceilToDouble(),
            color: _randomColor.randomColor(colorBrightness: ColorBrightness.primary),
            price: element['amount'],
          ),
        )
        .toList();
  }

  // Sortig Data According To Category vise
  static List<Map<String, dynamic>> sortedPieData(List<Transaction> transactions) {
    final Map<String, num> categoryTotals = <String, num>{};
    for (var transaction in transactions) {
      categoryTotals.update(
        transaction.category,
        (amount) => amount + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }
    return categoryTotals.entries
        .map(
          (entry) => {
            'title': entry.key,
            'amount': entry.value,
          },
        )
        .toList();
  }
}
