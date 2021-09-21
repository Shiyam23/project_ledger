import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

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

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();

    if (this == Repetition.none) return "No Repetition";

    if (amount == 1) {
      switch (time!) {
        case CalenderUnit.dayly:
          buffer.write("Every day");
          break;

        case CalenderUnit.monthly:
          buffer.write("Every month");
          break;

        case CalenderUnit.yearly:
          buffer.write("Every year");
          break;
      }
    } else {
      buffer.write("Every $amount ");
      switch (time!) {
        case CalenderUnit.dayly:
          buffer.write("day(s)");
          break;

        case CalenderUnit.monthly:
          buffer.write("month(s)");
          break;

        case CalenderUnit.yearly:
          buffer.write("year(s)");
          break;
      }
    }
    if (this.endDate != null)
      buffer.write(" until ${DateFormat("dd.MM.yyyy").format(this.endDate!)}");
    return buffer.toString();
  }

  @override
  List<Object?> get props => [amount, time, endDate];
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
