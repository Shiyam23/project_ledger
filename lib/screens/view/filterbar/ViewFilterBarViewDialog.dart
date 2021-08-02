import 'package:flutter/material.dart';
import 'package:project_ez_finance/components/DollavuDialog.dart';

enum ViewFilterBarViewOptions {
  list,
  graph,
}

class ViewFilterBarViewDialog extends StatefulWidget {
  ViewFilterBarViewDialog({
    Key? key,
    this.initialOption = ViewFilterBarViewOptions.list,
  }) : super(key: key);

  final ViewFilterBarViewOptions? initialOption;

  _ViewFilterBarViewDialogState createState() =>
      _ViewFilterBarViewDialogState();
}

class _ViewFilterBarViewDialogState extends State<ViewFilterBarViewDialog> {
  ViewFilterBarViewOptions? _option;

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
            value: ViewFilterBarViewOptions.list,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text("Graph"),
            value: ViewFilterBarViewOptions.graph,
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
