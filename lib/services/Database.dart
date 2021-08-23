
import 'package:project_ez_finance/models/Account.dart';
import 'package:project_ez_finance/models/Category.dart';
import 'package:project_ez_finance/models/Transaction.dart';

abstract class Database {

  Future<List<Category>> getAllCategories();
  Future<List<Account>> getAllAccounts();
  void addAccount(Account newAccount);
  void changeAccount(Account oldAccount, Account newAccount);
  void deleteAccount(Account newAccount);
  void setupDatabase();
  void deleteAllTransactions();
  void saveTransaction(Transaction transaction);
  Future<List<Transaction>> getTransactions(Set<DateTime> months);
  void selectAccount(Account account);
  Account? get selectedAccount;
}