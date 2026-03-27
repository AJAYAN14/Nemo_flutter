class DateTimeUtils {
  /// Returns the current learning day as epoch days (days since 1970-01-01).
  /// A learning day starts at [resetHour] (0-23).
  static int getLearningDay(int resetHour) {
    final now = DateTime.now();
    DateTime learningDate = now;
    if (now.hour < resetHour) {
      learningDate = now.subtract(const Duration(days: 1));
    }
    
    // Normalize to start of day in local time
    final dateOnly = DateTime(learningDate.year, learningDate.month, learningDate.day);
    // Use the local date string components or similar to get a stable "day index"
    // Since epoch milliseconds in local time aren't necessarily multiples of 86400000,
    // we use the local year/month/day to represent the day.
    return dateOnly.millisecondsSinceEpoch ~/ 86400000;
  }

  /// Returns the start of the learning day in milliseconds since epoch (UTC).
  static int getLearningDayStart(int resetHour) {
    final now = DateTime.now();
    DateTime start = DateTime(now.year, now.month, now.day, resetHour);
    if (now.hour < resetHour) {
      start = start.subtract(const Duration(days: 1));
    }
    return start.millisecondsSinceEpoch;
  }

  /// Returns the end of the learning day in milliseconds since epoch (UTC).
  static int getLearningDayEnd(int resetHour) {
    return getLearningDayStart(resetHour) + 86400000 - 1;
  }

  /// Formats epoch day to YYYY-MM-DD
  static String formatEpochDay(int epochDay) {
    final date = DateTime.fromMillisecondsSinceEpoch(epochDay * 86400000);
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
