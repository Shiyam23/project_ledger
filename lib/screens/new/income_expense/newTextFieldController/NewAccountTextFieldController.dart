import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_ez_finance/components/CategoryIcon.dart';
import 'package:project_ez_finance/models/Account.dart';

class NewAccountTextFieldController extends TextEditingController {
  NewAccountTextFieldController() : super(text: "Privatkonto");

  Future<Account> chooseAccount(BuildContext context) async {
    Account chosenAccount = await showDialog<Account>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Wähle Konto aus'),
            children: <Widget>[
              ListTile(
                leading: CategoryIcon(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  icon: FontAwesomeIcons.home,
                  iconColor: Colors.white,
                ),
                onTap: () {
                  Navigator.pop(context, Account(name: "Privatkonto"));
                },
                title: const Text('Privatkonto'),
                subtitle: const Text("aktualisiert: 04.10.2019"),
                trailing: Text("235,00€"),
                isThreeLine: false,
                dense: true,
              ),
              Divider(),
              ListTile(
                leading: CategoryIcon(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  icon: FontAwesomeIcons.suitcaseRolling,
                  iconColor: Colors.white,
                ),
                onTap: () {
                  Navigator.pop(context, Account(name: "Geschäftskonto"));
                },
                title: const Text('Geschäftskonto'),
                subtitle: const Text("aktualisiert: 04.10.2019 assdad"),
                isThreeLine: false,
                dense: true,
              ),
            ],
          );
        });

    return chosenAccount;
  }
}
