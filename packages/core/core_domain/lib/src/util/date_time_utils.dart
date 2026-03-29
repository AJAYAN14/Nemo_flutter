class DateTimeUtils {
  // Server time offset in milliseconds. This mirrors the Kotlin implementation's
  // ability to compensate device time by a server-provided offset.
  static int _serverTimeOffset = 0;

  /// Set server time offset (milliseconds). Positive means server is ahead of device.
  static void setServerTimeOffset(int offsetMillis) {
    _serverTimeOffset = offsetMillis;
  }

  /// Returns compensated current time in milliseconds since epoch (device time + offset).
  static int getCurrentCompensatedMillis() {
    return DateTime.now().millisecondsSinceEpoch + _serverTimeOffset;
  }

  /// Convert a physical timestamp (millis) to a logical learning day (epoch day)
  /// using the provided daily reset hour. This mirrors the Kotlin `toLearningDay`.
  static int toLearningDay(int millis, int resetHour) {
    final dt = DateTime.fromMillisecondsSinceEpoch(millis);
    DateTime learningDate = dt;
    if (dt.hour < resetHour) {
      learningDate = dt.subtract(const Duration(days: 1));
    }

    return dateToEpochDay(learningDate);
  }

  /// Maps a DateTime (usually midnight) to its logical Epoch Day (days since 1970-01-01).
  /// This ignores time and timezone offset to ensure a specific calendar date
  /// always maps to the same epoch day regardless of where it's calculated.
  static int dateToEpochDay(DateTime date) {
    // We use UTC midnight of the target date to get a stable epoch day.
    return DateTime.utc(date.year, date.month, date.day).millisecondsSinceEpoch ~/ 86400000;
  }

  /// Returns the current learning day as epoch days (days since 1970-01-01).
  static int getLearningDay(int resetHour) {
    return toLearningDay(getCurrentCompensatedMillis(), resetHour);
  }

  /// Returns the start of the learning day in milliseconds since epoch (local time
  /// at the configured reset hour). Computed from the logical epoch day so it's
  /// consistent with `toLearningDay`.
  static int getLearningDayStart(int resetHour) {
    final epochDay = getLearningDay(resetHour);
    final utcMidnight = DateTime.utc(1970, 1, 1).add(Duration(days: epochDay));
    final localMidnight = utcMidnight.toLocal();
    final startLocal = DateTime(localMidnight.year, localMidnight.month, localMidnight.day, resetHour);
    return startLocal.millisecondsSinceEpoch;
  }

  /// Returns the end of the learning day in milliseconds since epoch.
  static int getLearningDayEnd(int resetHour) {
    return getLearningDayStart(resetHour) + 86400000 - 1;
  }

  /// Formats epoch day to YYYY-MM-DD (local representation)
  static String formatEpochDay(int epochDay) {
    final date = DateTime.fromMillisecondsSinceEpoch(epochDay * 86400000, isUtc: true).toLocal();
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
