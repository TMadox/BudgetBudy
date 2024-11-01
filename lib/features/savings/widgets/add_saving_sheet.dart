import 'package:daily_spending/features/savings/controllers/savings_controller.dart';
import 'package:daily_spending/features/savings/models/saving.dart';
import 'package:daily_spending/features/savings/models/targets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddSavingSheet extends StatefulWidget {
  final Target target;
  const AddSavingSheet({super.key, required this.target});

  @override
  State<AddSavingSheet> createState() => _AddSavingSheetState();
}

class _AddSavingSheetState extends State<AddSavingSheet> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late final SavingsController savings;
  @override
  void initState() {
    savings = Provider.of<SavingsController>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
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
                    savings.addSavings(
                      Saving.fromMap({'targetId': widget.target.id, ..._formKey.currentState!.value}),
                      widget.target,
                    );
                    _formKey.currentState!.reset();
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Theme.of(context).primaryColorLight,
                        content: Text(
                          "Data added Succesfully!",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        //Theme.of(context).errorColor is now deprecated; Theme.of(context).colorScheme.error is used as a modern replacement.
                        backgroundColor: Theme.of(context).colorScheme.error,
                        content: Text(
                          "Fields can't be empty!",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
