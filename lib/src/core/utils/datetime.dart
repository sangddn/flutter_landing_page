import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class DateFormatter {
  static String dateRangeToString(DateTime startDate, DateTime endDate) {
    if (startDate.year != endDate.year) {
      return '${DateFormat('MMM d, yyyy').format(startDate)} - ${DateFormat('MMM d, yyyy').format(endDate)}';
    }
    if (startDate.month != endDate.month) {
      return '${DateFormat('MMM d').format(startDate)} - ${DateFormat('MMM d, yyyy').format(endDate)}';
    }
    return '${DateFormat('MMM d').format(startDate)} - ${DateFormat('d, yyyy').format(endDate)}';
  }

  static String dateToShortString(DateTime date) {
    if (date.year != DateTime.now().year) {
      return DateFormat("MMM d, ''yy").format(date);
    }
    return DateFormat('MMM d, HH:mm').format(date);
  }

  static String dateToShortStringNoTime(DateTime date) {
    if (date.year != DateTime.now().year) {
      return DateFormat("MMM d, ''yy").format(date);
    }
    return DateFormat('MMM d').format(date);
  }

  static String dateToMonthYearString(DateTime date) {
    return DateFormat('MMM yyyy').format(date);
  }

  static String dateRangeToShortString(DateTimeRange range) {
    final now = DateTime.now();
    final start = range.start;
    final end = range.end;

    String formattedStart;
    String formattedEnd;

    String formatMonthDay(DateTime date) {
      return '${DateFormat.MMM().format(date)} ${date.day}';
    }

    // Determine the year format
    if (start.year == end.year && start.year != now.year) {
      formattedStart = formatMonthDay(start);
      formattedEnd =
          "${formatMonthDay(end)}, '${end.year.toString().substring(2)}";
    } else {
      formattedStart = (start.year == now.year)
          ? formatMonthDay(start)
          : "${formatMonthDay(start)}, '${start.year.toString().substring(2)}";

      formattedEnd = (end.year == now.year)
          ? formatMonthDay(end)
          : "${formatMonthDay(end)}, '${end.year.toString().substring(2)}";
    }

    // Handle colliding months
    // if (start.month == end.month) {
    //   formattedStart = '${start.day}';
    // }

    return '$formattedStart – $formattedEnd';
  }
}

extension DateTimeCustomFormat on DateTime {
  String toShortString() {
    return DateFormatter.dateToShortString(this);
  }

  String toShortStringNoTime() {
    return DateFormatter.dateToShortStringNoTime(this);
  }

  String toMonthYearString() {
    return DateFormatter.dateToMonthYearString(this);
  }

  String toReadableString({bool shortMonth = false}) {
    if (shortMonth) {
      return DateFormat('MMM d, yyyy').format(this);
    }
    return DateFormat.yMMMMd().format(this);
  }
}

extension DateTimeRangeCustomFormat on DateTimeRange {
  String toShortString() {
    return DateFormatter.dateRangeToShortString(this);
  }

  /// Returns a string in the format of "MM/dd/YY - MM/dd/YY"
  /// If the start and end dates are in the same year, the year is omitted from the start date
  ///
  /// Example:
  /// 12/31/20 - 01/01/21
  /// 12/30 - 12/31/21
  ///
}

/// Nullable DateTime deserialization
DateTime? nullableDatetimeFromJson(num? int) =>
    int != null ? DateTime.fromMicrosecondsSinceEpoch(int.toInt()) : null;

/// Nullable DateTime serialization
int? nullableDatetimeToJson(DateTime? time) => time?.microsecondsSinceEpoch;

/// DateTime deserialization
DateTime datetimeFromJson(num microsecondsSinceEpoch) =>
    DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch.toInt());

/// DateTime serialization
int datetimeToJson(DateTime time) => time.microsecondsSinceEpoch;

extension Utils on DateTime {
  Jiffy get jiffy => Jiffy.parseFromDateTime(this);
  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999, 999);
  DateTime get localNoon => DateTime(year, month, day, 12).toLocal();
  bool get isBeforeToday => isBefore(DateTime.now().startOfDay);
  bool get isAfterToday => isAfter(DateTime.now().endOfDay);
  bool get isToday => isLocalSameDayAs(DateTime.now());
  bool get isNotToday => !isToday;
  bool get isTodayOrBefore => isBeforeToday || isToday;
  bool get isTodayOrAfter => isAfterToday || isToday;

  /// Compact format with an option to include hours
  ///
  /// Eg. "7/17/23" (U.S.), "17/7/23" (International),
  /// "7/17/23 12:00 PM" (with time), "17/7/23 12:00 PM" (with time).
  ///
  String toCompact([bool includeTime = false]) {
    return '${jiffy.yMd}${includeTime ? ' ${jiffy.Hm}' : ''}';
  }

  /// Returns a short ISO 8601 format
  ///
  /// Eg. "2023-07-17"
  String toShortIso8601() => jiffy.format(pattern: 'yyyy-MM-dd');

  /// Returns true if this date is the same day the other date
  /// assuming both dates are in the same timezone.
  /// If either is not UTC, it will be converted to UTC before comparison.
  /// If seconds offset is not provided, it will use the local seconds offset.
  bool isLocalSameDayAs(
    DateTime other, [
    int? secondsOffsetFromUtc,
    Duration tolerance = Duration.zero,
  ]) {
    secondsOffsetFromUtc ??= ExtendedDateTime.localSecondsOffset;

    final thisLocal = toUtc().add(Duration(seconds: secondsOffsetFromUtc));
    final otherLocal =
        other.toUtc().add(Duration(seconds: secondsOffsetFromUtc));

    if (thisLocal.year == otherLocal.year &&
        thisLocal.month == otherLocal.month &&
        thisLocal.day == otherLocal.day) {
      return true;
    }

    // Take tolerance into account
    if (tolerance > Duration.zero) {
      final thisLocalWiddle = thisLocal.subtract(tolerance);
      final thisLocalWaddle = thisLocal.add(tolerance);
      final otherLocalWiddle = otherLocal.subtract(tolerance);
      final otherLocalWaddle = otherLocal.add(tolerance);

      if (thisLocalWiddle.year == otherLocalWiddle.year &&
          thisLocalWiddle.month == otherLocalWiddle.month &&
          thisLocalWiddle.day == otherLocalWiddle.day) {
        return true;
      }

      if (thisLocalWaddle.year == otherLocalWaddle.year &&
          thisLocalWaddle.month == otherLocalWaddle.month &&
          thisLocalWaddle.day == otherLocalWaddle.day) {
        return true;
      }

      if (thisLocalWiddle.year == otherLocalWaddle.year &&
          thisLocalWiddle.month == otherLocalWaddle.month &&
          thisLocalWiddle.day == otherLocalWaddle.day) {
        return true;
      }

      if (thisLocalWaddle.year == otherLocalWiddle.year &&
          thisLocalWaddle.month == otherLocalWiddle.month &&
          thisLocalWaddle.day == otherLocalWiddle.day) {
        return true;
      }
    }

    return false;

    // A Jiffy implementation
    // return jiffy.isSame(
    //   other.jiffy,
    //   unit: Unit.day,
    // );
  }

  bool isNotSameDayAs(DateTime other) => !isLocalSameDayAs(other);

  bool isBeforeOrSameMomentAs(DateTime other) {
    return isBefore(other) || isAtSameMomentAs(other);
  }

  bool isAfterOrSameMomentAs(DateTime other) {
    return isAfter(other) || isAtSameMomentAs(other);
  }

  DateTime? addDateOrder(int dateOrder) {
    if (dateOrder <= 0) {
      return null;
    }
    return startOfDay.add(Duration(days: dateOrder - 1));
  }

  String weekdayInitial() => weekdayShort().substring(0, 1);
  String weekdayShort() => jiffy.E;
  String toTimeAgo() => jiffy.fromNow();

  DateTime nudgeLeft([int milliseconds = 1]) =>
      subtract(Duration(milliseconds: milliseconds));
  DateTime nudgeRight([int milliseconds = 1]) =>
      add(Duration(milliseconds: milliseconds));
}

extension NumberOfDays on Duration {
  int get numberOfDays => (inHours / 24).abs().ceil() + 1;
}

class ExtendedDateTime {
  static int localSecondsOffset = DateTime.now().timeZoneOffset.inSeconds;
  static DateTime startOfToday = DateTime.now().startOfDay;
  static DateTime endOfToday = DateTime.now().endOfDay;

  static DateTime getEarlier(DateTime a, DateTime b) => a.isBefore(b) ? a : b;
  static DateTime getAfter(DateTime a, DateTime b) => a.isAfter(b) ? a : b;

  static int numberOfDays(DateTime a, DateTime b) =>
      (b.startOfDay.difference(a.startOfDay).inHours / 24).abs().ceil() + 1;

  static int getDateOrder({
    required DateTime date,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    if (date.isLocalSameDayAs(startDate)) {
      return 1;
    }
    if (date.isLocalSameDayAs(endDate)) {
      return numberOfDays(startDate, endDate);
    }
    if (date.isBefore(startDate) || date.isAfter(endDate)) {
      return -1;
    } else {
      return numberOfDays(startDate, date);
    }
  }
}

extension TodayRelativity on DateTimeRange {
  bool get isCurrent => start.isTodayOrBefore && end.isTodayOrAfter;
  bool get isUpcoming => start.isAfterToday;
  bool get isPast => end.isBeforeToday;
  int get numberOfDays => ExtendedDateTime.numberOfDays(start, end);
  int orderOf(DateTime other) => ExtendedDateTime.getDateOrder(
        date: other,
        startDate: start,
        endDate: end,
      );
}
