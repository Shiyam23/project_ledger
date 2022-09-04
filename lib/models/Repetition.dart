import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


part 'Repetition.g.dart';

@HiveType(typeId: 4)
class Repetition extends Equatable{
  @HiveField(0)
  final int? amount;
  @HiveField(1)
  final CalenderUnit? time;
  @HiveField(2)
  final DateTime? endDate;

  static const Repetition none =
      Repetition(amount: null, time: null, endDate: null);

  const Repetition(
      {required this.amount, required this.time, required this.endDate});

  String toLocalizedString(BuildContext context) {
    StringBuffer buffer = StringBuffer();

    if (this == Repetition.none) return AppLocalizations.of(context)!.noRepetition;

    if (amount == 1) {
      switch (time!) {
        case CalenderUnit.daily:
          buffer.write(AppLocalizations.of(context)!.everyDay);
          break;

        case CalenderUnit.monthly:
          buffer.write(AppLocalizations.of(context)!.everyMonth);
          break;

        case CalenderUnit.yearly:
          buffer.write(AppLocalizations.of(context)!.everyYear);
          break;
      }
    } else {
      String every = AppLocalizations.of(context)!.every;
      String days = AppLocalizations.of(context)!.days;
      String months = AppLocalizations.of(context)!.months;
      String years = AppLocalizations.of(context)!.years;
      buffer.write("$every $amount ");
      switch (time!) {
        case CalenderUnit.daily:
          buffer.write(days);
          break;

        case CalenderUnit.monthly:
          buffer.write(months);
          break;

        case CalenderUnit.yearly:
          buffer.write(years);
          break;
      }
    }
    if (this.endDate != null) {
      String until = AppLocalizations.of(context)!.until;
      buffer.write(" $until ${DateFormat("dd.MM.yyyy").format(this.endDate!)}");
    }
    return buffer.toString();
  }

  @override
  List<Object?> get props => [amount, time, endDate];
}

@HiveType(typeId: 5)
enum CalenderUnit {
  @HiveField(0)
  daily,
  @HiveField(1)
  monthly,
  @HiveField(2)
  yearly
}
