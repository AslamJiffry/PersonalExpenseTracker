import 'package:flutter/material.dart';
import '../constants/icons.dart';

class ExpenseCategory {
  final String title;
  int entries = 0;
  double totalAmount = 0.0;
  final IconData icon;

  ExpenseCategory({
    required this.title,
    required this.entries,
    required this.totalAmount,
    required this.icon,
  });

  //will convert this model into map
  //so we can insert to database

  Map<String, dynamic> toMap() => {
        'title': title,
        'entries': entries,
        'totalAmount': totalAmount.toString(), // databes won't store double
        //not goint Icons in databse.
      };

  //we retrieve data from database as map
  //To app to understand data we will convert to ExpenceCategory

  factory ExpenseCategory.fromString(Map<String, dynamic> value) =>
      ExpenseCategory(
        title: value['title'],
        entries: value['entries'],
        totalAmount: double.parse(value['totalAmount']),
        icon: icons[value['title']],
      );
}
