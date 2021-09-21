import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:project_ez_finance/models/Repetition.dart';
import 'package:project_ez_finance/screens/new/income_expense/newTextFieldController/NewDateTextFieldController.dart';
import '../NewTextField.dart';

class NewRepetitionDialog {

  Repetition initialRepetition = Repetition.none;

  NewRepetitionDialog({
    required this.initialRepetition
  });

  Future<Repetition?> chooseRepetition(BuildContext contextS) async {

    CalenderUnit? _selectedUnit = initialRepetition.time ?? CalenderUnit.dayly;
    DateTime _selectedEndDate = DateTime.now().add(Duration(days: 30));
    bool? isEnabled = initialRepetition != Repetition.none;

    NewDateTextFieldController dateController = NewDateTextFieldController(
        initialValue: initialRepetition.endDate ?? _selectedEndDate,
        startValue: DateTime.now().add(Duration(days: 1)),
        endValue: DateTime.now().add(Duration(days: 365 * 30)));

    int? _selectedAmount = initialRepetition.amount ?? 1;
    bool endDateEnabled = initialRepetition.endDate != null;

    Repetition? rep = await showDialog<Repetition>(
        context: contextS,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (context, StateSetter setDialogState) {
            return SimpleDialog(
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
              title: Text("Select Repetition"),
              children: <Widget>[
                Divider(
                    color: Theme.of(context).colorScheme.primary, thickness: 2),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: DropdownButtonFormField(
                              isDense: true,
                              isExpanded: true,
                              value: isEnabled,
                              onChanged: (dynamic enabled) =>
                                  setDialogState(() => isEnabled = enabled),
                              items: [
                                DropdownMenuItem(
                                  child: Center(child: Text("Never")),
                                  value: false,
                                ),
                                DropdownMenuItem(
                                  child: Center(child: Text("Every")),
                                  value: true,
                                ),
                              ],
                            )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: TextFormField(
                            enabled: isEnabled,
                            onChanged: (string) =>
                                _selectedAmount = int.tryParse(string),
                            initialValue: _selectedAmount.toString(),
                            decoration: InputDecoration(
                              counterText: "",
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            maxLength: 2,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: StatefulBuilder(builder:
                                (context, StateSetter setDropDownState) {
                              return DropdownButtonFormField(
                                value: _selectedUnit,
                                isDense: true,
                                isExpanded: true,
                                onChanged: (dynamic unit) => setDropDownState(
                                    () => _selectedUnit = unit),
                                decoration:
                                    InputDecoration(enabled: isEnabled!),
                                items: !isEnabled!
                                    ? null
                                    : [
                                        DropdownMenuItem(
                                          child: Text("Day(s)"),
                                          value: CalenderUnit.dayly,
                                        ),
                                        DropdownMenuItem(
                                          child: Text("Month(s)"),
                                          value: CalenderUnit.monthly,
                                        ),
                                        DropdownMenuItem(
                                          child: Text("Year(s)"),
                                          value: CalenderUnit.yearly,
                                        ),
                                      ],
                              );
                            }))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  // width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: StatefulBuilder(
                      builder: (context, StateSetter setRowState) {
                    return Row(
                      children: <Widget>[
                        Checkbox(
                          activeColor: Theme.of(context).colorScheme.primary,
                          onChanged: !isEnabled!
                              ? null
                              : (_) => setRowState(
                                  () => endDateEnabled = !endDateEnabled),
                          value: endDateEnabled,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: null/* TextField(
                            
                            enabled: isEnabled! && endDateEnabled,
                            labelText: "End date",
                            fontSize: 17,
                            onTap: () async {
                              DateTime? temp = await ((dateController)
                                  .selectDate(context) as Future<DateTime?>);
                              if (temp != null) {
                                setRowState(() => dateController.text =
                                    DateFormat("dd.MM.yyyy")
                                        .format(temp)
                                        .toString());
                                _selectedEndDate = temp;
                              }
                            }
                          ), */
                        )
                      ],
                    );
                  }),
                ),
                ButtonBar(
                  children: <Widget>[
                    TextButton(
                      child: Text(
                        "CANCEL",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: Text(
                        "OK",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      onPressed: () {
                        if ((_selectedAmount == null || _selectedAmount == 0) &&
                            isEnabled!) {
                          showError(contextS);
                        } else
                          Navigator.pop(
                              context,
                              isEnabled!
                                  ? Repetition(
                                      amount: _selectedAmount,
                                      time: _selectedUnit,
                                      endDate: endDateEnabled
                                          ? _selectedEndDate
                                          : null)
                                  : Repetition.none);
                      },
                    ),
                  ],
                )
              ],
            );
          });
        });
    return rep;
  }

  Future showError(context) {
    return Flushbar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      icon: Icon(
        Icons.warning,
        size: 28.0,
        color: Colors.red[300],
      ),
      leftBarIndicatorColor: Colors.red[300],
      duration: const Duration(seconds: 3),
      title: 'Ungültige Eingabe!',
      message: 'Anzahl darf nicht leer oder Null sein.',
    ).show(context);
  }
}
