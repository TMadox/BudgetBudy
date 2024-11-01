// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:daily_spending/features/transactions/controllers/pie_controller.dart';
import 'package:daily_spending/features/transactions/models/pie_data.dart';
import 'package:daily_spending/widgets/pie_chart_widgets/indicators_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyPieChart extends StatefulWidget {
  final List<PieData> pieData;
  // fixed constructors to suit null safety
  const MyPieChart({Key? key, required this.pieData}) : super(key: key);

  @override
  _MyPieChartState createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      //Removed width, and added padding for a better approach and readability
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        children: <Widget>[
          Expanded(
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (event, pieTouchResponse) => setState(
                    () {
                      //Refactored this method so it can work properly
                      final Set resetEvents = {FlLongPressEnd, FlTapCancelEvent, FlPanCancelEvent, FlTapUpEvent};
                      if (resetEvents.contains(event.runtimeType)) {
                        touchedIndex = -1;
                      } else {
                        touchedIndex = pieTouchResponse?.touchedSection?.touchedSectionIndex ?? -1;
                      }
                    },
                  ),
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                sections: PieController().getSections(
                  touchedIndex,
                  widget.pieData,
                  MediaQuery.of(context).size.width,
                ),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: IndicatorsWidget(
                  pieData: widget.pieData,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
