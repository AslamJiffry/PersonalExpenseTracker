import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../constants/icons.dart';

class DatabaseProvider {
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
}
