import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_ez_finance/blocs/bloc/bloc.dart';
import 'package:project_ez_finance/components/LoadingDialog.dart';
import 'package:project_ez_finance/services/Backup.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {

  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final titleDollavuText = new Text(
      "Dollavu",
      style: new TextStyle(fontFamily: "Pacifico", fontSize: 28.0),
    );

    return AppBar(
      titleSpacing: 20, 
      title: titleDollavuText,
      centerTitle: true, 
      actions: [
        PopupMenuButton<String>(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onSelected: (choice) =>  choiceAction(choice, context),
          itemBuilder: (BuildContext context) {
            return PopUpMenuButtonChoices.choices.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ]
    );
  }

  choiceAction(String choice, BuildContext rootContext) {
    if (choice == PopUpMenuButtonChoices.Accounts) {
      Navigator.of(rootContext).pushNamed("account");
    }
    if (choice == PopUpMenuButtonChoices.Categories) {
      Navigator.of(rootContext).pushNamed("category");
    }
    if (choice == PopUpMenuButtonChoices.Backup) {
      showModalBottomSheet(context: rootContext, builder: (context) => 
        SafeArea(
          child: Wrap(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                title: const Text("Create Backup"),
                leading: const Icon(Icons.arrow_upward),
                onTap: () {
                  Navigator.pop(context);
                  _createBackup(rootContext);
                },
              ),
              const Divider(
                thickness: 1,
                height: 1,
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                title: const Text("Import Backup"),
                leading: const Icon(Icons.arrow_downward),
                onTap: () {
                  Navigator.pop(context);
                  _importBackup(rootContext);
                }
              ),
            ],
          ),
        )
      );
      //createBackup();
    }
  }

  @override
  Size get preferredSize => AppBar().preferredSize;

  void _createBackup(BuildContext context) async {
    LoadingProgress progress = LoadingProgress();
    showDialog(
      barrierDismissible: false,
      context: context, 
      builder: (context) { 
        return LoadingDialog(
        loadingProgress: progress, 
        title: "Creating Backup");
      }
    );
    createBackup(progress);
  }

  void _importBackup(BuildContext context) async {
    LoadingProgress progress = LoadingProgress();
    String? backupFilePath = await openFile(progress);
    if (backupFilePath == null) return;
    showDialog(
      barrierDismissible: false,
      context: context, 
      builder: (context) { 
        return LoadingDialog(
        loadingProgress: progress, 
        title: "Creating Backup");
      }
    );
    List<File>? backupFiles = await checksum(backupFilePath, progress);
    if (backupFiles == null) {
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Text("Backup File corrupted"), 
          content: Text("The Backup File you chose is corrupted. Please choose" + 
            " another backup file."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: Text("OK")
            )
          ],
        )
      );
      return;
    }
    await copyBackupFiles(progress, backupFiles);
    
    context.read<AccountChangeNotifier>().notify();
  }
}

class PopUpMenuButtonChoices {
  static const String Accounts = 'Konten';
  static const String Categories = 'Kategorien';
  static const String Backup = 'Backup';

  static const List<String> choices = <String>[
    Accounts,
    Categories,
    Backup,
  ];
}
