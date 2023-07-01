import 'package:flutter/material.dart';
import 'package:dollavu/components/dialogs/DollavuDialog.dart';
import 'package:dollavu/models/Modes.dart' show ViewMode;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
      title: Text(AppLocalizations.of(context)!.view_mode),
      onPressedSave: () => Navigator.pop(context, _option),
      onPressedCancel: () => Navigator.pop(context),
      child: Column(
        children: <Widget>[
          RadioListTile(
            title: Text(AppLocalizations.of(context)!.viewmode_list),
            value: ViewMode.List,
            groupValue: _option,
            onChanged: (dynamic option) {
              setState(() {
                _option = option;
              });
            },
          ),
          RadioListTile(
            title: Text(AppLocalizations.of(context)!.viewmode_graph),
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
