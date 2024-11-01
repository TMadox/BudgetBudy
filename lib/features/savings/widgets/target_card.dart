import 'package:daily_spending/core/extension/datetime_extension.dart';
import 'package:daily_spending/core/extension/num_extensions.dart';
import 'package:daily_spending/features/savings/controllers/savings_controller.dart';
import 'package:daily_spending/features/savings/models/targets.dart';
import 'package:daily_spending/features/savings/pages/savings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TargetCard extends StatelessWidget {
  final Target target;
  const TargetCard({super.key, required this.target});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => Navigator.of(context).pushNamed(SavingsPage.routeName, arguments: target),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(target.title),
            Text(target.amount.toPrice),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            4.space,
            LinearProgressIndicator(value: target.percentage.toDouble() / 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(target.startDate.ymd + " --> " + target.endDate.ymd),
                Text(
                  "${target.percentage}%",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ],
        ),
        trailing: GestureDetector(
          onTap: () => Provider.of<SavingsController>(context, listen: false).deleteTarget(target.id),
          child: Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
