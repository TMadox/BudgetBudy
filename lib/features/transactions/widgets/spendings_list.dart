import 'package:daily_spending/core/extension/datetime_extension.dart';
import 'package:daily_spending/core/extension/num_extensions.dart';
import 'package:daily_spending/features/transactions/controllers/transaction_controller.dart';
import 'package:daily_spending/features/transactions/data/transaction_enums.dart';
import 'package:daily_spending/features/transactions/models/pie_data.dart';
import 'package:daily_spending/features/transactions/models/transaction.dart';
import 'package:daily_spending/features/transactions/widgets/charts_section.dart';
import 'package:daily_spending/widgets/no_transaction.dart';
import 'package:daily_spending/widgets/transaction_list_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

class SpendingsList extends StatefulWidget {
  @override
  _SpendingsListState createState() => _SpendingsListState();
}

class _SpendingsListState extends State<SpendingsList> {
  bool _showChart = false;
  // added late keyword to suit null safety
  late final TransactionsController transactionsController;
  late final Function deleteFn;

  @override
  void initState() {
    super.initState();
    transactionsController = Provider.of<TransactionsController>(context, listen: false);
    deleteFn = Provider.of<TransactionsController>(context, listen: false).deleteTransaction;
  }

  @override
  Widget build(BuildContext context) {
    final List<Transaction> transactions = Provider.of<TransactionsController>(context).transactions;
    //Renamed variables for a better understanding
    final List<PieData> pieData = PieData.pieChartData(transactions);
    return Column(
      children: <Widget>[
        Card(
          color: Theme.of(context).primaryColorLight,
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Total: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "₹${transactionsController.getTotal(transactions)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Show Chart',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch.adaptive(
                        // removed the theming from here and added it to the app theming
                        value: _showChart,
                        onChanged: (val) => setState(() => _showChart = val),
                      ),
                    ),
                  ],
                ),
                if (transactionsController.transactionDate == TransactionDate.monthly ||
                    transactionsController.transactionDate == TransactionDate.yearly)
                  Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: FormBuilderField<DateTime>(
                      name: "date",
                      initialValue: DateTime.now(),
                      builder: (state) => Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: GestureDetector(
                          onTap: () => showMonthPicker(
                            context: context,
                            initialDate: DateTime.now(),
                          ).then(
                            (date) {
                              if (date != null) {
                                state.didChange(date);
                                transactionsController.fetchTransactions(
                                  date: transactionsController.transactionDate,
                                  month: date.month,
                                  year: date.year,
                                );
                              }
                            },
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.calendar_month_rounded),
                              4.space,
                              Text("Date: ${state.value!.ymd}"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        //Added expanded to center the no transaction widget
        if (transactions.isEmpty)
          Expanded(child: NoTransactions())
        else if (_showChart)
          Expanded(
            child: ChartsSection(
              transactions: transactions,
              pieData: pieData,
              date: transactionsController.transactionDate,
              transactionsController: transactionsController,
            ),
          )
        else
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(8),
              separatorBuilder: (ctx, index) => SizedBox(height: 4),
              itemBuilder: (ctx, index) => TransactionListItems(
                trx: transactions[index],
                dltTrxItem: deleteFn,
              ),
              itemCount: transactions.length,
            ),
          )
      ],
    );
  }
}
