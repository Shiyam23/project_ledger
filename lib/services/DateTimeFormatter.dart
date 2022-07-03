import 'dart:io';

import 'package:intl/intl.dart';

extension DateTimeFormatter on DateTime {
  String format(){
      return DateFormat("yMd", Platform.localeName).format(this);
  }
}