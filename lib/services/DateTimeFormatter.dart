import 'dart:io';

import 'package:intl/intl.dart';

extension DateTimeFormatter on DateTime {
  String format({String? format}){
      return DateFormat(format ?? "yMd", Platform.localeName).format(this);
  }
}