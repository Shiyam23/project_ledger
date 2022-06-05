import 'package:flutter/material.dart';
import 'package:project_ez_finance/blocs/bloc/transactionDetails/cubit/transactiondetails_cubit.dart';
import 'package:project_ez_finance/components/IconListTile.dart';
import 'package:project_ez_finance/models/Transaction.dart';
import 'package:project_ez_finance/services/Database.dart';
import 'package:project_ez_finance/services/HiveDatabase.dart';

class NewTemplateScreen extends StatelessWidget {

  final List<Transaction> _templates = [];

  final Database _database = HiveDatabase();

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  final Future<void> Function(int) setPage;

  NewTemplateScreen(this.setPage);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _database.getTemplates(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _templates.clear();
          _templates.addAll(snapshot.data as List<Transaction>);
          return AnimatedList(
            key: _listKey,
            initialItemCount: _templates.length,
            itemBuilder: (context, index, animation) 
              => _listBuilder(context, _templates[index], animation)
          );
        }
        else return const Center(child: const CircularProgressIndicator());
      }
    );
  }

  Widget _listBuilder (BuildContext context, Transaction template, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: IconListTile(
          selectable: false,
          onSelect: () => showAccountMenu(context, template),
          onTap: () async {
            TransactionDetails details = TransactionDetails(
              account: template.account,
              amount: template.amount,
              category: template.category,
              date: template.date,
              name: template.name,
              repetition: template.repetition,
              isExpense: template.isExpense,
            );
            var cubit = TransactionDetailsCubit.of(context);
            await this.setPage(2);
            cubit.projectDetails(details);
          },
          tile: template,
        )
      ),
    );
  }

  void showAccountMenu(BuildContext context, Transaction template) {
    showModalBottomSheet(context: context, builder: (sheetContext) {
      return SafeArea(
        bottom: true,
        left: false,
        top: false,
        right: false,
        child: Wrap(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
              title: const Text("Delete template"),
              leading: const Icon(Icons.delete),
              onTap: () => deleteTemplate(context, template)
            ),
          ]
        ),
      );
    });    
  }

  void deleteTemplate(BuildContext context, Transaction template) async {
      Navigator.of(context).pop();
      bool? sureToDelete = await showDialog<bool>(
        context: context, 
        builder: (context) => AlertDialog(
          title: const Text("Delete template?"),
          content: const Text("Are you sure that you want to delete this template?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel")
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Delete")
            ),
          ],
        ));
      if (sureToDelete ?? false) {
        bool noError = await _database.deleteTemplate(template);
        if (noError) {
          int index = _templates.indexOf(template);
          _listKey.currentState!.removeItem(
            index, 
            (context, animation) => _listBuilder(context, template, animation)
          );
          _templates.removeAt(index);
        } else {
          print("Error occurred while deleting Template");
          //TODO: show proper error message
        }
      }
    } 
}
