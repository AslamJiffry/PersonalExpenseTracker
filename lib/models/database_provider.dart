import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:pet/models/expense.dart';
import 'package:pet/models/expense_category.dart';
import 'package:sqflite/sqflite.dart';
import '../constants/icons.dart';

class DatabaseProvider extends ChangeNotifier {
  String _searchText = '';
  String get searchText => _searchText;

  set searchText(String value) {
    _searchText = value;
    //when the search text change it will notify listners
    notifyListeners();
  }

  //inApp memory for holding expence category
  List<ExpenseCategory> _categories = [];
  List<ExpenseCategory> get categories => _categories;

  List<Expense> _expences = [];
  List<Expense> get expences {
    return _searchText != ''
        ? _expences
            .where((e) => e.title.toLowerCase().contains(_searchText))
            .toList()
        : _expences;
  }

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

  Future<void> updateCategory(
      String category, int nEntries, double nAmount) async {
    final db = await database;

    await db.transaction((txn) async {
      await txn
          .update(
              categoryTable,
              {
                'entries': nEntries,
                'totalAmount': nAmount.toString(),
              },
              where: 'title == ?',
              whereArgs: [category])
          .then((_) {
        //after updating database update our in-app list
        var updatedCategory =
            _categories.firstWhere((element) => element.title == category);
        updatedCategory.entries = nEntries;
        updatedCategory.totalAmount = nAmount;

        notifyListeners();
      });
    });
  }

  //Add expense to database
  Future<void> addExpense(Expense expense) async {
    final db = await database;

    await db.transaction((txn) async {
      await txn
          .insert(expenseTable, expense.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace)
          .then((generatedId) {
        //after inserting into database
        final savedExpence = Expense(
          id: generatedId,
          title: expense.title,
          amount: expense.amount,
          date: expense.date,
          category: expense.category,
        );

        _expences.add(savedExpence);

        //notify the listners
        notifyListeners();

        var existingCategory = findCategory(expense.category);
        //after we insert the expense, need to update the entries and totalamount
        //var result = calculateEntriesAndTotalAmount(expense.category);
        updateCategory(expense.category, existingCategory.entries + 1,
            existingCategory.totalAmount + expense.amount);
      });
    });
  }

  ExpenseCategory findCategory(String title) {
    return _categories.firstWhere((element) => element.title == title);
  }

  Map<String, dynamic> calculateEntriesAndTotalAmount(String category) {
    double total = 0.0;
    var list = _expences.where((element) => element.category == category);

    for (final element in list) {
      total += element.amount;
    }
    return {'entries': list.length, 'totalAmount': total};
  }

  Future<List<Expense>> loadExpences(String category) async {
    final db = await database;

    return db.transaction((txn) async {
      return await txn.query(expenseTable,
          where: 'category == ?', whereArgs: [category]).then((data) {
        final result = List<Map<String, dynamic>>.from(data);
        List<Expense> list = List.generate(
          result.length,
          (index) => Expense.fromString(result[index]),
        );
        _expences = list;
        return _expences;
      });
    });
  }

  double calculateTotalExpenses() {
    return _categories.fold(
        0.0, (previousValue, element) => previousValue + element.totalAmount);
  }

  List<Map<String, dynamic>> calculateWeekExpenses() {
    List<Map<String, dynamic>> data = [];

    for (var i = 0; i < 7; i++) {
      double total = 0.0;

      //substract i from today to get previous dates
      final weekDay = DateTime.now().subtract(
        Duration(days: i),
      );

      for (var j = 0; j < _expences.length; j++) {
        if (_expences[j].date.year == weekDay.year &&
            _expences[j].date.month == weekDay.month &&
            _expences[j].date.day == weekDay.day) {
          //if found then add the amount to total
          total += _expences[j].amount;
        }
      }

      data.add({
        'day': weekDay,
        'amount': total,
      });
    }
    return data;
  }

  Future<List<Expense>> loadAllExpenses() async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(expenseTable).then((data) {
        final result = List<Map<String, dynamic>>.from(data);
        List<Expense> list = List.generate(
          result.length,
          (index) => Expense.fromString(
            result[index],
          ),
        );
        _expences = list;
        return _expences;
      });
    });
  }

  Future<void> deleteExpences(
      int expenceId, String category, double amount) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete(expenseTable,
          where: 'id == ?', whereArgs: [expenceId]).then((_) {
        _expences.removeWhere((element) => element.id == expenceId);
        notifyListeners();

        var existingCategory = findCategory(category);
        //after we delete the expense, need to update the entries and totalamount

        updateCategory(category, existingCategory.entries - 1,
            existingCategory.totalAmount - amount);
      });
    });
  }
}
