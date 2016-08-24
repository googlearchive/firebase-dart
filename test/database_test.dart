@TestOn('browser')
import 'package:firebase3/firebase.dart' as fb;
import 'package:firebase3/src/assets/assets.dart';
import 'package:test/test.dart';
import 'package:firebase3/firebase.dart';

void main() {
  App app;

  setUpAll(() async {
    await config();
  });

  setUp(() async {
    app = initializeApp(
        apiKey: apiKey,
        authDomain: authDomain,
        databaseURL: databaseUrl,
        storageBucket: storageBucket);
  });

  tearDown(() async {
    if (app != null) {
      await app.delete();
      app = null;
    }
  });

  group("Database", () {
    Database database;

    setUp(() {
      database = fb.database();
    });

    group("instance", () {
      test("App exists", () {
        expect(database, isNotNull);
        expect(database.app, isNotNull);
        expect(database.app.name, fb.app().name);
      });
    });

    group("DatabaseReference", () {
      DatabaseReference ref;
      String key;

      setUp(() {
        ref = database.ref("notes");
        key = ref.push({"text": "hello"}).key;
        expect(key, isNotNull);
      });

      tearDown(() async {
        await ref.remove();
        ref = null;
      });

      test("child", () {
        var childRef = ref.child(key);
        expect(childRef, isNotNull);

        var childChildRef = childRef.child("text");
        expect(childChildRef, isNotNull);
      });

      test("key", () {
        var childRef = ref.child(key);
        expect(key, childRef.key);
      });

      test("parent", () {
        var childRef = ref.child("text");
        expect(childRef, isNotNull);
        expect(childRef.parent.toString(), "${databaseUrl}/notes");
      });

      test("root", () {
        var childRef = ref.child("text");
        expect(childRef.root.toString(), contains(databaseUrl));
      });
    });
  });
}
