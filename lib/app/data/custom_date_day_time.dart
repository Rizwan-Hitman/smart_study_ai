import 'package:intl/intl.dart';

class DateDayTime {
  int year;
  String month;
  int monthNumber;
  int day;
  String weekday;
  String time; // In 12-hour format with AM/PM

  // Constructor
  DateDayTime(
    this.year,
    this.month,
    this.monthNumber,
    this.day,
    this.weekday,
    this.time,
  );

  // Factory method to create an instance from DateTime
  factory DateDayTime.fromDateTime(DateTime dateTime) {
    return DateDayTime(
      dateTime.year,
      DateFormat('MMMM').format(dateTime), // Full month name
      dateTime.month,
      dateTime.day,
      DateFormat('EEEE').format(dateTime), // Full weekday name
      DateFormat('hh:mm a').format(dateTime), // 12-hour format with AM/PM
    );
  }

  // Method to return formatted date string
  String formatted() {
    return "$year-$month-$day $weekday $time";
  }
}
