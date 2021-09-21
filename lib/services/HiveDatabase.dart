import 'dart:io';
import 'dart:math';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIconData.dart';
import 'package:project_ez_finance/models/Account.dart';
import 'package:project_ez_finance/models/Category.dart';
import 'package:project_ez_finance/models/Repetition.dart';
import 'package:project_ez_finance/models/Transaction.dart';
import 'Database.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

typedef bool DeleteIf(Transaction element);

class HiveDatabase implements Database {

  static final HiveDatabase _singleton = HiveDatabase._internal();

  factory HiveDatabase() {
    return _singleton;
  }
  
  HiveDatabase._internal();
  
  Account? _selectedAccount;
  bool _changed = true;

  final List<Account> _accountList = [];
  final List<Category> _categoryList = [];
  final List<Transaction> _transactions = [];
  final Set<String> _boxes = {};
  final Set<Box?> _openBoxes = {};

  static const String accountBoxName = "accounts";
  static const String categoryBoxName = "categories";
  static const String accountBoxMapBoxName = "accountBoxMap";
  static const String boxesBoxName = "boxes";
  static const String templateBoxName = "templates";

  @override
  Future<List<Account>> getAllAccounts() async{
    Box? accountBox = await Hive.openBox(accountBoxName);
    _accountList.clear();
    accountBox.values.forEach((e) => _accountList.add(e));
    return Future.value(_accountList);
  }

  @override
  Future<List<Category>> getAllCategories() async {
    Box? categoryBox = await Hive.openBox(categoryBoxName);
    _categoryList.clear();
    categoryBox.values.forEach((e) => _categoryList.add(e));
    return Future.value(_categoryList);
  }

  @override
  void changeAccount(Account oldAccount, Account newAccount) async {
    if (!_accountList.contains(newAccount)) {
      int i = _accountList.indexWhere((account) => account.name == oldAccount.name);
      Box? accountBox = await Hive.openBox(accountBoxName);
      accountBox.putAt(i, newAccount);
      _accountList[i] = newAccount;
      if (oldAccount.name != newAccount.name) {
        Box? accountBoxMap = await Hive.openBox(accountBoxMapBoxName);
        int boxName = accountBox.get(oldAccount.name);
        accountBoxMap.delete(oldAccount.name);
        accountBoxMap.put(newAccount.name, boxName);
      }
    }
  }

  @override
  Future<void> addAccount(Account newAccount) async {
    Box? accountBox = await Hive.openBox(accountBoxName);
    if (accountBox.containsKey(newAccount.name)) {
      throw Exception("Account with this name already exists!");
    }
    accountBox.add(newAccount);
    _accountList.add(newAccount);
    // Get next available number for boxname
    Box? accountBoxMap = await Hive.openBox(accountBoxMapBoxName);
    List<int> allBoxNames = accountBoxMap.values.toList(growable: false).cast<int>();
    int? boxName;
    if (allBoxNames.isEmpty) boxName = 0;
    else {
      allBoxNames.sort();
      for(int i = 0; i < allBoxNames.length; i++) {
        if (allBoxNames[i] != i) {
          boxName = i;
          break;
        }
      }
      boxName ??= allBoxNames.last + 1;
    }
    accountBoxMap.put(newAccount.name, boxName);
  }

  @override
  void deleteAccount(Account deletedAccount) async {
    int i = _accountList.indexWhere((account) => account.name == deletedAccount.name);
    _accountList.removeAt(i);
    Box? accountBox = await Hive.openBox(accountBoxName);
    accountBox.deleteAt(i);
    _deleteTransactionsOfAccount(deletedAccount);
    _deleteTemplates((template) => template.account == deletedAccount);
    Box? accountBoxMap = await Hive.openBox(accountBoxMapBoxName);
    accountBoxMap.delete(deletedAccount.name);
  }

  @override
  void setupDatabase() async {
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    // Registering all adapters
    Hive.registerAdapter(CategoryIconAdapter());
    Hive.registerAdapter(CategoryIconDataAdapter());
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(TransactionAdapter());
    Hive.registerAdapter(RepetitionAdapter());
    Hive.registerAdapter(CalenderUnitAdapter());
    Hive.registerAdapter(AccountAdapter());

    // Saving all box names
    _boxes.clear();
    (await Hive.openBox(boxesBoxName)).values.forEach((box) => _boxes.add(box));

    // Printing box names for debugging
    _boxes.forEach(print);

    // Add a default account if the list of accounts is empty
    await getAllAccounts();
    if (_accountList.isEmpty) {
      Account firstAccount = Account(
        name: "Privatkonto",
        selected: true,
        currencyCode: "EUR",
        icon: CategoryIcon(
          iconData: CategoryIconData(
            iconName: "home"
          ),
        )
      );
      await addAccount(firstAccount);
    }

    // Add a default category if the list of category is empty
    await getAllCategories();
    if (_categoryList.isEmpty) {
      Category firstCategory = Category(
        name: "Shopping",
        icon: CategoryIcon(
          iconData: CategoryIconData(
            iconName: "shopping"
          ),
        )
      );
      addCategory(firstCategory);
    }

    // Initialize selected account
    _selectedAccount = _accountList.firstWhere((account) => account.selected);
  }

  @override
  void deleteAllTransactions() async {
     _transactions.clear();
    if (_selectedAccount != null) {
      _deleteTransactionsOfAccount(_selectedAccount!);
    } 
    _changed = true;
  }

  void _deleteTransactionsOfAccount(Account account) async {
    Box? accountBoxMap = await Hive.openBox(accountBoxMapBoxName);
    String prefix = accountBoxMap.get(account.name).toString();
    Box? nameBoxes = await Hive.openBox("boxes");
    nameBoxes.values.forEach((name) async {
      if ((name as String).split("_")[0] == prefix) {
        Hive.deleteBoxFromDisk(name);
        int index = nameBoxes.values.toList().indexOf(name);
        nameBoxes.deleteAt(index);
        _boxes.remove(name);
      }
    });
  }
  
  void _deleteTemplates(DeleteIf deleteIf) async{
    Box? templateBox = await Hive.openBox(templateBoxName);
    int i = 0;
    while (i < templateBox.values.toList().length) {
      if (deleteIf(templateBox.values.toList()[i])) 
        await templateBox.deleteAt(i);
      else i++;
    }
  }

  Future<Box?> _getBoxFromDate({ 
    required DateTime date,
    required Account account,
    bool createNew = false,
  }) async {
    Box? accountBoxMap = await Hive.openBox(accountBoxMapBoxName);
    String boxPrefix = accountBoxMap.get(account.name).toString();
    String currentName = "$boxPrefix" +
      "_${DateFormat.yMMM().format(date).replaceAll(" ", "").toLowerCase()}";
    if (createNew || await Hive.boxExists(currentName)) {
      print("Opening Box:" + currentName);
      Box nameBoxes = await Hive.openBox("boxes");
      if (!nameBoxes.values.contains(currentName)) nameBoxes.add(currentName);
      Box? currentBox = await Hive.openBox(currentName);
      _boxes.add(currentName);
      _openBoxes.add(currentBox);
      return currentBox;
    }
    return null;
  }

  Future<void> saveTransaction(Transaction transaction, bool templateChecked) async {
    Box? currentBox = await _getBoxFromDate(
      date: transaction.date,
      account: transaction.account,
      createNew: true
      );
    if (currentBox != null) {
      currentBox.add(transaction);
      _transactions.add(transaction);
      print("Saving into Box:" + currentBox.name);
      currentBox.close();
    }
    if (templateChecked) {
      Box? templateBox = await Hive.openBox(templateBoxName);
      templateBox.add(transaction);
    }
  }

  @override
  Future<List<Transaction>> getTransactions(Set<DateTime> months) async {
    if (_selectedAccount != null) {
      Set<Box?> neededBoxes = (await Future.wait(
        months.map((month) => _getBoxFromDate(
          date: month,
          account: _selectedAccount!
        ))
      )).toSet();
      _transactions.clear();
      neededBoxes.forEach((box) {
        box?.values.forEach((t) => _transactions.add(t));
      });
      _openBoxes.difference(neededBoxes).forEach((box) {
        print("Closing " + (box?.name ?? "nothing"));
        box?.close();
        _openBoxes.remove(box);
      });
    }
    _changed = true;
    return _transactions;
  }

  Future<List<Transaction>> getTemplates() async {
    Box? templateBox = await Hive.openBox(templateBoxName);
    return templateBox.values.cast<Transaction>().toList();
  }

  Future<bool> deleteTemplate(Transaction template) async {
    try {
      Box? templateBox = await Hive.openBox(templateBoxName);
      int index = templateBox.values.toList().indexOf(template);
      templateBox.deleteAt(index);
    } on HiveError {
      return false;
    }
    return true;
  }

  @override
  Future<bool> selectAccount(Account selection) async {
    int oldIndex = _accountList.indexWhere((account) => account.selected);
    int newIndex = _accountList.indexOf(selection);
    Account modifiedOldAccount = _accountList[oldIndex].copyWith(
      selected: false
    );
    Account modifiedNewAccount = selection.copyWith(
      selected: true
    );
    try {
      Box? accountBox = await Hive.openBox(accountBoxName);
      accountBox.putAt(oldIndex, modifiedOldAccount);
      accountBox.putAt(newIndex, modifiedNewAccount);
      _selectedAccount = modifiedNewAccount;
      _changed = true;
    } on HiveError {
      return false;
    }
    return true;
  }

  Account? get selectedAccount => _selectedAccount;
  bool get changed => _changed;

  @override
  void addCategory(Category newCategory) async {
    Box? categoryBox = await Hive.openBox(categoryBoxName);
    if (categoryBox.containsKey(newCategory.name)) {
      throw Exception("Category with this name already exists!");
    }
    categoryBox.add(newCategory);
    _categoryList.add(newCategory);
  }

  @override
  Future<bool> changeCategory(Category oldCategory, Category newCategory) async {
    try {
      Box? categoryBox = await Hive.openBox(categoryBoxName);
      int index = categoryBox.values.toList().indexOf(oldCategory);
      categoryBox.putAt(index, newCategory);
      _categoryList[index] = newCategory;
      for (String boxName in _boxes) {
        Box? box = await Hive.openBox(boxName);
        List<Transaction> transactions = box.values.cast<Transaction>().toList();
        for (int i = 0; i < box.values.toList().length; i++) {
          if (transactions[i].category!.name == oldCategory.name) {
            Transaction newTransaction = transactions[i];
            newTransaction.category = newCategory;
            box.putAt(i, newTransaction);
          }
        }
        if (!_openBoxes.contains(box)) {
          box.close();
        }
      }
    } on Exception {
      return false;
    } on HiveError {
      return false;
    }
    _changed = true;
    return true;
  }

  @override
  void deleteCategory(Category category) async {
    Box? categoryBox = await Hive.openBox(categoryBoxName);
    int index = categoryBox.values.toList().indexOf(category);
    categoryBox.deleteAt(index);
    _categoryList.removeAt(index);
    categoryBox.compact();
    for (String boxName in _boxes) {
      Box? box = await Hive.openBox(boxName);
      int i = 0;
      while (i < box.values.toList().length) {
        if (box.values.toList()[i].category!.name == category.name) 
          await box.deleteAt(i);
        else i++;
      }
      if (!_openBoxes.contains(box)) {
        box.close();
      }
      if (box.isEmpty) box.deleteFromDisk();
      else box.compact();
    }
    _deleteTemplates((template) => template.category == category);
    _changed = true;
  }
}

