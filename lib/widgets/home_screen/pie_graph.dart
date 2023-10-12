import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:pet/models/database_provider.dart';
import 'package:provider/provider.dart';

class PieGraph extends StatefulWidget {
  const PieGraph({super.key});

  @override
  State<PieGraph> createState() => _PieGraphState();
}

class _PieGraphState extends State<PieGraph> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(builder: (_, db, __) {
      var list = db.categories;
      var total = db.calculateTotalExpenses();
      return Row(
        children: [
          Expanded(
            flex: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  alignment: Alignment.center,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Total Expense: ${NumberFormat.currency(
                      locale: 'en_SL',
                      symbol: 'Rs',
                    ).format(total)}',
                    textScaleFactor: 1.5,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                ...list.map(
                  (e) => Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          color: Colors.primaries[list.indexOf(e)],
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          e.title,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                            '${((e.totalAmount / total) * 100).toStringAsFixed(2)}%'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 40,
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 20,
                sections: list
                    .map((e) => PieChartSectionData(
                          showTitle: false,
                          value: e.totalAmount,
                          color: Colors.primaries[list.indexOf(e)],
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      );
    });
  }
}
