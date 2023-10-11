import 'package:flutter/material.dart';
import 'package:pet/models/expense_category.dart';
import 'package:pet/screens/expenses_screen.dart';

class CategoryCard extends StatelessWidget {
  final ExpenseCategory category;
  const CategoryCard(this.category, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(ExpensesScreen.name);
      },
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(category.icon),
      ),
      title: Text(category.title),
      subtitle: Text('entries:${category.entries.toString()}'),
      trailing: Text('\$ ${category.totalAmount.toString()}'),
    );
  }
}
