import 'package:flutter/material.dart';
import 'package:project_ez_finance/components/DollavuDialog.dart';

enum ViewFilterBarSortOptions {
  dateDown,
  dateUp,
  amountDown,
  amountUp,
  nameDown,
  nameUp,
  categoryDown,
  categoryUp,
}

class ViewFilterBarSortDialog extends StatefulWidget {
  ViewFilterBarSortDialog({
    Key? key,
    this.initialOption = ViewFilterBarSortOptions.dateUp,
  }) : super(key: key);

  final ViewFilterBarSortOptions? initialOption;

  _ViewFilterBarSortDialogState createState() =>
      _ViewFilterBarSortDialogState();
}

class _ViewFilterBarSortDialogState extends State<ViewFilterBarSortDialog> {
  ViewFilterBarSortOptions? _option;

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
            value: ViewFilterBarSortOptions.dateDown,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text("Date ascending"),
            value: ViewFilterBarSortOptions.dateUp,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text("Amount descending"),
            value: ViewFilterBarSortOptions.amountDown,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text("Amount ascending"),
            value: ViewFilterBarSortOptions.amountUp,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text("Name descending"),
            value: ViewFilterBarSortOptions.nameDown,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text("Name ascending"),
            value: ViewFilterBarSortOptions.nameUp,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text("Category descending"),
            value: ViewFilterBarSortOptions.categoryDown,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text("Category ascending"),
            value: ViewFilterBarSortOptions.categoryUp,
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
