import 'package:currency_picker/currency_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIconData.dart';
import 'package:project_ez_finance/models/Account.dart';
import 'package:project_ez_finance/services/Database.dart';
import 'package:project_ez_finance/services/HiveDatabase.dart';
import '../TextInputDialog.dart';

class AccountPage extends StatefulWidget {

  AccountPage({Key? key}) : super(key: key);  

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  final List<Account> _accountList = [];
  final TextEditingController _controller = TextEditingController();
  final Database _database = HiveDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accounts"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _controller.dispose();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder(
        future: (HiveDatabase()).getAllAccounts(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            _accountList.clear();
            _accountList.addAll(snapshot.data as List<Account>);
            return ListView.builder(
              key: ValueKey(_accountList.length),
              itemBuilder: (_, i) {
                if (i < _accountList.length) {
                  return Card(
                    child: StatefulBuilder(
                      builder: (context, listSetState) => ListTile(
                        key: ObjectKey(_accountList[i]),
                        contentPadding: EdgeInsets.all(10),
                        title: Text(_accountList[i].name),
                        subtitle: Text(_getCurrencyText(_accountList[i].currencyCode)),
                        onLongPress: () {
                          showAccountMenu(context, _accountList[i], listSetState);
                        },
                        onTap: () => selectAccount(context, _accountList[i]),
                        leading: _accountList[i].icon,
                        trailing: _accountList[i].selected ? 
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Text("Selected"),
                          ) : null,
                      ),
                    ),
                  );
                }
                else {
                  return Card(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(15),
                      title: Text("Add new account"),
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
                        ))
                    ),
                  );
                }
              },
              itemCount: _accountList.length + 1,
            );
          }
          else {
            return CircularProgressIndicator();
          }
        }
      ),
    );
  }

  bool showAccountMenu(BuildContext context, Account account, StateSetter listSetState) {
    showModalBottomSheet(context: context, builder: (sheetContext) {
      return Wrap(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 16),
            title: const Text("Edit name"),
            leading: Icon(Icons.edit),
            onTap: () => saveNewName(context, account, listSetState)
          ),
          const Divider(
            thickness: 1,
            height: 1,
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 16),
            title: Text("Change Icon"),
            leading: Icon(Icons.circle),
            onTap: () => saveNewIcon(context, account, listSetState)
          ),
          const Divider(
            thickness: 1,
            height: 1,
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 16),
            title: Text("Change currency"),
            leading: Icon(Icons.attach_money),
            onTap: () => saveNewCurrency(context, account, listSetState)
          ),
          const Divider(
            thickness: 1,
            height: 1,
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 16),
            title: Text("Delete account"),
            leading: Icon(Icons.delete),
            onTap: () => deleteAccount(context, account)
          ),
        ]
      );
    });    
    return true;
  }

  void selectAccount(BuildContext context, Account selectedAccount) {
    _database.selectAccount(selectedAccount);
    setState(() {});
  }

  void deleteAccount(BuildContext context, Account account) async {
    Navigator.of(context).pop();
    if (account.selected) {
      // TODO: show proper error message
      return;
    }
    bool? sureToDelete = await showDialog<bool>(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text("Delete account?"),
        content: Text("Are you sure that you want to delete this account? " + 
        "All transactions associated with this account will be deleted permanently!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Cancel")
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Delete")
          ),
        ],
      ));
    if (sureToDelete ?? false) {
      _database.deleteAccount(account);
      setState(() => _accountList.remove(account));};
  } 

  Future<String?> getSelectedName(BuildContext context) async{
    String? name = await showDialog<String>(
      context: context, 
      builder: (context) => TextInputDialog(
        title: const Text("Enter a name"),
        controller: _controller,
        prefixIcon: Icon(Icons.edit),
        )
    );
    return Future.value(name);
  }

  void saveNewName(BuildContext context, Account oldAccount, StateSetter listSetState) async {
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
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Text("Account with this name already exists"),
          content: Text("You already have an account with the name \"$newName\"." + 
            "You can not have two accounts with the same name."),
        )
      );
      return;
    }
    if (
      newName != null &&
      newName != oldAccount.name &&
      !_accountList
      .map((Account account) => account.name.toLowerCase())
      .contains(newName.toLowerCase())
    ){
      Account newAccount = Account(
      name: newName,
      currencyCode: oldAccount.currencyCode,
      selected: oldAccount.selected,
      icon: oldAccount.icon,
      );
      _database.changeAccount(oldAccount, newAccount);
      listSetState(() => oldAccount.name = newAccount.name);
    } 
  }

  void addAccount(BuildContext context) async {
    _controller.text = "My Account";
    String? iconName;
    int? colorInt;
    String? name = await showDialog<String>(
      context: context, 
      builder: (context) => TextInputDialog(
        title: const Text("Enter a name"),
        controller: _controller,
        prefixIcon: const Icon(Icons.edit),
        )
    );
    if (_accountList.contains((account) => account.name == name)) {
      // TODO: show proper error message
      return;      
    }
    if (name != null) {
      iconName = await _showIconSheet(context, false);
      if (iconName != null) {
        colorInt = await _showIconSheet(context, true);
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
                  ))   
              );
              _database.addAccount(newAccount);
              setState(() => _accountList.add(newAccount));
            }
          );
        }
      }
    }
  }

  void saveNewIcon(BuildContext context, Account oldAccount, StateSetter listSetState) async {
    Navigator.of(context).pop();
    int? colorInt;
    String? iconName = await _showIconSheet(context, false);
    if (iconName != null) {
      colorInt = await _showIconSheet(context, true);
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
        listSetState(() => oldAccount.icon = newAccount.icon);
      }
    }
  }

  void saveNewCurrency(BuildContext context, Account oldAccount, StateSetter listSetState) {
    Navigator.of(context).pop();
    showCurrencyPicker(
      context: context, 
      onSelect: (currency) {
        Account newAccount = Account(
          name: oldAccount.name,
          selected: oldAccount.selected,
          currencyCode: currency.code,
          icon: oldAccount.icon
        );
        _database.changeAccount(oldAccount, newAccount);
        listSetState(() => oldAccount.currencyCode = newAccount.currencyCode);
      }
    );
  }

  Future<dynamic> _showIconSheet(BuildContext context, bool showOnlyColor) async {
    dynamic result = await showModalBottomSheet<dynamic>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      enableDrag: true,
      isDismissible: true,
      context: context, 
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                showOnlyColor ? "Select background color" : "Select icon",
                style: TextStyle(
                  fontSize: 20
                ),
              ),
            ),
            Divider(),
            Scrollbar(
              radius: Radius.circular(20),
              thickness: 20,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(top: 10),
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      runAlignment: WrapAlignment.spaceEvenly,
                      alignment: WrapAlignment.start,
                      spacing: 20,
                      runSpacing: 20,
                      children: _getSheetElementList(context, showOnlyColor)
                    ),
                  ),
                )
              ),
            ),
          ],
        );
      });
      return Future.value(result);
  }

  List<Widget> _getSheetElementList(context, bool showOnlyColor) {
    return showOnlyColor ?
    CategoryIconData.colorList.map((colorInt) => CategoryIcon(
        onTap: () => Navigator.of(context).pop(colorInt),
        iconData: CategoryIconData(
          backgroundColorInt: colorInt
    ))).toList() :
    CategoryIconData.iconList.keys.map((name) => CategoryIcon(
        onTap: () => Navigator.of(context).pop(name),
        iconData: CategoryIconData(
          iconName: name,
    ))).toList(); 
  }

  String _getCurrencyText(String code) {
    return "Currency: $code";
  }


}

