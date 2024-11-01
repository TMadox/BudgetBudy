import 'package:daily_spending/features/transactions/controllers/transaction_controller.dart';
import 'package:daily_spending/features/transactions/data/transaction_enums.dart';
import 'package:daily_spending/features/transactions/widgets/spendings_list.dart';
import 'package:daily_spending/widgets/custom_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import 'new_transaction_page.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  // add late initialization to suit null safety
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

//Removed "new" initializer; it's no longer needed.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          "Home",
          //Removed the styling for this text as it's not really needed
          // style: Theme.of(context).textTheme.displayLarge,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.of(context).pushNamed(NewTransaction.routeName),
          ),
        ],
        bottom: TabBar(
          //Removed the styling from here to add it App Theming for a better look control
          indicatorColor: Theme.of(context).primaryColorDark,
          //check for the clicked index and then decide what time period should be shown
          onTap: (index) {
            switch (index) {
              case 0:
                Provider.of<TransactionsController>(context, listen: false).fetchTransactions();
                break;
              case 1:
                Provider.of<TransactionsController>(context, listen: false).fetchTransactions(date: TransactionDate.weekly);
                break;
              case 2:
                Provider.of<TransactionsController>(context, listen: false).fetchTransactions(date: TransactionDate.monthly);
                break;
              case 3:
                Provider.of<TransactionsController>(context, listen: false).fetchTransactions(date: TransactionDate.yearly);
                break;
            }
          },
          tabs: <Widget>[
            Tab(text: "Daily"),
            Tab(text: "Weekly"),
            Tab(text: 'Monthly'),
            Tab(text: 'Yearly'),
          ],
          controller: tabController,
        ),
      ),
      body: CustomFutureBuilder(
        future: Provider.of<TransactionsController>(context, listen: false).fetchTransactions(),
        whenDone: (response) => SpendingsList(),
        whenNotDone: Center(child: CircularProgressIndicator()),
      ),
      drawer: Consumer<TransactionsController>(
        builder: (context, trx, child) => AppDrawer(total: trx.getTotal(trx.transactions)),
      ),
    );
  }
}
