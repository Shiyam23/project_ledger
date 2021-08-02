import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'Repetition.g.dart';

@HiveType(typeId: 4)
class Repetition {
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

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();

    if (this == none) return "Einmalig";

    if (amount == 1) {
      switch (time!) {
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
      switch (time!) {
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
      buffer.write(" bis ${DateFormat("dd.MM.yyyy").format(this.endDate!)}");
    return buffer.toString();
  }
}

@HiveType(typeId: 5)
enum CalenderUnit {
  @HiveField(0)
  dayly,
  @HiveField(1)
  monthly,
  @HiveField(2)
  yearly
}
