import 'package:flutter/material.dart';

import '../widgets/all_expenses_screen.dart/all_expenses_loader.dart';

class AllExpences extends StatefulWidget {
  const AllExpences({super.key});
  static const name = '/all_expenses';
  @override
  State<AllExpences> createState() => _AllExpencesState();
}

class _AllExpencesState extends State<AllExpences> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Expenses"),
      ),
      body: const AllExpensesLoader(),
    );
  }
}
