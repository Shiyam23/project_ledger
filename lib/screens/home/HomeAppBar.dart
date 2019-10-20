import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    final titleDollavuText = new Text(
      "Dollavu",
      style: new TextStyle(fontFamily: "Pacifico", fontSize: 28.0),
    );

    return AppBar(titleSpacing: 20, title: titleDollavuText, actions: [
      PopupMenuButton<String>(
        onSelected: choiceAction,
        itemBuilder: (BuildContext context) {
          return PopUpMenuButtonChoices.choices.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList();
        },
      ),
    ]);
  }

  choiceAction(String choice) {
    if (choice == PopUpMenuButtonChoices.Accounts) {
      print('This Konten Page is to do.');
    }
    if (choice == PopUpMenuButtonChoices.Categories) {
      print('This Kategorien Page is to do.');
    }
    if (choice == PopUpMenuButtonChoices.Backup) {
      print('This Backup Page is to do.');
    }
    if (choice == PopUpMenuButtonChoices.Setting) {
      print('This Einstellung Page is to do.');
    }
    if (choice == PopUpMenuButtonChoices.RateUs) {
      print('This BewerteUns? Page is to do.');
    }
    if (choice == PopUpMenuButtonChoices.AboutUs) {
      print('This Über Page is to do.');
    }
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}

class PopUpMenuButtonChoices {
  static const String Accounts = 'Konten';
  static const String Categories = 'Kategorien';
  static const String Backup = 'Backup';
  static const String Setting = 'Einstellungen';
  static const String RateUs = 'Bewerte Uns?';
  static const String AboutUs = 'Über';

  static const List<String> choices = <String>[
    Accounts,
    Categories,
    Backup,
    Setting,
    RateUs,
    AboutUs
  ];
}
