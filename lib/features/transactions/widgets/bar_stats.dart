// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:daily_spending/core/extension/num_extensions.dart';
import 'package:daily_spending/features/transactions/controllers/transaction_controller.dart';
import 'package:daily_spending/features/transactions/data/bar_data.dart';
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
