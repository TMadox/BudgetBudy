import 'package:daily_spending/core/extension/datetime_extension.dart';
import 'package:daily_spending/core/extension/num_extensions.dart';
import 'package:daily_spending/features/savings/controllers/savings_controller.dart';
import 'package:daily_spending/features/savings/pages/savings_page.dart';
import 'package:daily_spending/features/savings/widgets/add_target_sheet.dart';
import 'package:daily_spending/widgets/custom_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TargetsPage extends StatelessWidget {
  static const String routeName = "/targets";
  const TargetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Saving Targets")),
      body: CustomFutureBuilder(
        future: Provider.of<SavingsController>(context).loadSavingTargets(),
        whenDone: (value) => Consumer<SavingsController>(
          builder: (context, controller, widget) => (controller.targets.isEmpty)
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "You have no targets",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => showModalBottomSheet(
                          context: context,
                          builder: (_) => AddTargetSheet(),
                        ),
                        child: Text("Create a New One"),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: controller.targets.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) => Card(
                          child: ListTile(
                            onTap: () => Navigator.of(context).pushNamed(SavingsPage.routeName, arguments: controller.targets[index]),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(controller.targets[index].title),
                                Text("₹" + controller.targets[index].amount.toString()),
                              ],
                            ),
                            trailing: Text("${controller.targets[index].percentage.toDouble()}%"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                4.space,
                                LinearProgressIndicator(value: controller.targets[index].percentage.toDouble() / 100),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(controller.targets[index].startDate.ymd),
                                    Text(controller.targets[index].endDate.ymd),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        separatorBuilder: (context, index) => SizedBox(height: 4),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: () => showModalBottomSheet(
                          context: context,
                          builder: (_) => AddTargetSheet(),
                        ),
                        child: Text("Add a New One"),
                      ),
                    ),
                  ],
                ),
        ),
        whenNotDone: CircularProgressIndicator(),
      ),
    );
  }
}
