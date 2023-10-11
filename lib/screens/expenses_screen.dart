import 'package:flutter/material.dart';

import '../widgets/expenses_screen/expenses_loader.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});
  static const name = '/expenses_screen';

  @override
  Widget build(BuildContext context) {
    //get the argument passed by category_card
    final category = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      body: ExpencesLoader(category),
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
    );
  }
}
