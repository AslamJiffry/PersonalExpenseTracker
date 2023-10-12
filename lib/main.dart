import 'package:flutter/material.dart';
import 'package:pet/screens/all_expenses.dart';
import 'package:pet/screens/expenses_screen.dart';
import 'package:provider/provider.dart';
import './models/database_provider.dart';
//screens
import './screens/home_screen.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => DatabaseProvider(),
    child: const PersonalExpenceTracker(),
  ));
}

class PersonalExpenceTracker extends StatelessWidget {
  const PersonalExpenceTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.name,
      routes: {
        HomeScreen.name: (_) => const HomeScreen(),
        ExpensesScreen.name: (_) => const ExpensesScreen(),
        AllExpences.name: (_) => const AllExpences(),
      },
    );
  }
}
