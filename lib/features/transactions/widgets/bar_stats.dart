// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:daily_spending/core/extension/num_extensions.dart';
import 'package:daily_spending/features/transactions/controllers/transaction_controller.dart';
import 'package:daily_spending/features/transactions/data/transaction_enums.dart';
import 'package:daily_spending/features/transactions/models/transaction.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarStats extends StatefulWidget {
  final List<Transaction> transactions;
  final TransactionsController transactionsController;
  const BarStats({
    Key? key,
    required this.transactionsController,
    required this.transactions,
  }) : super(key: key);

  @override
  _BarStatsState createState() => _BarStatsState();
}

class _BarStatsState extends State<BarStats> {
  late int touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColorDark.withOpacity(0.5),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Analysis',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            4.space,
            Text(
              widget.transactionsController.transactionDate == TransactionDate.yearly ? 'Last 12 Months' : 'Last Seven Days',
              style: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            24.space,
            Expanded(
              child: BarChart(
                BarData(
                  widget.transactionsController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
          )
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
        // Build X axis.
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, meta) => Text(groupedTransactionValues[0]['date'].toString()),
          ),
        ),
        // Build Y axis.
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            getTitlesWidget: (value, meta) => Text(value.toString()),
          ),
        ),
      );
}
