import 'package:flutter/material.dart';
import 'package:pet/models/database_provider.dart';
import 'package:pet/widgets/expenses_screen/expence_card.dart';
import 'package:provider/provider.dart';

class ExpencesList extends StatelessWidget {
  const ExpencesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (_, db, __) {
        var expenceList = db.expences;
        return ListView.builder(
          itemCount: expenceList.length,
          itemBuilder: (_, i) => ExpenseCard(expenceList[i]),
        );
      },
    );
  }
}
