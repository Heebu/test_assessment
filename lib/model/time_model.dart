import 'package:intl/intl.dart';

class TimeModel {
  final String time;     // "2:45"
  final String period;   // "PM"
  final String month;    // "May"
  final int day;         // 13
  final int year;        // 2025

  TimeModel({
    required this.time,
    required this.period,
    required this.month,
    required this.day,
    required this.year,
  });

  /// Factory to parse from DateTime
  factory TimeModel.fromDateTime(DateTime dateTime) {
    final timeFormat = DateFormat('h:mm');
    final periodFormat = DateFormat('a'); // AM/PM
    final monthFormat = DateFormat('MMMM'); // Full month name

    return TimeModel(
      time: timeFormat.format(dateTime),
      period: periodFormat.format(dateTime),
      month: monthFormat.format(dateTime),
      day: dateTime.day,
      year: dateTime.year,
    );
  }

  factory TimeModel.fromTimestamp(dynamic timestamp) {
    final DateTime dateTime = timestamp.toDate(); // Assuming Firestore Timestamp
    return TimeModel.fromDateTime(dateTime);
  }

  @override
  String toString() {
    return '$time $period, $month $day, $year';
  }
}
