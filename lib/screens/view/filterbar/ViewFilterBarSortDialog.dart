import 'package:flutter/material.dart';
import 'package:project_ez_finance/components/dialogs/DollavuDialog.dart';
import 'package:project_ez_finance/models/Modes.dart' show SortMode;

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
      title: Text("View Mode"),
      onPressedSave: () => Navigator.pop(context, _option),
      onPressedCancel: () => Navigator.pop(context),
      child: Column(
        children: <Widget>[
          RadioListTile(
            title: Text("Date descending"),
            value: SortMode.DateDesc,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text("Date ascending"),
            value: SortMode.DateAsc,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text("Amount descending"),
            value: SortMode.AmountDesc,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text("Amount ascending"),
            value: SortMode.AmountAsc,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text("Name descending"),
            value: SortMode.NameDesc,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text("Name ascending"),
            value: SortMode.NameAsc,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text("Category descending"),
            value: SortMode.CategoryDesc,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text("Category ascending"),
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
