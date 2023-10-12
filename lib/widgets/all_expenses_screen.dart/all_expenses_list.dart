import 'package:flutter/material.dart';
import 'package:pet/models/database_provider.dart';
import 'package:provider/provider.dart';

import '../expenses_screen/expence_card.dart';

class AllExpensesList extends StatelessWidget {
  const AllExpensesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (_, db, __) {
        var list = db.expences;
        return ListView.builder(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemCount: list.length,
          itemBuilder: (_, i) => ExpenseCard(list[i]),
        );
      },
    );
  }
}
