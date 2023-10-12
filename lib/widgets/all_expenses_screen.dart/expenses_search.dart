import 'package:flutter/material.dart';
import 'package:pet/models/database_provider.dart';
import 'package:provider/provider.dart';

class ExpensesSearch extends StatefulWidget {
  const ExpensesSearch({super.key});

  @override
  State<ExpensesSearch> createState() => _ExpensesSearchState();
}

class _ExpensesSearchState extends State<ExpensesSearch> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return TextField(
      onChanged: (value) {
        provider.searchText = value;
      },
      decoration: const InputDecoration(labelText: 'Search expenses...'),
    );
  }
}
