import 'package:flutter/material.dart';
import 'package:pet/models/database_provider.dart';
import 'package:pet/widgets/all_expenses_screen.dart/all_expenses_list.dart';
import 'package:pet/widgets/all_expenses_screen.dart/expenses_search.dart';
import 'package:provider/provider.dart';

class AllExpensesLoader extends StatefulWidget {
  const AllExpensesLoader({super.key});

  @override
  State<AllExpensesLoader> createState() => _AllExpensesLoaderState();
}

class _AllExpensesLoaderState extends State<AllExpensesLoader> {
  late Future _allExpensesList;

  Future _getAllExpenses() async {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return await provider.loadAllExpenses();
  }

  @override
  void initState() {
    super.initState();
    _allExpensesList = _getAllExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _allExpensesList,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    ExpensesSearch(),
                    Expanded(
                      child: AllExpensesList(),
                    ),
                  ],
                ),
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
