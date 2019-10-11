import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Repetition {
  int amount;
  CalenderUnit time;
  DateTime endDate;
  static Repetition none = Repetition(amount: null, time: null, endDate: null);

  Repetition(
      {@required this.amount, @required this.time, @required this.endDate});

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();

    if (this == none) return "Einmalig";

    if (amount == 1) {
      switch (time) {
        case CalenderUnit.dayly:
          buffer.write("Jeden Tag");
          break;

        case CalenderUnit.monthly:
          buffer.write("Jeden Monat");
          break;

        case CalenderUnit.yearly:
          buffer.write("Jedes Jahr");
          break;
      }
    } else {
      buffer.write("Alle $amount ");
      switch (time) {
        case CalenderUnit.dayly:
          buffer.write("Tage");
          break;

        case CalenderUnit.monthly:
          buffer.write("Monate");
          break;

        case CalenderUnit.yearly:
          buffer.write("Jahre");
          break;
      }
    }
    if (this.endDate != null)
      buffer.write(" bis ${DateFormat("dd.MM.yyyy").format(this.endDate)}");
    return buffer.toString();
  }
}

enum CalenderUnit { dayly, monthly, yearly }
