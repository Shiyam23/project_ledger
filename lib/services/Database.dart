import 'package:project_ez_finance/models/Account.dart';
import 'package:project_ez_finance/models/Category.dart';
import 'package:project_ez_finance/models/StandingOrder.dart';
import 'package:project_ez_finance/models/Transaction.dart';

abstract class Database {
  bool get changed;
  Future<List<Category>> getAllCategories();
  Future<List<Account>> getAllAccounts();
  void addAccount(Account newAccount);
  void changeAccount(Account oldAccount, Account newAccount);
  void deleteAccount(Account account);
  void addCategory(Category newCategory);
  Future<bool> changeCategory(Category oldCategory, Category newCategory);
  void deleteCategory(Category category);
  void setupDatabase();
  Future<bool> deleteTransactions(List<Transaction> transactions);
  Future<void> saveTransaction(Transaction transaction, bool templateChecked);
  Future<void> saveStandingOrder(StandingOrder standingOrder);
  Future<void> deleteStandingOrder(StandingOrder standingOrder);
  Future<List<Transaction>> getTransactions(Set<DateTime> months);
  Future<List<Transaction>> getTemplates();
  Future<List<StandingOrder>> getStandingOrders();
  Future<bool> deleteTemplate(Transaction template); 
  Future<bool> selectAccount(Account account);
  Account? get selectedAccount;
  Future<void> updateStandingOrder(StandingOrder standingOrder, StandingOrder newStandingOrder);
}