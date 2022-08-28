import 'package:flutter/material.dart';
import 'package:project_ez_finance/components/dialogs/DollavuDialog.dart';
import 'package:project_ez_finance/models/Modes.dart' show SortMode;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ViewFilterBarSortDialog extends StatefulWidget {
  ViewFilterBarSortDialog({
    Key? key,
    this.initialOption = SortMode.DateAsc,
  }) : super(key: key);

  final SortMode? initialOption;

  _ViewFilterBarSortDialogState createState() =>
      _ViewFilterBarSortDialogState();
}

class _ViewFilterBarSortDialogState extends State<ViewFilterBarSortDialog> {
  SortMode? _option;

  @override
  void initState() {
    super.initState();
    _option = widget.initialOption;
  }

  @override
  Widget build(BuildContext context) {
    return DollavuDialog(
      title: Text(AppLocalizations.of(context)!.sort),
      onPressedSave: () => Navigator.pop(context, _option),
      onPressedCancel: () => Navigator.pop(context),
      child: Column(
        children: <Widget>[
          RadioListTile(
            title: Text(AppLocalizations.of(context)!.sort_date_desc),
            value: SortMode.DateDesc,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text(AppLocalizations.of(context)!.sort_date_asc),
            value: SortMode.DateAsc,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text(AppLocalizations.of(context)!.sort_amount_desc),
            value: SortMode.AmountDesc,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text(AppLocalizations.of(context)!.sort_amount_asc),
            value: SortMode.AmountAsc,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text(AppLocalizations.of(context)!.sort_name_desc),
            value: SortMode.NameDesc,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text(AppLocalizations.of(context)!.sort_name_asc),
            value: SortMode.NameAsc,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text(AppLocalizations.of(context)!.sort_category_desc),
            value: SortMode.CategoryDesc,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text(AppLocalizations.of(context)!.sort_category_asc),
            value: SortMode.CategoryAsc,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
        ],
      ),
    );
  }
}
