import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResponseDialog extends StatelessWidget {

  ResponseDialog({
    Key? key,
    required this.description,
    required this.response
  }) : super(key: key);

  final String description;
  final Response response;
  final Color red = Color.fromRGBO(223, 79, 95, 1);
  final Color green = Color.fromRGBO(52, 190, 166, 1);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        response.name(context), 
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      content: Text(description),
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Divider(
              height: 2,
              thickness: 2,
            ),
            TextButton(onPressed: Navigator.of(context).pop, child: Text(
              MaterialLocalizations.of(context).okButtonLabel
            )),
          ],
        )
      ],
    );
  }

}

enum Response {
    Error,
    Success    
}

extension LocalizedResponse on Response {
  String name(BuildContext context) {
    switch (this) {
      case Response.Error:
        return AppLocalizations.of(context)!.response_error;
      case Response.Success:
        return AppLocalizations.of(context)!.response_success;
    }
  }
}