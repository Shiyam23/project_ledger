import 'dart:io';
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


class HiveDatabase implements Database {
  
  static final HiveDatabase _singleton = HiveDatabase._internal();

  factory HiveDatabase() {
    return _singleton;
  }
  
  HiveDatabase._internal();
  
  Account? _selectedAccount;
  final List<Account> accountList = [];
  final List<Transaction> _transactions = [];
  final Set<String> _boxes = {};
  final Set<Box?> _openBoxes = {};


  @override
  Future<List<Account>> getAllAccounts() async{
    Box? accountBox = await Hive.openBox("accounts");
    accountList.clear();
    accountBox.values.forEach((e) => accountList.add(e));
    return Future.value(accountList);
  }

  @override
  Future<List<Category>> getAllCategories() async {
    Box? catgoryBox = await Hive.openBox("categories");
    List<Category> result = [];
    catgoryBox.values.forEach((e) => result.add(e));
    return Future.value(result);
  }

  @override
  void changeAccount(Account oldAccount, Account newAccount) async {
    if (!accountList.contains(newAccount)) {
      int i = accountList.indexWhere((account) => account.name == oldAccount.name);
      accountList[i] = newAccount;
      Box? accountBox = await Hive.openBox("accounts");
      accountBox.putAt(i, newAccount);
      if (oldAccount.name != newAccount.name) {
        Box? accountBoxMap = await Hive.openBox("accountBoxMap");
        int boxName = accountBox.get(oldAccount.name);
        accountBoxMap.delete(oldAccount.name);
        accountBoxMap.put(newAccount.name, boxName);
      }
    }
  }

  @override
  Future<void> addAccount(Account newAccount) async {
    Box? accountBox = await Hive.openBox("accounts");
    if (accountBox.containsKey(newAccount.name)) {
      throw Exception("Account with this name already exists!");
    }
    accountBox.add(newAccount);
    accountList.add(newAccount);
    // Get next available number for boxname
    Box? accountBoxMap = await Hive.openBox("accountBoxMap");
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
    int i = accountList.indexWhere((account) => account.name == deletedAccount.name);
    accountList.removeAt(i);
    Box? accountBox = await Hive.openBox("accounts");
    accountBox.deleteAt(i);
    _deleteTransactionsOfAccount(deletedAccount);
    Box? accountBoxMap = await Hive.openBox("accountBoxMap");
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
    (await Hive.openBox("boxes")).values.forEach((box) => _boxes.add(box));

    // Printing box names for debugging
    _boxes.forEach(print);

    // Add a default account if the list of accounts is empty
    List<Account> accounts = await getAllAccounts();
    if (accounts.isEmpty) {
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

    // Initialize selected account
    _selectedAccount = accounts.firstWhere((account) => account.selected);

    /* Box? categoryBox = await Hive.openBox("categories");
    await categoryBox.clear();
    await categoryBox.addAll([
      Category(
        name: "Haus",
        icon: CategoryIcon(
          iconData: CategoryIconData(
            iconName: "home"
          )
        ),
      ),
      Category(
        name: "Shopping",
        icon: CategoryIcon(
          iconData: CategoryIconData(
            iconName: "shopping"
          )
        ),
      )
    ]); */
  }

  @override
  void deleteAllTransactions() async {
    _transactions.clear();
    if (_selectedAccount != null) {
      _deleteTransactionsOfAccount(_selectedAccount!);
    }
  }

  void _deleteTransactionsOfAccount(Account account) async {
    Box? accountBoxMap = await Hive.openBox("accountBoxMap");
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

  Future<Box?> _getBoxFromDate({ 
    required DateTime date,
    required Account account,
    bool createNew = false,
  }) async {
    Box? accountBoxMap = await Hive.openBox("accountBoxMap");
    String boxPrefix = accountBoxMap.get(account.name).toString();
    String currentName = "$boxPrefix" +
      "_${DateFormat.yMMM().format(date).replaceAll(" ", "").toLowerCase()}";
    if (createNew || await Hive.boxExists(currentName)) {
      print("Opening Box:" + currentName);
      Box nameBoxes = await Hive.openBox("boxes");
      if (!nameBoxes.values.contains(currentName)) nameBoxes.add(currentName);
      Box? currentBox = await Hive.openBox(currentName);
      _openBoxes.add(currentBox);
      return currentBox;
    }
    return null;
  }

  void saveTransaction(Transaction transaction) async {
    Box? currentBox = await _getBoxFromDate(
      date: transaction.date,
      account: transaction.account,
      createNew: true
      );
    if (currentBox != null) {
      currentBox.add(transaction);
      print("Saving into Box:" + currentBox.name);
      _transactions.add(transaction);
      currentBox.close();
    }
  }

  @override
  Future<List<Transaction>> getTransactions(Set<DateTime> months) async {
    List<Transaction> transactions = [];
    if (_selectedAccount != null) {
      Set<Box?> neededBoxes = (await Future.wait(
        months.map((month) => _getBoxFromDate(
          date: month,
          account: _selectedAccount!
        ))
      )).toSet();
      neededBoxes.forEach((box) {
        box?.values.forEach((t) => transactions.add(t));
        neededBoxes.add(box);
      });
      _openBoxes.difference(neededBoxes).forEach((box) {
        print("Closing " + (box?.name ?? "nothing"));
        box?.close();
        _openBoxes.remove(box);
      });
    }
    return transactions;
  }

  @override
  void selectAccount(Account selection) async {
    int oldIndex = accountList.indexWhere((account) => account.selected);
    int newIndex = accountList.indexOf(selection);
    accountList[oldIndex].selected = false;
    selection.selected = true;
    Box? accountBox = await Hive.openBox("accounts");
    accountBox.putAt(oldIndex, accountList[oldIndex]);
    accountBox.putAt(newIndex, selection);
    _selectedAccount = selection;
  }

  Account? get selectedAccount => _selectedAccount;
}