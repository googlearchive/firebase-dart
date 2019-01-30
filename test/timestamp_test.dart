import 'package:firebase/src/timestamp.dart';
import 'package:test/test.dart';

// Use this test to properly test on all platform
// pub run test -p chrome,node,vm,firefox .\test\timestamp_test.dart
bool get _runningAsJavascript => identical(1, 1.0);

main() {
  group('timestamp', () {
    test('equals', () {
      expect(Timestamp(1, 2), Timestamp(1, 2));
      expect(Timestamp(1, 2), isNot(Timestamp(1, 3)));
      expect(Timestamp(1, 2), isNot(Timestamp(0, 2)));
    });
    test('compareTo', () {
      expect(Timestamp(1, 2).compareTo(Timestamp(1, 2)), 0);
      expect(Timestamp(1, 2).compareTo(Timestamp(1, 3)), lessThan(0));
      expect(Timestamp(1, 2).compareTo(Timestamp(2, 2)), lessThan(0));
      expect(Timestamp(1, 2).compareTo(Timestamp(1, 1)), greaterThan(0));
      expect(Timestamp(1, 2).compareTo(Timestamp(0, 2)), greaterThan(0));
    });
    test('millisecondsSinceEpoch', () {
      var now = Timestamp(1, 1);
      expect(
          now.millisecondsSinceEpoch, now.toDateTime().millisecondsSinceEpoch);
      now = Timestamp.fromMillisecondsSinceEpoch(now.millisecondsSinceEpoch);
      expect(
          now.millisecondsSinceEpoch, now.toDateTime().millisecondsSinceEpoch);
    });

    test('equals', () {
      expect(Timestamp(1, 2), Timestamp(1, 2));
      expect(Timestamp(1, 2), isNot(Timestamp(1, 3)));
      expect(Timestamp(1, 2), isNot(Timestamp(0, 2)));
    });
    test('compareTo', () {
      expect(Timestamp(1, 2).compareTo(Timestamp(1, 2)), 0);
      expect(Timestamp(1, 2).compareTo(Timestamp(1, 3)), lessThan(0));
      expect(Timestamp(1, 2).compareTo(Timestamp(2, 2)), lessThan(0));
      expect(Timestamp(1, 2).compareTo(Timestamp(1, 1)), greaterThan(0));
      expect(Timestamp(1, 2).compareTo(Timestamp(0, 2)), greaterThan(0));
    });

    _checkToIso8601(
        Timestamp timestamp,
        String expectedTimestampToIso8601String,
        String expectedDateTimeToIso8601String) {
      var reason = '${timestamp.seconds} s ${timestamp.nanoseconds} ns';
      expect(timestamp.toIso8601String(), expectedTimestampToIso8601String,
          reason: 'timestamp $reason');
      expect(timestamp.toDateTime(isUtc: true).toIso8601String(),
          expectedDateTimeToIso8601String,
          reason: 'dateTime $reason');
    }

    test('toIso8601', () {
      _checkToIso8601(Timestamp(0, 0), '1970-01-01T00:00:00.000Z',
          '1970-01-01T00:00:00.000Z');
      _checkToIso8601(Timestamp(0, 100000000), '1970-01-01T00:00:00.100Z',
          '1970-01-01T00:00:00.100Z');
      _checkToIso8601(
        Timestamp(0, 100000),
        '1970-01-01T00:00:00.000100Z',
        _runningAsJavascript
            ? '1970-01-01T00:00:00.000Z'
            : '1970-01-01T00:00:00.000100Z',
      );
      _checkToIso8601(
        Timestamp(0, 100),
        '1970-01-01T00:00:00.000000100Z',
        _runningAsJavascript
            ? '1970-01-01T00:00:00.000Z'
            : '1970-01-01T00:00:00.000Z',
      );
      _checkToIso8601(
        Timestamp(0, 999999999),
        '1970-01-01T00:00:00.999999999Z',
        _runningAsJavascript
            ? '1970-01-01T00:00:01.000Z' // Precision issue
            : '1970-01-01T00:00:00.999999Z',
      );
    });

    test('limit', () {
      Timestamp(-62135596800, 0);
      Timestamp(253402300799, 999999999);

      expect(() => Timestamp(-62135596801, 0), throwsArgumentError);
      expect(() => Timestamp(253402300800, 0), throwsArgumentError);
      expect(() => Timestamp(0, -1), throwsArgumentError);
      expect(() => Timestamp(0, 1000000000), throwsArgumentError);
    });
    test('parse', () {
      _checkParse(
        String text,
        String expectedTimestampToIso8601String,
        String expectedDateTimeToIso8601String,
      ) {
        var timestamp = Timestamp.parse(text);
        return _checkToIso8601(timestamp, expectedTimestampToIso8601String,
            expectedDateTimeToIso8601String);
      }

      _checkParseSecondsNanos(
          String text, int expectedSeconds, int expectedNanos) {
        var timestamp = Timestamp.parse(text);
        expect(timestamp.seconds, expectedSeconds, reason: text);
        expect(timestamp.nanoseconds, expectedNanos, reason: text);
      }

      _checkParse(
          '2018-10-20T05:13:45.985343123Z',
          '2018-10-20T05:13:45.985343123Z',
          _runningAsJavascript
              ? '2018-10-20T05:13:45.985Z'
              : '2018-10-20T05:13:45.985343Z');
      _checkParse(
          '2018-10-20T05:13:45.98534312Z',
          '2018-10-20T05:13:45.985343120Z',
          _runningAsJavascript
              ? '2018-10-20T05:13:45.985Z'
              : '2018-10-20T05:13:45.985343Z');
      _checkParse(
          '2018-10-20T05:13:45.985343Z',
          '2018-10-20T05:13:45.985343Z',
          _runningAsJavascript
              ? '2018-10-20T05:13:45.985Z'
              : '2018-10-20T05:13:45.985343Z');
      _checkParse('2018-10-20T05:13:45.985Z', '2018-10-20T05:13:45.985Z',
          '2018-10-20T05:13:45.985Z');
      _checkParse('1234-01-23T01:23:45.123Z', '1234-01-23T01:23:45.123Z',
          '1234-01-23T01:23:45.123Z');
      _checkParse('2018-10-20T05:13:45Z', '2018-10-20T05:13:45.000Z',
          '2018-10-20T05:13:45.000Z');
      _checkParse('2018-10-20T05:13Z', '2018-10-20T05:13:00.000Z',
          '2018-10-20T05:13:00.000Z');
      _checkParse('2018-10-20T05Z', '2018-10-20T05:00:00.000Z',
          '2018-10-20T05:00:00.000Z');

      // 10 digits ignored!
      _checkParse(
          '2018-10-20T05:13:45.9853431239Z',
          '2018-10-20T05:13:45.985343123Z',
          _runningAsJavascript
              ? '2018-10-20T05:13:45.985Z'
              : '2018-10-20T05:13:45.985343Z');

      // Limit
      _checkParse('0001-01-01T00:00:00Z', '0001-01-01T00:00:00.000Z',
          '0001-01-01T00:00:00.000Z');
      _checkParse(
          '9999-12-31T23:59:59.999999999Z',
          '9999-12-31T23:59:59.999999999Z',
          _runningAsJavascript
              ? '+010000-01-01T00:00:00.000Z' // Precision issue
              : '9999-12-31T23:59:59.999999Z');
      // Parse local converted to utc
      expect(Timestamp.tryParse('2018-10-20T05:13:45.985').toIso8601String(),
          endsWith('.985Z'));
      expect(Timestamp.tryParse('2018-10-20T05:13:45.985123').toIso8601String(),
          endsWith('.985123Z'));
      expect(
          Timestamp.tryParse('2018-10-20T05:13:45.985123100').toIso8601String(),
          endsWith('.985123100Z'));

      // Limit
      _checkParseSecondsNanos('0001-01-01T00:00:00Z', -62135596800, 0);
      _checkParseSecondsNanos(
          '9999-12-31T23:59:59.999999999Z', 253402300799, 999999999);
    });
  });
}
