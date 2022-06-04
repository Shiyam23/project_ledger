import 'package:flutter/material.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIconData.dart';
import 'package:project_ez_finance/models/Account.dart';

class NewAccountDialog {

 static Future<Account?> chooseAccount(BuildContext context, List<Account> accounts) async {
    Account? chosenAccount = await showDialog<Account>(
        context: context,
        builder: (BuildContext context) =>
            SimpleDialog(title: const Text('Select Account'), 
            children: getAccountTiles(accounts, context),
            //titlePadding: EdgeInsets.only(top:24, left: 24, right: 24,  bottom: 30),
        )
    );
    return chosenAccount;
  }

  static List<Widget> getAccountTiles(List<Account> accounts, BuildContext context) {
    return accounts.map<List<Widget>>((e) {
      CategoryIconData iconData = e.icon.iconData;
      List<Widget> widgets = 
        [Divider(thickness: 2),
          ListTile(
            title: Text(e.name),
            subtitle: const Text("updated: 04.10.2019"),
            isThreeLine: false,
            dense: true,
            leading: CategoryIcon(
              onTap: () => Navigator.pop<Account>(context, e),
              iconData: CategoryIconData(
                backgroundColorInt: 
                  iconData.backgroundColorInt ??
                  Theme.of(context).colorScheme.primary.value,
                iconColorInt: iconData.iconColorInt,
                iconName: iconData.iconName,
              ),
            ),
            onTap: () => Navigator.pop<Account>(context, e)),
        ];
        return widgets;
    }).expand((e) => e).toList();
  }
}
