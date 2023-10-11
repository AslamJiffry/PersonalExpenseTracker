import 'package:flutter/material.dart';
import 'package:pet/constants/icons.dart';
import 'package:pet/models/expense.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  const ExpenseCard(this.expense, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icons[expense.category]),
      ),
      title: Text(expense.title),
      subtitle: Text(expense.date.toString()),
      trailing: Text(expense.amount.toStringAsFixed(2)),
    );
  }
}
