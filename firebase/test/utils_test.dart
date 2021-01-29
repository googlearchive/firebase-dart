@TestOn('browser')
import 'package:firebase/firestore.dart';
import 'package:firebase/src/utils.dart';
import 'package:js/js_util.dart' as util;
import 'package:test/test.dart';

void _testRoundTrip(Object value) {
  final js = jsify(value);
  final roundTrip = dartify(js);
  expect(roundTrip, value);
}

void main() {
  group('jsify and dartify', () {
    group('basic objects', () {
      final jsonObjects = {
        'int': 0,
        'null': null,
        'string': 'string',
        'bool': true,
        'double': 1.1,
        'list': [1, 2, 3],
        'map': {'a': true},
        'not a geopoint': {
          'latitude': 45.5122,
          'longitude': -122.6587,
          'foo': 'bar'
        }
      };

      jsonObjects.forEach((key, value) {
        test(key, () => _testRoundTrip(value));
      });
    });

    test('custom object', () {
      expect(() => jsify(_TestClass()), throwsArgumentError);
    });

    test('custom object with toJson', () {
      expect(() => jsify(_TestClassWithToJson()), throwsArgumentError);
    });

    test('geopoint', () {
      final geoClass = tryGetType(['firebase', 'firestore', 'GeoPoint']);

      if (geoClass == null) {
        fail('Forgot to include the firestore JS library!');
      }

      final value = util.callConstructor(geoClass, [45.5122, -122.6587]);
      final js = jsify(value);
      final roundTrip = dartify(js);
      expect(roundTrip, isA<GeoPoint>());
    });
  });
}

class _TestClass {}

class _TestClassWithToJson {
  Object toJson() => const {};
}
