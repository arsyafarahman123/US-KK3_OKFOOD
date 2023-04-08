import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    initializeDateFormatting('id_ID', null);
    String formattedDate = DateFormat.yMMMMd('id_ID').format(date);
    return formattedDate;
  }
}

class TimeFormatter {
  static String formatTime(DateTime dateTime) {
    String period = 'AM';
    int hour = dateTime.hour;
    if (hour >= 12) {
      period = 'PM';
      if (hour > 12) {
        hour -= 12;
      }
    }
    if (hour == 0) {
      hour = 12;
    }
    String minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}