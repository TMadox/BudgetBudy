import 'dart:async';
import 'dart:developer';

import 'package:daily_spending/core/constants/app_strings.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class DBHelper {
  // create one single instance of the database so we don't need to open it over and over
  sql.Database? _database;
  // a private constructor to use when calling for the same singelton
  DBHelper._privateConstructor();
  // a static instance of the database
  static final DBHelper instance = DBHelper._privateConstructor();
  // function to return/initialize the database
  Future<sql.Database> initDatabase() async {
    if (_database != null) return _database!;
    //Specified data type of the variable for a better understanding
    final String dbpath = await sql.getDatabasesPath();
    _database = await sql.openDatabase(
      path.join(dbpath, 'spendings.db'),
      onOpen: (db) async {
        //Create table if it doesn't exist
        final List<Map<String, Object?>> transactionTable =
            await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='transactions'");
        final List<Map<String, Object?>> savingsTable = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='savings'");
        final List<Map<String, Object?>> targetsTable = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='targets'");

        if (transactionTable.isEmpty) {
          await db.execute(
            'CREATE TABLE $transactionsTableName('
            'id INTEGER PRIMARY KEY, '
            'title TEXT, '
            'amount INTEGER, '
            'date INTEGER, '
            'category TEXT'
            ')',
          );
        }
        if (savingsTable.isEmpty) {
          await db.execute(
            'CREATE TABLE $savingsTableName ('
            'id INTEGER PRIMARY KEY, '
            'title TEXT, '
            'amount REAL, '
            'date INTEGER, '
            'targetId INTEGER, '
            'FOREIGN KEY(targetId) REFERENCES targets(id) ON DELETE CASCADE'
            ')',
          );
        }
        if (targetsTable.isEmpty) {
          await db.execute(
            'CREATE TABLE $targetsTableName ('
            'id INTEGER PRIMARY KEY, '
            'title TEXT, '
            'amount REAL, '
            'percentage REAL, '
            'endDate INTEGER, '
            'startDate INTEGER, '
            'createdAt INTEGER'
            ')',
          );
          ;
        }
      },
      onCreate: (db, version) async {
        //Rewritten the query in this formate to be more readable
        await db.execute(
          'CREATE TABLE transactions('
          'id INTEGER PRIMARY KEY, '
          'title TEXT, '
          'amount INTEGER, '
          'date INTEGER, '
          'category TEXT'
          ')',
        );
        await db.execute(
          'CREATE TABLE savings ('
          'id INTEGER PRIMARY KEY, '
          'title TEXT, '
          'amount REAL, '
          'date INTEGER, '
          'targetId INTEGER, '
          'FOREIGN KEY(targetId) REFERENCES targets(id) ON DELETE CASCADE'
          ')',
        );
        await db.execute(
          'CREATE TABLE targets ('
          'id INTEGER PRIMARY KEY, '
          'title TEXT, '
          'amount REAL, '
          'percentage REAL, '
          'endDate INTEGER, '
          'startDate INTEGER, '
          'createdAt INTEGER'
          ')',
        );
        ;
        log("message");
      },
      version: 1,
    );
    return _database!;
  }

  Future<void> drop(String table) async {
    final sql.Database sqlDb = await initDatabase();
    await sqlDb.execute('DROP TABLE IF EXISTS $table');
  }

  //Inserting the transaction data
  Future<void> insert(String table, Map<String, dynamic> input) async {
    final sql.Database db = await initDatabase();
    // We removed the transaction input from toMap() as it's no longer wanted.
    await db.insert(table, input, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  //Retereving the transaction data
  Future<List<Map<String, dynamic>>> fetch(String tableName, {String? where, List<dynamic>? whereArgs}) async {
    final sql.Database sqlDb = await initDatabase();
    return sqlDb.query(
      tableName,
      where: where,
      whereArgs: whereArgs,
    );
  }

//General multi purpose function
  Future<void> updateRecord(
    String tableName,
    Map<String, dynamic> values,
    String whereClause,
    List<dynamic> whereArgs,
  ) async {
    final sql.Database sqlDb = await initDatabase();
    await sqlDb.update(
      tableName,
      values,
      where: whereClause,
      whereArgs: whereArgs,
    );
  }

  //deleting the transactions
  Future<void> delete(dynamic id) async {
    final sql.Database sqlDb = await initDatabase();
    await sqlDb.delete('transactions', where: "id=?", whereArgs: [id]);
  }
}
