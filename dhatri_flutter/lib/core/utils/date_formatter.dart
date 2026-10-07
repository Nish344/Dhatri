import 'package:intl/intl.dart';

/// Formatter utilities for Dhatri dates and times (IST).
class DateFormatter {
  static final DateFormat _timeFormat = DateFormat('h:mm a');
  static final DateFormat _dateFormat = DateFormat('EEEE, d MMMM');
  static final DateFormat _shortDate = DateFormat('d MMM');

  static String formatTime(DateTime dateTime) {
    return _timeFormat.format(dateTime.toLocal());
  }

  static String formatFullDate(DateTime dateTime) {
    return _dateFormat.format(dateTime.toLocal());
  }

  static String formatShortDate(DateTime dateTime) {
    return _shortDate.format(dateTime.toLocal());
  }

  static String relativeDay(DateTime dateTime) {
    final now = DateTime.now();
    final local = dateTime.toLocal();
    final difference = now.difference(local);

    if (now.year == local.year && now.month == local.month && now.day == local.day) {
      return 'Today';
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (yesterday.year == local.year && yesterday.month == local.month && yesterday.day == local.day) {
      return 'Yesterday';
    }
    if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    }
    return formatShortDate(dateTime);
  }
}

