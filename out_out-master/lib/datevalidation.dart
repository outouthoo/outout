import 'dart:io';

import 'package:intl/intl.dart';

checkDateIsToday() {
  if (Platform.isIOS) {
    var currentDate = DateTime.now();
    var newDate = DateFormat('yyyy-MM-dd').parse('2022-02-06');
    if (currentDate.millisecondsSinceEpoch >=
        newDate.millisecondsSinceEpoch) {
      return true;
    }
    return false;
  }
  else
    return true;
}