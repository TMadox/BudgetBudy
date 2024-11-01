import 'package:daily_spending/core/constants/app_lists.dart';
import 'package:daily_spending/features/transactions/controllers/transaction_controller.dart';
import 'package:daily_spending/features/transactions/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewTransaction extends StatefulWidget {
  static const routeName = '/new-transaction';
  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  // added late intializer to suit null safety
  late final TransactionsController transactions;
  @override
  void initState() {
    transactions = Provider.of<TransactionsController>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Add Transaction"),
        backgroundColor: Colors.white10,
      ),
      body: FormBuilder(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              right: 20,
              left: 20,
              top: 30,
              bottom: (MediaQuery.of(context).viewInsets.bottom) + 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FormBuilderTextField(
                  name: 'title',
                  decoration: const InputDecoration(labelText: "Title"),
                  validator: FormBuilderValidators.required(),
                ),
                SizedBox(height: 10),
                FormBuilderTextField(
                  name: 'amount',
                  decoration: const InputDecoration(labelText: "Amount"),
                  keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                  valueTransformer: (value) => num.tryParse(value!),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                FormBuilderDropdown<String>(
                  name: "category",
                  icon: const Icon(Icons.expand_more),
                  elevation: 16,
                  style: TextStyle(color: Theme.of(context).primaryColorDark),
                  decoration: InputDecoration(
                    labelText: "Category",
                  ),
                  items: categories
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: 20),
                FormBuilderDateTimePicker(
                  name: "date",
                  validator: FormBuilderValidators.required(),
                  decoration: InputDecoration(labelText: "Date"),
                  inputType: InputType.date,
                  format: DateFormat("yyyy-MM-dd"),
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  valueTransformer: (value) => value?.millisecondsSinceEpoch,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  child: const Text("Add"),
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      transactions.addTransactions(Transaction.fromMap(_formKey.currentState!.value));
                      _formKey.currentState!.reset();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
