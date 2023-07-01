import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dollavu/blocs/bloc/bloc.dart';
import 'package:dollavu/components/dialogs/LoadingDialog.dart';
import 'package:dollavu/services/Backup.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            return PopUpMenuButtonChoices.choices(context).map((String choice) {
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
    if (choice == PopUpMenuButtonChoices.accounts(rootContext)) {
      Navigator.of(rootContext).pushNamed("account");
    }
    if (choice == PopUpMenuButtonChoices.categories(rootContext)) {
      Navigator.of(rootContext).pushNamed("category");
    }
    if (choice == PopUpMenuButtonChoices.backup(rootContext)) {
      showModalBottomSheet(context: rootContext, builder: (context) => 
        SafeArea(
          child: Wrap(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                title: Text(AppLocalizations.of(context)!.create_backup),
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
                title: Text(AppLocalizations.of(context)!.import_backup),
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
        title: AppLocalizations.of(context)!.creating_backup);
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
        title: AppLocalizations.of(context)!.importing_backup);
      }
    );
    List<File>? backupFiles = await checksum(backupFilePath, progress);
    if (backupFiles == null) {
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.backup_corrupted), 
          content: Text(AppLocalizations.of(context)!.backup_corrupted_description),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: Text(MaterialLocalizations.of(context).okButtonLabel)
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
  static String accounts(BuildContext context) => AppLocalizations.of(context)!.account;
  static String categories(BuildContext context) => AppLocalizations.of(context)!.categories;
  static String backup(BuildContext context) => AppLocalizations.of(context)!.backup;

  static List<String> choices(BuildContext context) => <String>[
    accounts(context),
    categories(context),
    backup(context),
  ];
}
