import 'dart:async';
import 'package:currency_picker/currency_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dollavu/blocs/bloc/bloc.dart';
import 'package:dollavu/components/IconSelectionSheet.dart';
import 'package:dollavu/components/dialogs/ConfirmDialog.dart';
import 'package:dollavu/components/dialogs/ResponseDialog.dart';
import 'package:dollavu/components/categoryIcon/CategoryIcon.dart';
import 'package:dollavu/components/categoryIcon/CategoryIconData.dart';
import 'package:dollavu/models/Account.dart';
import 'package:dollavu/services/Database.dart';
import 'package:dollavu/services/HiveDatabase.dart';
import '../dialogs/TextInputDialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountPage extends StatefulWidget {

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Account> _accountList = [];
  final TextEditingController _controller = TextEditingController();
  final Database _database = HiveDatabase();
  late Future<List<Account>> allAcounts;

  @override
  void initState() {
    super.initState();
    allAcounts = _database.getAllAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.accounts),
      ),
      body: FutureBuilder(
        future: allAcounts,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            _accountList.clear();
            _accountList.addAll(snapshot.data as List<Account>);
            return AnimatedList(
              initialItemCount: _accountList.length + 1,
              key: _listKey,
              itemBuilder: (context, index, animation) => 
                index < _accountList.length ? 
                _listbuilder(context, _accountList[index], animation):
                Card(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(15),
                    title: Text(
                      AppLocalizations.of(context)!.add_new_account
                    ),
                    onTap: () => addAccount(context),
                    leading: DottedBorder(
                      color: Colors.black,
                      strokeWidth: 1,
                      dashPattern: [6, 6],
                      padding: const EdgeInsets.all(1),
                      borderType: BorderType.Circle,
                      child: Icon(
                        Icons.add,
                        color: Theme.of(context).primaryColor,
                        size: 50,
                      )
                    )
                  ),
                ),
            );
          }
          else {
            return const CircularProgressIndicator();
          }
        }
      ),
    );
  }

  Widget _listbuilder(BuildContext context, Account account, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        child: StatefulBuilder(
          builder: (context, listSetState) => ListTile(
            key: ObjectKey(account),
            contentPadding: const EdgeInsets.all(10),
            title: Text(account.name),
            subtitle: Text(_getCurrencyText(account.currencyCode)),
            onLongPress: () {
              showAccountMenu(context, account, listSetState);
            },
            onTap: () => selectAccount(context, account),
            leading: account.icon,
            trailing: account.selected ? 
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(AppLocalizations.of(context)!.selected),
              ) : null,
          ),
        ),
      ),
    );
  }

  void showAccountMenu(BuildContext context, Account account, StateSetter listSetState) {
    showModalBottomSheet(context: context, builder: (sheetContext) {
      return SafeArea(
        top: false,
        right: false,
        left: false,
        child: Wrap(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
              title: Text(AppLocalizations.of(context)!.edit_name),
              leading: const Icon(Icons.edit),
              onTap: () => saveNewName(context, account)
            ),
            const Divider(
              thickness: 1,
              height: 1,
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
              title: Text(AppLocalizations.of(context)!.change_icon),
              leading: const Icon(Icons.circle),
              onTap: () => saveNewIcon(context, account)
            ),
            const Divider(
              thickness: 1,
              height: 1,
            ),
            /* Changing the currency of an existing account will break the existing 
            transactions. User should create a new account instead.

            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
              title: const Text("Change currency"),
              leading: const Icon(Icons.attach_money),
              onTap: () => saveNewCurrency(context, account)
            ),*/
            const Divider(
              thickness: 1,
              height: 1,
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
              title: Text(AppLocalizations.of(context)!.delete_account),
              leading: const Icon(Icons.delete),
              onTap: () => deleteAccount(context, account)
            ),
          ]
        ),
      );
    });    
  }

  void selectAccount(BuildContext context, Account selectedAccount) async {
    bool saved = await _database.selectAccount(selectedAccount);
    if (saved) {
      Account oldAccount = _accountList.firstWhere((account) => account.selected);
      int oldIndex = _accountList.indexOf(oldAccount);
      Account modifiedOldAccount = oldAccount.copyWith(selected: false);
      int newIndex = _accountList.indexOf(selectedAccount);
      Account modifiedSelectedAccount = selectedAccount.copyWith(selected: true);
      allAcounts = _database.getAllAccounts();
      setState(() {
        _accountList[oldIndex] = modifiedOldAccount;
        _accountList[newIndex] = modifiedSelectedAccount;
      });
    }
    context.read<AccountChangeNotifier>().notify();
  }

  void deleteAccount(BuildContext context, Account account) async {
    Navigator.of(context).pop();
    if (account.selected) {
      showDialog(
        context: context, 
        builder: (_) => ResponseDialog(
          description: AppLocalizations.of(context)!.delete_selected_account_description, 
          response: Response.Error
        )
      );
      return;
    }
    bool? sureToDelete = await showDialog<bool>(
      context: context, 
      builder: (context) => ConfirmDeleteDialog(
        title: AppLocalizations.of(context)!.delete_account_title,
        content: AppLocalizations.of(context)!.delete_account_description
      )
    );
    if (sureToDelete ?? false) {
      int index = _accountList.indexOf(account);
      _listKey.currentState!.removeItem(
        index, 
        (context, animation) => _listbuilder(context, account, animation), 
      );
      _accountList.removeAt(index);
      _database.deleteAccount(account);
      allAcounts = _database.getAllAccounts();
    }
  } 

  Future<String?> getSelectedName(BuildContext context) async {
    String? name = await showDialog<String>(
      context: context, 
      builder: (context) => TextInputDialog(
        title: Text(AppLocalizations.of(context)!.new_name),
        controller: _controller,
        prefixIcon: const Icon(Icons.edit),
        )
    );
    return Future.value(name);
  }

  void saveNewName(BuildContext context, Account oldAccount) async {
    _controller.text = oldAccount.name;
    _controller.selection = TextSelection(
      baseOffset: 0, 
      extentOffset: oldAccount.name.length
    );
    Navigator.of(context).pop();
    String? newName = await getSelectedName(context);
    if (_accountList
      .map((Account account) => account.name.toLowerCase())
      .contains(newName?.toLowerCase())) 
    {
      String errorPrefix = AppLocalizations.of(context)!.account_already_exists_prefix;
      String errorSuffix = AppLocalizations.of(context)!.account_already_exists_suffix;
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.account_already_exists_title),
          content: Text("$errorPrefix\"$newName\"$errorSuffix"),
        )
      );
      return;
    }
    else if (
      newName != null &&
      newName != oldAccount.name && 
      newName.isNotEmpty
    ){
      Account newAccount = oldAccount.copyWith(
        name: newName
      );
      _database.changeAccount(oldAccount, newAccount);
      allAcounts = _database.getAllAccounts();
      setState(() => oldAccount = newAccount);
    } 
  }

  void addAccount(BuildContext context) async {
    _controller.text = AppLocalizations.of(context)!.account_template_name;
    String? iconName;
    int? colorInt;
    String? name = await showDialog<String>(
      context: context, 
      builder: (context) => TextInputDialog(
        title: Text(AppLocalizations.of(context)!.new_name),
        controller: _controller,
        prefixIcon: const Icon(Icons.edit),
        )
    );
    if (_accountList.any((account) => account.name == name)) {
      showDialog(
        context: context, 
        builder: (_) => ResponseDialog(
          description: AppLocalizations.of(context)!.account_already_exists, 
          response: Response.Error
        )
      );
      return;      
    }
    if (name != null) {
      iconName = await showIconSheet(context, false);
      if (iconName != null) {
        colorInt = await showIconSheet(context, true);
        if (colorInt != null) {
          showCurrencyPicker(
            context: context, 
            onSelect: (currency) {
              Account newAccount = Account(
                name: name,
                currencyCode: currency.code,
                selected: false,
                icon: CategoryIcon(
                  iconData: CategoryIconData(
                    iconName: iconName,
                    backgroundColorInt: colorInt
                  )
                )
              );
              _database.addAccount(newAccount);
              allAcounts = _database.getAllAccounts();
              _accountList.add(newAccount);
              Timer(
                const Duration(milliseconds: 300),
                () => _listKey.currentState!.insertItem(_accountList.length-1));
            }
          );
        }
      }
    }
  }

  void saveNewIcon(BuildContext context, Account oldAccount) async {
    Navigator.of(context).pop();
    int? colorInt;
    String? iconName = await showIconSheet(context, false);
    if (iconName != null) {
      colorInt = await showIconSheet(context, true);
      if (colorInt != null) {
        Account newAccount = Account(
          name: oldAccount.name,
          selected: oldAccount.selected,
          currencyCode: oldAccount.currencyCode,
          icon: CategoryIcon(
              iconData: CategoryIconData(
                iconName: iconName,
                backgroundColorInt: colorInt
              ))   
        );
        _database.changeAccount(oldAccount, newAccount);
        allAcounts = _database.getAllAccounts();
        setState(() => oldAccount = newAccount);
      }
    }
  }

  void saveNewCurrency(BuildContext context, Account oldAccount) {
    Navigator.of(context).pop();
    showCurrencyPicker(
      context: context, 
      onSelect: (currency) {
        Account newAccount = oldAccount.copyWith(
          currencyCode: currency.code
        );
        _database.changeAccount(oldAccount, newAccount);
        allAcounts = _database.getAllAccounts();
        setState(() => oldAccount = newAccount);
      }
    );
  }

  String _getCurrencyText(String code) {
    String currencyPrefix = AppLocalizations.of(context)!.currency_prefix;
    return currencyPrefix + code;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

