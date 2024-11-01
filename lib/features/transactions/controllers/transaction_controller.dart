import 'dart:developer';

import 'package:daily_spending/core/constants/app_strings.dart';
import 'package:daily_spending/core/extension/datetime_extension.dart';
import 'package:daily_spending/core/utils/db_helper.dart';
import 'package:daily_spending/features/transactions/data/transaction_enums.dart';
import 'package:daily_spending/features/transactions/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

class TransactionsController with ChangeNotifier {
  List<Transaction> _transactions = [];
  TransactionDate _transactionDate = TransactionDate.daily;

  TransactionDate get transactionDate => _transactionDate;
//No need for turnery operators here.
  List<Transaction> get transactions => _transactions;
  // List<Transaction> get transactions {
  //   return _transactions;
  // }

  num getTotal(List<Transaction> transaction) {
    num total = 0;
    if (transaction.isEmpty) {
      return total;
    }
    transaction.forEach((item) {
      total += item.amount;
    });
    return total;
  }

  Future<void> fetchTransactions({
    TransactionDate date = TransactionDate.daily,
    int? month,
    int? year,
  }) async {
    _transactionDate = date;
    switch (date) {
      case TransactionDate.daily:
        {
          final List<Map<String, dynamic>> fetchedData = await DBHelper.instance.fetch(transactionsTableName);
          _transactions = fetchedData.map((item) => Transaction.fromMap(item)).toList();
          _transactions.sort((a, b) => b.date.compareTo(a.date));
          break;
        }
      case TransactionDate.weekly:
        {
          // Get the timestamp of one week ago
          final int oneWeekAgo = DateTime.now().subtract(Duration(days: 7)).millisecondsSinceEpoch;
          final List<Map<String, dynamic>> fetchedData = await DBHelper.instance.fetch(
            transactionsTableName,
            where: 'date > ?',
            whereArgs: [oneWeekAgo],
          );
          log(fetchedData.toString());
          _transactions = fetchedData.map((item) => Transaction.fromMap(item)).toList();
          _transactions.sort((a, b) => b.date.compareTo(a.date));
          break;
        }
      case TransactionDate.monthly:
        {
          // Parse the month and year into a DateTime object for the first day of the month
          final DateTime startDate = DateTime(year ?? DateTime.now().year, month ?? DateTime.now().month, 1);
          // Calculate the last day of the month
          final DateTime endDate = DateTime(startDate.year, startDate.month + 1, 1).subtract(Duration(days: 1));
          // Convert to milliseconds since epoch
          final int startTimestamp = startDate.millisecondsSinceEpoch;
          final int endTimestamp = endDate.millisecondsSinceEpoch;
          final List<Map<String, dynamic>> fetchedData = await DBHelper.instance.fetch(
            transactionsTableName,
            where: 'date BETWEEN ? AND ?',
            whereArgs: [startTimestamp, endTimestamp],
          );
          _transactions = fetchedData.map((item) => Transaction.fromMap(item)).toList();
          _transactions.sort((a, b) => b.date.compareTo(a.date));
          break;
        }
      case TransactionDate.yearly:
        {
          // Calculate the start and end dates for the year
          final DateTime startDate = DateTime(year ?? DateTime.now().year, 1, 1);
          final DateTime endDate = DateTime((year ?? DateTime.now().year) + 1, 1, 1).subtract(Duration(milliseconds: 1));
          // Convert dates to milliseconds since epoch
          final int startTimestamp = startDate.millisecondsSinceEpoch;
          final int endTimestamp = endDate.millisecondsSinceEpoch;
          final List<Map<String, dynamic>> fetchedData = await DBHelper.instance.fetch(
            transactionsTableName,
            where: 'date BETWEEN ? AND ?',
            whereArgs: [startTimestamp, endTimestamp],
          );
          _transactions = fetchedData.map((item) => Transaction.fromMap(item)).toList();
          _transactions.sort((a, b) => b.date.compareTo(a.date));
          break;
        }
      default:
    }
    notifyListeners();
  }

  Future<void> addTransactions(Transaction transaction) async {
    try {
      final DateTime now = DateTime.now();
      switch (transactionDate) {
        case TransactionDate.daily:
          _transactions.add(transaction);
          break;

        case TransactionDate.weekly:
          if (transaction.date.isAfter(now.subtract(Duration(days: 7)))) {
            _transactions.add(transaction);
          }
          break;

        case TransactionDate.monthly:
          if (!transaction.date.isAfter(now.subtract(Duration(days: 30)))) {
            _transactions.add(transaction);
          }
          break;

        case TransactionDate.yearly:
          if (!transaction.date.isAfter(now.subtract(Duration(days: 365)))) {
            _transactions.add(transaction);
          }
          break;
      }

      notifyListeners();
      await DBHelper.instance.insert(transactionsTableName, transaction.toMap());
      EasyLoading.showSuccess("Transaction added successfully!");
    } catch (error) {
      EasyLoading.showError(error.toString());
    }
  }

  List<Transaction> yearlyTransactions(String year) {
    return _transactions.where((trx) {
      if (DateFormat('yyyy').format(DateTime.parse(trx.date.toIso8601String())) == year) {
        return true;
      }
      return false;
    }).toList();
  }

  // created extension for date which includes basic small operations.
  List<Transaction> dailyTransactions() => _transactions.where((trx) => trx.date.isToday(trx.date)).toList();

  List<Transaction> get weeklyTransaction {
    return transactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  Future<void> deleteTransaction(int id) async {
    final Transaction item = _transactions.firstWhere((item) => item.id == id);
    _transactions.remove(item);
    notifyListeners();
    await DBHelper.instance.delete(transactionsTableName, id);
  }

  List<Map<String, Object>> getTransactionValuesForMonths(int year, List<int> months, List<String> monthTitles) {
    return List.generate(
      months.length,
      (index) {
        final int month = months[index];
        final String monthTitle = monthTitles[index];
        // Calculate the total amount for the given month and year
        final num totalSum = transactions
            .where((transaction) => transaction.date.month == month && transaction.date.year == year)
            .fold<num>(0, (sum, transaction) => sum + transaction.amount);
        return {
          'amount': totalSum.toDouble(),
          'month': monthTitle,
        };
      },
    );
  }

  List<Map<String, Object>> firstSixMonthsTransValues(int year) {
    final List<int> firstSixMonths = [
      DateTime.january,
      DateTime.february,
      DateTime.march,
      DateTime.april,
      DateTime.may,
      DateTime.june,
    ];
    final List<String> firstSixMonthTitles = [
      'january',
      'february',
      'march',
      'april',
      'may',
      'june',
    ];
    return getTransactionValuesForMonths(year, firstSixMonths, firstSixMonthTitles);
  }

  List<Map<String, Object>> lastSixMonthsTransValues(int year) {
    final List<int> lastSixMonths = [
      DateTime.july,
      DateTime.august,
      DateTime.september,
      DateTime.october,
      DateTime.november,
      DateTime.december,
    ];
    final List<String> lastSixMonthTitles = [
      'july',
      'august',
      'september',
      'october',
      'november',
      'december',
    ];
    return getTransactionValuesForMonths(year, lastSixMonths, lastSixMonthTitles);
  }

  List<Map<String, dynamic>> groupedTransactionValues() {
    final now = DateTime.now();

    if (transactionDate == TransactionDate.weekly) {
      return List.generate(7, (index) {
        final DateTime weekDay = now.subtract(Duration(days: index));
        final num totalSum = _transactions.where((transaction) => transaction.date.isSameDay(weekDay)).fold<num>(0, (sum, trx) => sum + trx.amount);
        return {
          'date': DateFormat.d().format(weekDay), // Day of the month
          'amount': totalSum.toDouble(),
          'day': DateFormat.EEEE().format(weekDay), // Full weekday name
        };
      }).reversed.toList(); // Reverse to show from earliest to latest
    } else {
      return List.generate(
        12,
        (index) {
          final DateTime monthDate = DateTime(now.year, index + 1);
          final num totalSum = _transactions
              .where((transaction) => transaction.date.year == monthDate.year && transaction.date.month == monthDate.month)
              .fold<num>(0, (sum, transaction) => sum + transaction.amount);
          return {
            'date': DateFormat.M().format(monthDate), // Numeric month representation (e.g., 1 for January)
            'amount': totalSum.toDouble(),
            'day': DateFormat.MMMM().format(monthDate), // Full month name
          };
        },
      );
    }
  }
}
