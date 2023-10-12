import 'package:flutter/material.dart';
import 'package:pet/models/database_provider.dart';
import 'package:pet/models/expense.dart';
import 'package:provider/provider.dart';

class ConfirmationMessage extends StatelessWidget {
  const ConfirmationMessage({
    super.key,
    required this.expense,
  });

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(
      context,
      listen: false,
    );
    return AlertDialog(
      title: Text('Delete ${expense.title} ?'),
      content: Row(children: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('No')),
        const SizedBox(
          width: 5,
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              provider.deleteExpences(
                  expense.id, expense.category, expense.amount);
            },
            child: const Text('Yes')),
      ]),
    );
  }
}
