import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_ez_finance/components/dialogs/ResponseDialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:project_ez_finance/models/Repetition.dart';
import 'package:project_ez_finance/services/DateTimeFormatter.dart';

import '../NewTextField.dart';

class NewRepetitionDialog {

  final Repetition initialRepetition;

  NewRepetitionDialog({
    this.initialRepetition = Repetition.none
  });

  Future<Repetition?> chooseRepetition(BuildContext contextS) async {

    CalenderUnit? _selectedUnit = initialRepetition.time ?? CalenderUnit.daily;
    DateTime _selectedEndDate = initialRepetition.endDate ?? DateTime.now().add(Duration(days: 30));
    bool? isEnabled = initialRepetition != Repetition.none;

    int? _selectedAmount = initialRepetition.amount ?? 1;
    bool endDateEnabled = initialRepetition.endDate != null;

    Repetition? rep = await showDialog<Repetition>(
        context: contextS,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (context, StateSetter setDialogState) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              title: Text(AppLocalizations.of(context)!.selectRepetition),
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                child: Center(child: Text(
                                  AppLocalizations.of(context)!.never
                                )),
                                value: false,
                              ),
                              DropdownMenuItem(
                                child: Center(child: Text(
                                  AppLocalizations.of(context)!.every
                                )),
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
                          style: TextStyle(
                            color: isEnabled! ? Theme.of(context).colorScheme.primary : Colors.black26
                          ),
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
                                        child: Text(
                                          AppLocalizations.of(context)!.day_s
                                        ),
                                        value: CalenderUnit.daily,
                                      ),
                                      DropdownMenuItem(
                                        child: Text(
                                          AppLocalizations.of(context)!.month_s
                                        ),
                                        value: CalenderUnit.monthly,
                                      ),
                                      DropdownMenuItem(
                                        child: Text(
                                          AppLocalizations.of(context)!.year_s
                                        ),
                                        value: CalenderUnit.yearly,
                                      ),
                                    ],
                            );
                          }))
                    ],
                  ),
                ),
                SizedBox(
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
                          child: NewRepetitionDateField(
                            enabled: endDateEnabled && isEnabled!,
                            content: _selectedEndDate.format(),
                            onTap: () async {
                              DateTime? temp = await showDatePicker(
                                context: context, 
                                initialDate: _selectedEndDate,
                                firstDate: _selectedEndDate,
                                lastDate: _selectedEndDate.add(Duration(days: 365))
                              );
                              if (temp != null) {
                                setRowState(() => _selectedEndDate = temp);
                              }
                            }
                          )
                        )
                      ],
                    );
                  }),
                ),
                ButtonBar(
                  children: <Widget>[
                    TextButton(
                      child: Text(
                        MaterialLocalizations.of(context).cancelButtonLabel,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: Text(
                        MaterialLocalizations.of(context).okButtonLabel,
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

  void showError(context) {
    showDialog(
      context: context, 
      builder: (_) => ResponseDialog(
        description: AppLocalizations.of(context)!.repetition_number_error, 
        response: Response.Error
      )
    );
  }
}
