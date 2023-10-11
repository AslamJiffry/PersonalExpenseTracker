import 'package:flutter/material.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});
  static const name = '/expenses_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
    );
  }
}
