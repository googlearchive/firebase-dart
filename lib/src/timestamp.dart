/// A Timestamp represents a point in time independent of any time zone or
/// calendar, represented as seconds and fractions of seconds at nanosecond
/// resolution in UTC Epoch time.
///
/// Timestamps are encoded using the Proleptic Gregorian Calendar, which extends
/// the Gregorian calendar backwards to year one. Timestamps assume all minutes
/// are 60 seconds long, i.e. leap seconds are "smeared" so that no leap second
/// table is needed for interpretation. Possible timestamp values range from
/// 0001-01-01T00:00:00Z to 9999-12-31T23:59:59.999999999Z.
class Timestamp implements Comparable<Timestamp> {
  final int seconds;
  final int nanoseconds;

  /// [seconds] is the number of [seconds] of UTC time since Unix epoch
  /// 1970-01-01T00:00:00Z.
  /// Must be from 0001-01-01T00:00:00Z to 9999-12-31T23:59:59Z inclusive.
  ///
  /// [nanoseconds] is the non-negative fractions of a second at nanosecond
  /// resolution. Negative second values with fractions must still have
  /// non-negative nanoseconds values that count forward in time.
  /// Must be from 0 to 999,999,999 inclusive.
  Timestamp(int seconds, int nanoseconds)
      : seconds = seconds ?? 0,
        nanoseconds = nanoseconds ?? 0 {
    if (seconds < -62135596800 || seconds > 253402300799) {
      throw ArgumentError('invalid seconds part ${toDateTime(isUtc: true)}');
    }
    if (nanoseconds < 0 || nanoseconds > 999999999) {
      throw ArgumentError(
          'invalid nanoseconds part ${toDateTime(isUtc: true)}');
    }
  }

  /// [parse] or returns null
  static Timestamp tryParse(String text) {
    if (text != null) {
      // 2018-10-20T05:13:45.985343Z
      var dateTime = DateTime.tryParse(text);

      // remove after the seconds part
      var subSecondsStart = text.lastIndexOf('.');
      if (subSecondsStart == -1) {
        if (dateTime == null) {
          return null;
        } else {
          return Timestamp.fromDateTime(dateTime);
        }
      }

      bool isDigit(String chr) => (chr.codeUnitAt(0) ^ 0x30) <= 9;

      // Read the sun seconds part
      var nanosString = StringBuffer();
      var i = subSecondsStart + 1;
      for (; i < text.length; i++) {
        var char = text[i];
        if (isDigit(char)) {
          // Never write more than 9 chars
          if (nanosString.length < 9) {
            nanosString.write(char);
          }
        } else {
          break;
        }
      }
      // Never write less than 9 chars
      while (nanosString.length < 9) {
        nanosString.write('0');
      }

      // reparse the date if needed removing the sub seconds part
      if (dateTime == null) {
        var parseableDateTime =
            '${text.substring(0, subSecondsStart)}${text.substring(i)}';
        dateTime = DateTime.tryParse(parseableDateTime);
        if (dateTime == null) {
          // give up
          return null;
        }
      }

      var seconds = (dateTime.millisecondsSinceEpoch / 1000).floor();
      var nanoseconds = int.tryParse(nanosString.toString());
      return Timestamp(seconds, nanoseconds);
    }
    return null;
  }

  /// Creates a new [Timestamp] instance from the given date
  factory Timestamp.fromDateTime(DateTime dateTime) {
    final seconds = (dateTime.millisecondsSinceEpoch / 1000).floor();
    final nanoseconds = (dateTime.microsecondsSinceEpoch % 1000000) * 1000;
    return Timestamp(seconds, nanoseconds);
  }

  /// Constructs a new [Timestamp] instance
  /// with the given [millisecondsSinceEpoch].
  factory Timestamp.fromMillisecondsSinceEpoch(int millisecondsSinceEpoch) {
    final seconds = (millisecondsSinceEpoch / 1000).floor();
    final nanoseconds = (millisecondsSinceEpoch % 1000) * 1000000;
    return Timestamp(seconds, nanoseconds);
  }

  /// Constructs a [Timestamp] instance with current date and time
  factory Timestamp.now() => Timestamp.fromDateTime(DateTime.now());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is Timestamp) {
      var typedOther = other;
      return seconds == typedOther.seconds &&
          nanoseconds == typedOther.nanoseconds;
    }
    return false;
  }

  @override
  int get hashCode => (seconds ?? 0) + (nanoseconds ?? 0);

  /// The number of milliseconds since
  /// the "Unix epoch" 1970-01-01T00:00:00Z (UTC).
  int get millisecondsSinceEpoch {
    return seconds * 1000 + (nanoseconds ~/ 10000000);
  }

  // Not exported as we loose precision
  int get _microsecondsSinceEpoch {
    return (seconds * 1000000) + (nanoseconds ~/ 1000);
  }

  /// Convert a Timestamp to a [DateTime] object. This conversion
  /// causes a loss of precision and support millisecond precision.
  DateTime toDateTime({bool isUtc}) {
    return DateTime.fromMicrosecondsSinceEpoch(_microsecondsSinceEpoch,
        isUtc: isUtc == true);
  }

  static String _threeDigits(int n) {
    if (n >= 100) return "$n";
    if (n >= 10) return "0$n";
    return "00$n";
  }

  static String _formatNanos(int nanoseconds) {
    var ns = nanoseconds % 1000;
    if (ns != 0) {
      return '${_threeDigits(nanoseconds ~/ 1000000)}${_threeDigits((nanoseconds ~/ 1000) % 1000)}${_threeDigits(ns)}';
    } else {
      return _formatMicros(nanoseconds ~/ 1000);
    }
  }

  static String _formatMicros(int microseconds) {
    var us = microseconds % 1000;
    return '${_formatMillis(microseconds ~/ 1000)}${us == 0 ? '' : _threeDigits(us)}';
  }

  static String _formatMillis(int milliseconds) => _threeDigits(milliseconds);

  ///
  /// Returns an ISO-8601 full-precision extended format representation.
  /// The format is `yyyy-MM-ddTHH:mm:ss.mmmuuunnnZ`
  /// nanoseconds and microseconds are omitted if null
  String toIso8601String() {
    // Use DateTime without the sub second part
    var text = Timestamp(seconds, 0).toDateTime(isUtc: true).toIso8601String();
    // Then add the nano part to it
    var nanosStart = text.lastIndexOf('.') + 1;
    return '${text.substring(0, nanosStart)}${_formatNanos(nanoseconds)}Z';
  }

  @override
  String toString() => toIso8601String();

  @override
  int compareTo(Timestamp other) {
    if (seconds != other.seconds) {
      return seconds - other.seconds;
    }
    return nanoseconds - other.nanoseconds;
  }

  /// The function parses a subset of ISO 8601
  /// which includes the subset accepted by RFC 3339.
  ///
  /// Compare to [DateTime.parse], it supports nanoseconds resolution
  static Timestamp parse(String text) {
    if (text == null) {
      throw ArgumentError.notNull(text);
    } else {
      var timestamp = tryParse(text);
      if (timestamp == null) {
        throw FormatException('timestamp $text');
      }
      return timestamp;
    }
  }
}
