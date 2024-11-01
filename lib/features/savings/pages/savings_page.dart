import 'package:daily_spending/core/extension/context_extension.dart';
import 'package:daily_spending/core/extension/datetime_extension.dart';
import 'package:daily_spending/core/extension/num_extensions.dart';
import 'package:daily_spending/features/savings/controllers/savings_controller.dart';
import 'package:daily_spending/features/savings/models/targets.dart';
import 'package:daily_spending/features/savings/widgets/add_saving_sheet.dart';
import 'package:daily_spending/widgets/custom_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavingsPage extends StatelessWidget {
  final Target target;
  static const String routeName = "/savings";
  const SavingsPage({super.key, required this.target});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(target.title),
      ),
      body: CustomFutureBuilder(
        future: Provider.of<SavingsController>(context, listen: false).loadSavingsFromTarget(target.id),
        whenDone: (value) => Consumer<SavingsController>(
          builder: (context, controller, widget) {
            final Target liveTarget = controller.targets.firstWhere((element) => element.id == target.id);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: (controller.savings.isEmpty)
                      ? Center(
                          child: Text(
                            "You have not added savings yet",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        )
                      : ListView.separated(
                          itemCount: controller.savings.length,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (context, index) => Card(
                            child: ListTile(
                              title: Text(controller.savings[index].title),
                              subtitle: Text("${controller.savings[index].date.ymd}"),
                              trailing: Text("${controller.savings[index].amount.toPrice}"),
                            ),
                          ),
                          separatorBuilder: (context, index) => SizedBox(height: 4),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (liveTarget.percentage == 100)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            'Congratulations! You have reached your target!',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        )
                      else if (liveTarget.percentage >= 90)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            'We are almost there!',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      Row(
                        children: [
                          Expanded(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: liveTarget.percentage / 100,
                                    minHeight: 38,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "${liveTarget.percentage}%",
                                    style: context.textTheme.labelLarge,
                                  ),
                                )
                              ],
                            ),
                          ),
                          if (liveTarget.percentage < 100) ...[
                            16.space,
                            ElevatedButton(
                              onPressed: () => showModalBottomSheet(
                                context: context,
                                builder: (_) => AddSavingSheet(target: target),
                              ),
                              child: Icon(Icons.add),
                            ),
                          ]
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        whenNotDone: CircularProgressIndicator(),
      ),
    );
  }
}
