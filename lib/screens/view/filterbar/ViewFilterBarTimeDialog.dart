import 'package:flutter/material.dart';
import 'package:project_ez_finance/components/DollavuDialog.dart';
import 'package:project_ez_finance/models/Modes.dart' show TimeMode;

class ViewFilterBarTimeDialog extends StatefulWidget {
  ViewFilterBarTimeDialog({
    Key? key,
    this.initialOption = TimeMode.Individual,
  }) : super(key: key);

  final TimeMode? initialOption;

  _ViewFilterBarTimeDialogState createState() =>
      _ViewFilterBarTimeDialogState();
}

class _ViewFilterBarTimeDialogState extends State<ViewFilterBarTimeDialog> {
  TimeMode? _option;

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
            value: TimeMode.Individual,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text("Days"),
            value: TimeMode.Days,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text("Weeks"),
            value: TimeMode.Weeks,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text("Months"),
            value: TimeMode.Months,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text("Years"),
            value: TimeMode.Years,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text("All"),
            value: TimeMode.Overall,
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
