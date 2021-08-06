import 'package:flutter/material.dart';
import 'package:project_ez_finance/components/DollavuDialog.dart';
import 'package:project_ez_finance/models/Modes.dart' show ViewMode;

class ViewFilterBarViewDialog extends StatefulWidget {
  ViewFilterBarViewDialog({
    Key? key,
    this.initialOption = ViewMode.List,
  }) : super(key: key);

  final ViewMode? initialOption;

  _ViewFilterBarViewDialogState createState() =>
      _ViewFilterBarViewDialogState();
}

class _ViewFilterBarViewDialogState extends State<ViewFilterBarViewDialog> {
  ViewMode? _option;

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
            title: Text("List"),
            value: ViewMode.List,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text("Graph"),
            value: ViewMode.Graph,
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
