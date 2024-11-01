import 'dart:developer';

import 'package:daily_spending/core/extension/context_extension.dart';
import 'package:daily_spending/core/extension/num_extensions.dart';
import 'package:daily_spending/features/savings/controllers/savings_controller.dart';
import 'package:daily_spending/features/savings/models/targets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddTargetSheet extends StatefulWidget {
  const AddTargetSheet({super.key});

  @override
  State<AddTargetSheet> createState() => _AddTargetSheetState();
}

class _AddTargetSheetState extends State<AddTargetSheet> {
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
              Text(
                "Create a New Target",
                style: context.textTheme.headlineSmall,
              ),
              FormBuilderTextField(
                name: 'title',
                decoration: const InputDecoration(labelText: "Title"),
                validator: FormBuilderValidators.required(),
              ),
              SizedBox(height: 10),
              FormBuilderTextField(
                name: 'amount',
                decoration: const InputDecoration(labelText: "Target Amount"),
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
              Row(
                children: [
                  Expanded(
                    child: FormBuilderDateTimePicker(
                      name: "startDate",
                      validator: FormBuilderValidators.required(),
                      decoration: InputDecoration(labelText: "Start Date"),
                      inputType: InputType.date,
                      format: DateFormat("yyyy-MM-dd"),
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      valueTransformer: (value) => value?.millisecondsSinceEpoch,
                    ),
                  ),
                  16.space,
                  Expanded(
                    child: FormBuilderDateTimePicker(
                      name: "endDate",
                      validator: FormBuilderValidators.required(),
                      decoration: InputDecoration(labelText: "End Date"),
                      inputType: InputType.date,
                      format: DateFormat("yyyy-MM-dd"),
                      initialDate: DateTime.now().add(Duration(days: 1)),
                      firstDate: DateTime.now().add(Duration(days: 1)),
                      valueTransformer: (value) => value?.millisecondsSinceEpoch,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text("Add"),
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      log(_formKey.currentState!.value.toString());
                      savings.addTarget(Target.fromMap(_formKey.currentState!.value));
                      _formKey.currentState!.reset();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
