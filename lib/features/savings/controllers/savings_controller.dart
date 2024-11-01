import 'dart:developer';

import 'package:daily_spending/core/constants/app_strings.dart';
import 'package:daily_spending/core/utils/db_helper.dart';
import 'package:daily_spending/features/savings/models/saving.dart';
import 'package:daily_spending/features/savings/models/targets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SavingsController extends ChangeNotifier {
  List<Saving> _savings = [];
  List<Target> _targets = [];

  List<Saving> get savings => _savings;
  List<Target> get targets => _targets;

  Future<List<Target>> loadSavingTargets() async {
    final List<Map<String, dynamic>> fetchTargets = await DBHelper.instance.fetch(targetsTableName);
    _targets = fetchTargets.map((item) => Target.fromMap(item)).toList();
    notifyListeners();
    return _targets;
  }

  Future<List<Saving>> loadSavingsFromTarget(int targetId) async {
    final List<Map<String, dynamic>> fetchTargets = await DBHelper.instance.fetch(
      savingsTableName,
      where: 'targetId = ?',
      whereArgs: [targetId],
    );
    _savings = fetchTargets.map((item) => Saving.fromMap(item)).toList();
    return _savings;
  }

  Future<void> addSavings(Saving saving, Target target) async {
    try {
      EasyLoading.show();
      _savings.add(saving);
      await DBHelper.instance.insert(savingsTableName, saving.toMap());
      await updateTarget(target);
      notifyListeners();
      EasyLoading.showSuccess("a New saving has been added, Good job!");
    } catch (e) {
      EasyLoading.showError(e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> addTarget(Target target) async {
    try {
      _targets.add(target);
      notifyListeners();
      await DBHelper.instance.insert(targetsTableName, target.toMap());
      EasyLoading.showSuccess("a New target has been added!");
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  Future<void> deleteTarget(int targetId) async {
    try {
      EasyLoading.show();
      final int targetIndex = _targets.indexWhere((element) => element.id == targetId);
      _targets.removeAt(targetIndex);
      notifyListeners();
      await DBHelper.instance.delete(targetsTableName, targetId);
    } catch (e) {
      EasyLoading.showError(e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> updateTarget(Target target) async {
    final num totalSavings = _savings.fold(0, (previousValue, element) => previousValue + element.amount);
    final num percentage = ((totalSavings / target.amount) * 100).clamp(0, 100);
    await DBHelper.instance.updateRecord(
      targetsTableName,
      {'percentage': percentage},
      'id = ?',
      [target.id],
    );
    final int targetIndex = _targets.indexWhere((element) => element.id == target.id);
    _targets[targetIndex] = target.copyWith(percentage: percentage);
    log(_targets[targetIndex].toJson());
  }
}
