import 'package:flutter/material.dart';
import 'package:dollavu/blocs/bloc/transactionDetails/cubit/transactiondetails_cubit.dart';
import 'package:dollavu/components/EmptyNotification.dart';
import 'package:dollavu/components/IconListTile.dart';
import 'package:dollavu/components/dialogs/ConfirmDialog.dart';
import 'package:dollavu/models/Transaction.dart';
import 'package:dollavu/services/Database.dart';
import 'package:dollavu/services/HiveDatabase.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../components/dialogs/ResponseDialog.dart';

class NewTemplateScreen extends StatefulWidget {
  final Future<void> Function(int) setPage;

  NewTemplateScreen(this.setPage);

  @override
  State<NewTemplateScreen> createState() => _NewTemplateScreenState();
}

class _NewTemplateScreenState extends State<NewTemplateScreen> {
  final List<Transaction> _templates = [];

  final Database _database = HiveDatabase();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late Future<List<Transaction>> allTemplates;

  @override
  void initState() {
    super.initState();
    allTemplates = _database.getTemplates();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: allTemplates,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _templates.clear();
          _templates.addAll(snapshot.data as List<Transaction>);
          if (_templates.isEmpty) return _templatesEmptyNotification();
          return AnimatedList(
            key: _listKey,
            initialItemCount: _templates.length,
            itemBuilder: (context, index, animation) =>
                _listBuilder(context, _templates[index], animation),
          );
        } else {
          return const Center(
            child: const CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _listBuilder(
    BuildContext context,
    Transaction template,
    Animation<double> animation,
  ) {
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
            await this.widget.setPage(2);
            cubit.projectDetails(details);
          },
          tile: template,
        ),
      ),
    );
  }

  void showAccountMenu(BuildContext context, Transaction template) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          bottom: true,
          left: false,
          top: false,
          right: false,
          child: Wrap(children: [
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
              title: Text(AppLocalizations.of(context)!.delete_template),
              leading: const Icon(Icons.delete),
              onTap: () => deleteTemplate(context, template),
            ),
          ]),
        );
      },
    );
  }

  void deleteTemplate(BuildContext context, Transaction template) async {
    Navigator.of(context).pop();
    bool? sureToDelete = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDeleteDialog(
        title: "Delete template?",
        content: "Are you sure that you want to delete this template?",
      ),
    );
    if (sureToDelete ?? false) {
      bool noError = await _database.deleteTemplate(template);
      if (noError) {
        allTemplates = _database.getTemplates();
        int index = _templates.indexOf(template);
        _listKey.currentState!.removeItem(index,
            (context, animation) => _listBuilder(context, template, animation));
        _templates.removeAt(index);
        if (_templates.isEmpty) setState(() {});
      } else {
        showDialog(
          context: context,
          builder: (_) => ResponseDialog(
            description:
                AppLocalizations.of(context)!.delete_template_error_description,
            response: Response.Error,
          ),
        );
      }
    }
  }

  Widget _templatesEmptyNotification() {
    return Center(
      child: EmptyNotification(
        title: AppLocalizations.of(context)!.no_templates_available,
        information:
            AppLocalizations.of(context)!.no_templates_available_description,
      ),
    );
  }
}
