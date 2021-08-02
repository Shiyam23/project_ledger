import 'package:flutter/material.dart';
import 'package:project_ez_finance/components/DollavuDialog.dart';

enum ViewFilterBarTimeOptions {
  individual,
  days,
  weeks,
  months,
  years,
  decades,
  all,
}

class ViewFilterBarTimeDialog extends StatefulWidget {
  ViewFilterBarTimeDialog({
    Key? key,
    this.initialOption = ViewFilterBarTimeOptions.individual,
  }) : super(key: key);

  final ViewFilterBarTimeOptions? initialOption;

  _ViewFilterBarTimeDialogState createState() =>
      _ViewFilterBarTimeDialogState();
}

class _ViewFilterBarTimeDialogState extends State<ViewFilterBarTimeDialog> {
  ViewFilterBarTimeOptions? _option;

  @override
  void initState() {
    super.initState();
    _option = widget.initialOption;
  }

  @override
  Widget build(BuildContext context) {
    return DollavuDialog(
      title: Text("Time Mode"),
      onPressedSave: () => Navigator.pop(context, _option),
      onPressedCancel: () => Navigator.pop(context),
      child: Column(
        children: <Widget>[
          RadioListTile(
            title: Text("Individual"),
            value: ViewFilterBarTimeOptions.individual,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text("Days"),
            value: ViewFilterBarTimeOptions.days,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text("Weeks"),
            value: ViewFilterBarTimeOptions.weeks,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text("Months"),
            value: ViewFilterBarTimeOptions.months,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text("Years"),
            value: ViewFilterBarTimeOptions.years,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text("Decades"),
            value: ViewFilterBarTimeOptions.decades,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text("All"),
            value: ViewFilterBarTimeOptions.all,
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
