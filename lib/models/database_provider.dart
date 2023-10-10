import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:pet/models/expense_category.dart';
import 'package:sqflite/sqflite.dart';
import '../constants/icons.dart';

class DatabaseProvider extends ChangeNotifier {
  //inApp memory for holding expence category
  List<ExpenseCategory> _categories = [];
  List<ExpenseCategory> get categories => _categories;

  Database? _database;
  Future<Database> get database async {
    //database directory
    final dbDirectory = await getDatabasesPath();

    //database name
    const dbName = "personal_expence_tracker.db";

    //full path
    final path = join(dbDirectory, dbName);

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb, //will create separately
    );

    return _database!;
  }

  static const categoryTable = 'categoryTable';
  static const expenseTable = 'expenseTable';
  //will run only once when db creation
  Future<void> _createDb(Database db, int version) async {
    await db.transaction((txn) async {
      //category table
      await txn.execute('''CREATE TABLE $categoryTable(
        title TEXT,
        entries INTEGER,
        totalAmount TEXT
       )''');

      //expense table
      await txn.execute('''CREATE TABLE $expenseTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        amount TEXT,
        date TEXT,
        category TEXT
       )''');

      for (int i = 0; i < icons.length; i++) {
        await txn.insert(categoryTable, {
          'title': icons.keys.toList()[i],
          'entries': 0,
          'totalAmount': (0.0).toString(),
        });
      }
    });
  }

  Future<List<ExpenseCategory>> getExpenseCategories() async {
    final db = await database;

    return await db.transaction((txn) async {
      return await txn.query(categoryTable).then((data) {
        //convert from Map<String,object> to Map<String, dynamic>
        final converted = List<Map<String, dynamic>>.from(data);

        //create ExpenceCategory from every map
        List<ExpenseCategory> ecList = List.generate(
          converted.length,
          (index) => ExpenseCategory.fromString(converted[index]),
        );
        _categories = ecList;
        return _categories;
      });
    });
  }
}
