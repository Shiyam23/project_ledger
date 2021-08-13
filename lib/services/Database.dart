
import 'package:project_ez_finance/models/Account.dart';
import 'package:project_ez_finance/models/Category.dart';

abstract class Database {

  Future<List<Category>> getAllCategories();
  Future<List<Account>> getAllAccounts();

}