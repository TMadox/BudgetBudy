import 'package:daily_spending/core/extension/num_extensions.dart';
import 'package:daily_spending/features/transactions/controllers/transaction_controller.dart';
import 'package:daily_spending/features/transactions/data/transaction_enums.dart';
import 'package:daily_spending/features/transactions/models/pie_data.dart';
import 'package:daily_spending/features/transactions/models/transaction.dart';
import 'package:daily_spending/features/transactions/widgets/bar_stats.dart';
import 'package:daily_spending/features/transactions/widgets/pie_chart.dart';
import 'package:flutter/material.dart';

class ChartsSection extends StatelessWidget {
  final List<PieData> pieData;
  final List<Transaction> transactions;
  final TransactionDate date;
  final TransactionsController transactionsController;
  const ChartsSection({
    super.key,
    required this.transactions,
    required this.transactionsController,
    required this.pieData,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (date == TransactionDate.weekly || date == TransactionDate.yearly)
            BarStats(
              transactions: transactions,
              transactionsController: transactionsController,
            ),
          24.space,
          MyPieChart(pieData: pieData),
        ],
      ),
    );
  }
}
