import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet/constants/icons.dart';
import 'package:pet/models/database_provider.dart';
import 'package:pet/models/expense.dart';
import 'package:pet/widgets/expenses_screen/confirmation_message.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  const ExpenseCard(this.expense, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(expense.id),
      confirmDismiss: (_) async {
        showDialog(
            context: context,
            builder: (_) => ConfirmationMessage(expense: expense));
      },
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icons[expense.category]),
        ),
        title: Text(expense.title),
        subtitle: Text(DateFormat('MMMM dd,yyyy').format(expense.date)),
        trailing: Text(NumberFormat.currency(locale: 'en_SL', symbol: 'Rs')
            .format(expense.amount)),
      ),
    );
  }
}
