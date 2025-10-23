import 'package:intl/intl.dart';

abstract class DateConverter{
  static DateTime parseCustomDateTime(String dateTimeStr) {
    List<String> parts = dateTimeStr.split(' '); // Split date and time
    List<String> dateParts = parts[0].split('-'); // Split day, month, year
    List<String> timeParts =
        parts[1].split(':'); // Split hours, minutes, seconds

    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);

    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    int second = int.parse(timeParts[2]);

    return DateTime(year, month, day, hour, minute, second);
  }
  static String formatDateTime(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy hh:mm a').format(dateTime);
  }

}
