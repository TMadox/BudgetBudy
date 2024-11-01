import 'package:daily_spending/core/constants/app_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CategoryRow extends StatelessWidget {
  const CategoryRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Category'),
        Spacer(),
        Expanded(
          child: FormBuilderDropdown<String>(
            name: "category",
            icon: const Icon(Icons.expand_more),
            elevation: 16,
            style: TextStyle(color: Theme.of(context).primaryColorDark),
            items: categories
                .map<DropdownMenuItem<String>>(
                  (String value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
