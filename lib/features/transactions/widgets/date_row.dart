import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class DateRow extends StatelessWidget {
  final String title;
  const DateRow({super.key, this.title = "Choose Date"});

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<DateTime>(
      name: "date",
      initialValue: DateTime.now(),
      validator: FormBuilderValidators.required(),
      builder: (state) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            ).then(
              (value) {
                if (value != null) {
                  state.didChange(value);
                }
              },
            ),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(title),
            ),
          ),
          Text(
            DateFormat.yMMMd().format(state.value ?? DateTime.now()),
            style: TextStyle(color: Theme.of(context).primaryColorDark),
          ),
        ],
      ),
    );
  }
}
