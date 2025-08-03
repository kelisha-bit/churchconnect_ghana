import 'package:intl/intl.dart';

class AppDateUtils {
  static const String defaultDateFormat = 'dd MMM yyyy';
  static const String defaultTimeFormat = 'HH:mm';
  static const String defaultDateTimeFormat = 'dd MMM yyyy HH:mm';

  // Format date to string
  static String formatDate(DateTime date, {String format = defaultDateFormat}) {
    return DateFormat(format).format(date);
  }

  // Format time to string
  static String formatTime(DateTime time, {String format = defaultTimeFormat}) {
    return DateFormat(format).format(time);
  }

  // Format date and time to string
  static String formatDateTime(DateTime dateTime,
      {String format = defaultDateTimeFormat}) {
    return DateFormat(format).format(dateTime);
  }

  // Parse string to date
  static DateTime? parseDate(String dateString,
      {String format = defaultDateFormat}) {
    try {
      return DateFormat(format).parse(dateString);
    } catch (e) {
      return null;
    }
  }

  // Get time ago string
  static String getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 7) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  // Check if date is this week
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  // Check if date is this month
  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  // Check if date is this year
  static bool isThisYear(DateTime date) {
    return date.year == DateTime.now().year;
  }

  // Get start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Get end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  // Get start of week (Monday)
  static DateTime startOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return startOfDay(date.subtract(Duration(days: daysFromMonday)));
  }

  // Get end of week (Sunday)
  static DateTime endOfWeek(DateTime date) {
    final daysToSunday = 7 - date.weekday;
    return endOfDay(date.add(Duration(days: daysToSunday)));
  }

  // Get start of month
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  // Get end of month
  static DateTime endOfMonth(DateTime date) {
    final nextMonth = DateTime(date.year, date.month + 1, 1);
    return nextMonth.subtract(const Duration(microseconds: 1));
  }

  // Get start of year
  static DateTime startOfYear(DateTime date) {
    return DateTime(date.year, 1, 1);
  }

  // Get end of year
  static DateTime endOfYear(DateTime date) {
    return DateTime(date.year, 12, 31, 23, 59, 59, 999);
  }

  // Get age from birth date
  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;

    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  // Get days until date
  static int daysUntil(DateTime date) {
    final now = DateTime.now();
    return date.difference(startOfDay(now)).inDays;
  }

  // Get upcoming birthday (this year or next year)
  static DateTime getUpcomingBirthday(DateTime birthDate) {
    final now = DateTime.now();
    final thisYearBirthday = DateTime(now.year, birthDate.month, birthDate.day);

    if (thisYearBirthday.isAfter(now)) {
      return thisYearBirthday;
    } else {
      return DateTime(now.year + 1, birthDate.month, birthDate.day);
    }
  }

  // Get weekday name
  static String getWeekdayName(DateTime date) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return weekdays[date.weekday - 1];
  }

  // Get month name
  static String getMonthName(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[date.month - 1];
  }

  // Check if date is in range
  static bool isDateInRange(
      DateTime date, DateTime startDate, DateTime endDate) {
    return date.isAfter(startDate.subtract(const Duration(microseconds: 1))) &&
        date.isBefore(endDate.add(const Duration(microseconds: 1)));
  }

  // Get relative date string
  static String getRelativeDateString(DateTime date) {
    if (isToday(date)) {
      return 'Today';
    } else if (isTomorrow(date)) {
      return 'Tomorrow';
    } else if (date
        .isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    } else if (isThisWeek(date)) {
      return getWeekdayName(date);
    } else {
      return formatDate(date);
    }
  }
}
