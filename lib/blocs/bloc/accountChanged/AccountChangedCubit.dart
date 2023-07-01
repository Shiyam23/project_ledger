import 'package:flutter/material.dart';
import 'package:dollavu/models/CategoryChartInfo.dart';
class AccountChangeNotifier extends ChangeNotifier {
  
  Future<List<CategoryChartInfo>> _categories 
    = CategoryChartInfo.getCategories(top: 5);

  bool changed = false;

  Future<List<CategoryChartInfo>> get categories {
    if (changed) _categories = CategoryChartInfo.getCategories(top: 5);
    changed = false;
    return _categories;
  }

  void notify() {
    changed = true;
    notifyListeners();
  }

  
}