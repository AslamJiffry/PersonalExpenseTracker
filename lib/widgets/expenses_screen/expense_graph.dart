import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet/models/database_provider.dart';
import 'package:provider/provider.dart';

class ExpenseGraph extends StatefulWidget {
  final String category;
  const ExpenseGraph(this.category, {super.key});

  @override
  State<ExpenseGraph> createState() => _ExpenseGraphState();
}

class _ExpenseGraphState extends State<ExpenseGraph> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(builder: (_, db, __) {
      var maxY =
          db.calculateEntriesAndTotalAmount(widget.category)['totalAmount'];
      var list = db.calculateWeekExpenses().reversed.toList();
      return BarChart(
        BarChartData(
          minY: 0,
          maxY: maxY,
          barGroups: [
            ...list.map(
              (e) => BarChartGroupData(
                x: list.indexOf(e),
                barRods: [
                  BarChartRodData(
                    toY: e['amount'],
                    width: 20,
                    borderRadius: BorderRadius.zero,
                  ),
                ],
              ),
            ),
          ],
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              drawBelowEverything: true,
            ),
            leftTitles: const AxisTitles(
              drawBelowEverything: true,
            ),
            rightTitles: const AxisTitles(
              drawBelowEverything: true,
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) =>
                    Text(DateFormat.E().format(list[value.toInt()]['day'])),
              ),
            ),
          ),
        ),
      );
    });
  }
}
