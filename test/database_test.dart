@TestOn('browser')
import 'package:firebase3/firebase.dart' as fb;
import 'package:firebase3/src/assets/assets.dart';
import 'package:test/test.dart';

void main() {
  group("Database", () {
    setUpAll(() async {
      await config();
    });

    group('instance', () {
      setUpAll(() {
        fb.initializeApp(
            apiKey: apiKey,
            authDomain: authDomain,
            databaseURL: databaseUrl,
            storageBucket: storageBucket);
      });

      test("App exists", () {
        var database = fb.database();
        expect(database, isNotNull);
        expect(database.app, isNotNull);
        expect(database.app.name, fb.app().name);
      });
    });
  });
}
