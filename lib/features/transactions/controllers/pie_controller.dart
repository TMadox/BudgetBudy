import 'package:daily_spending/features/transactions/models/pie_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieController {
  // Added the method getSections here instead of being on it's own.
  List<PieChartSectionData> getSections(
    int touchedIndex,
    List<PieData> pieData,
    double screenWidth,
  ) =>
      pieData
          .asMap()
          .map<int, PieChartSectionData>(
            (index, data) {
              final bool isTouched = index == touchedIndex;
              final double fontSize = isTouched ? 25 : 16;
              final double radius = isTouched ? screenWidth * 0.32 : screenWidth * 0.30;
              final String title = isTouched ? '₹${data.price}' : '${data.percent}%';
              final PieChartSectionData value = PieChartSectionData(
                color: data.color,
                value: data.percent,
                title: title,
                radius: radius,
                titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffffffff),
                ),
              );
              return MapEntry(index, value);
            },
          )
          .values
          .toList();
}
