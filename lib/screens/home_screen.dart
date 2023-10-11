import 'package:flutter/material.dart';
import 'package:pet/models/expense.dart';
import 'package:pet/widgets/add_expense.dart';
import 'package:pet/widgets/home_screen/category_loader.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  //routes
  static const name = '/home_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const CategoryLoader(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const AddExpence(),
          );
        },
      ),
    );
  }
}
