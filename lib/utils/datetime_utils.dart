import 'package:intl/intl.dart';

class DateTimeUtils {
  static String getMonth(DateTime dateTime) {
    var formatter = DateFormat('MMM', 'en_US');
    return formatter.format(dateTime);
  }

  static String getDayOfMonth(DateTime dateTime) {
    var formatter = DateFormat('dd', 'en_US');
    return formatter.format(dateTime);
  }

  static String getFullDate(DateTime dateTime) {
    var formatter = DateFormat('dd MMM, yyyy', 'en_US');
    return formatter.format(dateTime);
  }

  static String getDayOfWeek(DateTime dateTime) {
    var formatter = DateFormat('EEEE', 'en_US');
    return formatter.format(dateTime);
  }
}
