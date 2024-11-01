import 'package:daily_spending/core/extension/num_extensions.dart';
import 'package:daily_spending/features/transactions/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionListItems extends StatefulWidget {
  final Transaction trx;
  final Function dltTrxItem;
  // Created a constructor with required parameters to accomodate the null safe change.
  const TransactionListItems({super.key, required this.trx, required this.dltTrxItem});

  @override
  _TransactionListItemsState createState() => _TransactionListItemsState();
}

class _TransactionListItemsState extends State<TransactionListItems> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Theme.of(context).primaryColor,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Text(
              widget.trx.amount.toPrice,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                //no need for interpolation
                widget.trx.title,
                //FlatButton is now deprecated; ElevatedButton is used as a modern replacement.
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                DateFormat.yMMMd().format(widget.trx.date),
                style: TextStyle(color: Colors.grey, fontSize: 12),
              )
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    //Theme.of(context).errorColor is now deprecated; Theme.of(context).colorScheme.error is used as a modern replacement.
                    color: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () => showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: const Text('Are you sure'),
                      content: const Text('Do you really want to delete this transaction?'),
                      actions: [
                        //FlatButton is now deprecated; ElevatedButton is used as a modern replacement.
                        ElevatedButton(
                          onPressed: () {
                            widget.dltTrxItem(widget.trx.id);
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Yes',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        //FlatButton is now deprecated; ElevatedButton is used as a modern replacement.
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'No',
                            style: TextStyle(fontSize: 20),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
