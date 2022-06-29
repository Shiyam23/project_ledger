import 'package:project_ez_finance/components/categoryIcon/CategoryIconData.dart';
import 'package:project_ez_finance/models/Category.dart';
import 'package:project_ez_finance/models/currencies.dart';
import 'package:project_ez_finance/services/HiveDatabase.dart';
import 'Transaction.dart';

class CategoryChartInfo{

  CategoryIconData categoryIconData;
  String categoryName;
  double amount;
  String displayedAmount;

  CategoryChartInfo({
    required this.categoryIconData,
    required this.categoryName,
    required this.amount,
    required this.displayedAmount,
  });

  static Future<List<CategoryChartInfo>> getCategories({
    int? top,
    List<Transaction>? transactions
  }) async {

    if (HiveDatabase().selectedAccount == null) {
      await HiveDatabase().setupDatabase();
    }
    String currencyCode = HiveDatabase().selectedAccount!.currencyCode;
    transactions ??= 
      await HiveDatabase().getTransactions({DateTime.now()});
    if (transactions.isEmpty) return [];
    Map<Category, double> categoryAmount = Map<Category, double>();
    for (Transaction transaction in transactions) {
      Category category = transaction.category;
      if (categoryAmount[category] == null) {
        categoryAmount[category] = transaction.amount;
      }
      else {
        categoryAmount[category] = 
          categoryAmount[category]! + transaction.amount;
      }
    }
    List<CategoryChartInfo> result = [];
    for (Category category in categoryAmount.keys) {
      result.add(CategoryChartInfo(
        categoryIconData: category.icon!.iconData, 
        categoryName: category.name!, 
        amount: categoryAmount[category]!,
        displayedAmount: formatCurrency(currencyCode, categoryAmount[category]!),
      ));
    }
    if (top != null) {
      result.sort(((a, b) => b.amount.compareTo(a.amount)));
      return result.getRange(0, 5 < result.length ? 5 : result.length).toList();
    }
    else {
      return result;
    }
  }

}