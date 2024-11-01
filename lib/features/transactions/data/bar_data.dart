// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:daily_spending/features/transactions/controllers/transaction_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarData extends BarChartData {
  final TransactionsController transactionsController;
  List<Map<String, dynamic>> groupedTransactionValues;
  BarData(
    this.transactionsController, {
    List<Map<String, dynamic>>? groupedTransactionValues,
  }) : groupedTransactionValues = groupedTransactionValues ?? transactionsController.groupedTransactionValues();

  @override
  List<BarChartGroupData> get barGroups => List.generate(
        groupedTransactionValues.length,
        (index) => BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: groupedTransactionValues[index]['amount'],
              width: 22,
              color: Colors.amber,
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: 20,
              ),
            ),
          ],
        ),
      );

  @override
  FlTouchData<BaseTouchResponse> get touchData => BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String title = groupedTransactionValues[group.x]['day'];
            return BarTooltipItem(
              title + '\n' + (rod.toY).toString(),
              TextStyle(color: Colors.yellow),
            );
          },
        ),
        touchCallback: (barTouchResponse, touch) {},
      );
  @override
  FlTitlesData get titlesData => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, meta) => Text((value.toInt() + 1).toString()),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            getTitlesWidget: (value, meta) => Text(value.toString()),
          ),
        ),
      );
}
