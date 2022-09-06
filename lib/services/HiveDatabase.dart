import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIconData.dart';
import 'package:project_ez_finance/models/Account.dart';
import 'package:project_ez_finance/models/Category.dart';
import 'package:project_ez_finance/models/Repetition.dart';
import 'package:project_ez_finance/models/StandingOrder.dart';
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
  bool _initialized = false;

  final List<Category> _categoryList = [];
  final List<Transaction> _transactions = [];
  final Set<String> _boxes = {};
  final Set<Box<Transaction>?> _openBoxes = {};

  static const String accountBoxName = "accounts";
  static const String categoryBoxName = "categories";
  static const String boxesBoxName = "boxes";
  static const String templateBoxName = "templates";
  static const String standingOrderBoxName = "standingOrders";

  @override
  Future<List<Account>> getAllAccounts() async{
    Box<Account>? accountBox = await Hive.openBox(accountBoxName);
    return accountBox.values.toList().cast<Account>();
  }

  @override
  Future<List<Category>> getAllCategories() async {
    Box<Category>? categoryBox = await Hive.openBox(categoryBoxName);
    _categoryList.clear();
    categoryBox.values.forEach((e) => _categoryList.add(e));
    return Future.value(_categoryList);
  }

  @override
  void changeAccount(Account oldAccount, Account newAccount) async {
    Box<Account>? accountBox = await Hive.openBox(accountBoxName);
    if (!accountBox.values.any((account) => account.name == newAccount.name)) {
      int accountId = accountBox.keys
      .singleWhere((id) => accountBox.get(id) == oldAccount);
      accountBox.put(accountId, newAccount);
    }
  }

  @override
  Future<void> addAccount(Account newAccount) async {
    Box<Account>? accountBox = await Hive.openBox(accountBoxName);
    if (accountBox.values.contains(newAccount)) {
      throw Exception("Account with this name already exists!");
    }
    // Get next available number for boxname
    int accountId = 0;
    while (accountBox.get(accountId) != null) {
      accountId++;
    }
    accountBox.put(accountId, newAccount);
  }

  @override
  void deleteAccount(Account deletedAccount) async {
    Box<Account>? accountBox = await Hive.openBox(accountBoxName);
    int accountId = accountBox.keys.
    singleWhere((accountId) => accountBox.get(accountId) == deletedAccount);
    accountBox.deleteAt(accountId);
    _deleteTransactionsOfAccount(deletedAccount);
    _deleteTemplates((template) => template.account == deletedAccount);
  }
  
  @override
  Future<void> setupDatabase() async {
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
    Hive.registerAdapter(StandingOrderAdapter());

    // Saving all box names
    _boxes.clear();
    (await Hive.openBox<String>(boxesBoxName)).values.forEach((box) => _boxes.add(box));

    // Printing box names for debugging
    _boxes.forEach(print);

    // Add a default account if the list of accounts is empty
    Box<Account>? accountBox = await Hive.openBox(accountBoxName);
    if (accountBox.isEmpty) {
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
      _initialized = true;
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
    _selectedAccount = accountBox.values
    .firstWhere((account) => account.selected);
  }

  void _deleteTransactionsOfAccount(Account account) async {
    Box<Account>? accountBox = await Hive.openBox(accountBoxName);
    int accountId = accountBox.keys.singleWhere((id) => accountBox.get(id) == account);
    String prefix = accountId.toString();
    Box<String>? nameBoxes = await Hive.openBox("boxes");
    nameBoxes.values.forEach((name) async {
      if (name.split("_")[0] == prefix) {
        Hive.deleteBoxFromDisk(name);
        int index = nameBoxes.values.toList().indexOf(name);
        nameBoxes.deleteAt(index);
        _boxes.remove(name);
      }
    });
    _changed = true;
  }

  @override
  Future<bool> deleteTransactions(List<Transaction> transactions) async {
    bool noError = false;
    transactions.forEach((transaction) async {
      Box<Transaction>? relevantBox = await _getBoxFromDate(
        date: transaction.date, 
        account: transaction.account
      );
      int index = relevantBox!.values.toList().indexOf(transaction);
      if (index > - 1) {
        try {
          relevantBox.deleteAt(index);
        }
        on HiveError {
          noError = false;
        }
        noError = true;
      }
      noError = false;
    });
    _changed = true;
    return noError;
  }
  
  void _deleteTemplates(DeleteIf deleteIf) async {
    Box<Transaction>? templateBox = await Hive.openBox(templateBoxName);
    int i = 0;
    while (i < templateBox.values.toList().length) {
      if (deleteIf(templateBox.values.toList()[i])) 
        await templateBox.deleteAt(i);
      else i++;
    }
  }

  Future<Box<Transaction>?> _getBoxFromDate({ 
    required DateTime date,
    required Account account,
    bool createNew = false,
  }) async {
    Box<Account>? accountBox = await Hive.openBox(accountBoxName);
    int accountId = accountBox.keys.singleWhere((id) => accountBox.get(id) == account);
    String boxPrefix = accountId.toString();
    String currentName = "$boxPrefix" +
      "_${DateFormat.yMMM().format(date).replaceAll(" ", "").toLowerCase()}";
    if (createNew || await Hive.boxExists(currentName)) {
      print("Opening Box:" + currentName);
      Box<String> nameBoxes = await Hive.openBox("boxes");
      if (!nameBoxes.values.contains(currentName)) nameBoxes.add(currentName);
      Box<Transaction>? currentBox = await Hive.openBox(currentName);
      _boxes.add(currentName);
      _openBoxes.add(currentBox);
      return currentBox;
    }
    return null;
  }

  Future<void> saveTransaction(Transaction transaction, bool templateChecked) async {
    Box<Transaction>? currentBox = await _getBoxFromDate(
      date: transaction.date,
      account: transaction.account,
      createNew: true
    );
    if (currentBox != null) {
      currentBox.add(transaction);
      _transactions.add(transaction);
      print("Saving into Box:" + currentBox.name);
    }
    if (templateChecked) {
      Box<Transaction>? templateBox = await Hive.openBox(templateBoxName);
      templateBox.add(transaction.copyWith(repetition: Repetition.none));
    }
  }

  @override
  Future<List<Transaction>> getTransactions(Set<DateTime> months) async {
    if (_selectedAccount != null) {
      Set<Box<Transaction>?> neededBoxes = (await Future.wait(
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
    Box<Transaction>? templateBox = await Hive.openBox(templateBoxName);
    return templateBox.values.cast<Transaction>().toList();
  }

  Future<bool> deleteTemplate(Transaction template) async {
    try {
      Box<Transaction>? templateBox = await Hive.openBox(templateBoxName);
      int index = templateBox.values.toList().indexOf(template);
      templateBox.deleteAt(index);
    } on HiveError {
      return false;
    }
    return true;
  }

  Future<List<StandingOrder>> getStandingOrders() async {
    Box<StandingOrder>? standingOrderBox = await Hive.openBox(standingOrderBoxName);
    return standingOrderBox.values.toList();
  }

  Future<bool> deleteStandingOrder(StandingOrder standingOrder) async {
    try {
      Box<StandingOrder>? standingOrderBox = await Hive.openBox(standingOrderBoxName);
      int index = standingOrderBox.values.toList().indexOf(standingOrder);
      standingOrderBox.deleteAt(index);
    } on HiveError {
      return false;
    }
    return true;
  }

  @override
  Future<bool> selectAccount(Account selection) async {
    Box<Account>? accountBox = await Hive.openBox(accountBoxName);
    int oldId = accountBox.keys
      .singleWhere((id) => (accountBox.get(id) as Account).selected);
    int newId = accountBox.keys
      .singleWhere((id) => accountBox.get(id) == selection);
    Account modifiedOldAccount = accountBox.get(oldId)!.copyWith(
      selected: false
    );
    Account modifiedNewAccount = selection.copyWith(
      selected: true
    );
    try {
      Box<Account>? accountBox = await Hive.openBox(accountBoxName);
      accountBox.put(oldId, modifiedOldAccount);
      accountBox.put(newId, modifiedNewAccount);
      _selectedAccount = modifiedNewAccount;
      _changed = true;
    } on HiveError {
      return false;
    }
    return true;
  }

  Account? get selectedAccount => _selectedAccount;
  bool get changed => _changed;
  bool get initialized => _initialized;

  @override
  void addCategory(Category newCategory) async {
    Box<Category>? categoryBox = await Hive.openBox(categoryBoxName);
    if (categoryBox.containsKey(newCategory.name)) {
      throw Exception("Category with this name already exists!");
    }
    categoryBox.add(newCategory);
    _categoryList.add(newCategory);
  }

  @override
  Future<bool> changeCategory(Category oldCategory, Category newCategory) async {
    try {
      Box<Category>? categoryBox = await Hive.openBox(categoryBoxName);
      int index = categoryBox.values.toList().indexOf(oldCategory);
      categoryBox.putAt(index, newCategory);
      _categoryList[index] = newCategory;
      for (String boxName in _boxes) {
        Box<Transaction>? box = await Hive.openBox(boxName);
        List<Transaction> transactions = box.values.toList();
        for (int i = 0; i < box.values.toList().length; i++) {
          if (transactions[i].category.name == oldCategory.name) {
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
    Box<Category>? categoryBox = await Hive.openBox(categoryBoxName);
    int index = categoryBox.values.toList().indexOf(category);
    categoryBox.deleteAt(index);
    _categoryList.removeAt(index);
    categoryBox.compact();
    for (String boxName in _boxes) {
      Box<Transaction>? box = await Hive.openBox(boxName);
      int i = 0;
      while (i < box.values.toList().length) {
        if (box.values.toList()[i].category.name == category.name) 
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

  Future<void> saveStandingOrder(StandingOrder standingOrder) async {
    Box<StandingOrder>? standingOrderBox = await Hive.openBox(standingOrderBoxName);
    standingOrderBox.add(standingOrder);
  }

  Future<void> updateStandingOrder(
    StandingOrder standingOrder, 
    StandingOrder newStandingOrder
  ) async {
    Box<StandingOrder>? standingOrderBox = await Hive.openBox(standingOrderBoxName);
    int index = standingOrderBox.values.toList().indexOf(standingOrder);
    standingOrderBox.putAt(index, newStandingOrder);
  }

  Future<void> reset() async {
  _openBoxes.clear();
  _boxes.clear();
  (await Hive.openBox(boxesBoxName)).values.forEach((box) => _boxes.add(box));
  _transactions.clear();
  await getAllCategories();
  Box<Account>? accountBox = await Hive.openBox(accountBoxName);
  _selectedAccount = accountBox.values
    .firstWhere((account) => account.selected);
  _changed = true;
  }
}

