@TestOn('browser')
import 'package:firebase3/firebase.dart' as fb;
import 'package:firebase3/src/assets/assets.dart';
import 'package:test/test.dart';
import 'package:firebase3/firebase.dart';

import 'test_util.dart';

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
        ref = database.ref(validDatePath());
        key = ref.push({"text": "hello"}).key;
        expect(key, isNotNull);
      });

      tearDown(() async {
        await ref.remove();
        ref = null;
        key = null;
      });

      test('remove', () async {
        var eventFuture = ref.onValue.first;

        await ref.remove();
        var event = await eventFuture;

        expect(event.snapshot.val(), isNull);
      });

      test("child and once on value", () async {
        var childRef = ref.child(key);
        var event = await childRef.once("value");
        expect(event.snapshot.key, key);
        expect(event.snapshot.val()["text"], "hello");

        childRef = childRef.child("text");
        event = await childRef.once("value");
        expect(event.snapshot.key, "text");
        expect(event.snapshot.val(), "hello");
      });

      test("key", () {
        var childRef = ref.child(key);
        expect(key, childRef.key);
      });

      test("parent", () {
        var childRef = ref.child("text");
        expect(childRef.parent.toString(), ref.toString());
      });

      test("root", () {
        var childRef = ref.child("text");
        expect(childRef.root.toString(), contains(databaseUrl));
      });

      test("empty push and set", () async {
        var newRef = ref.push();
        expect(newRef.key, isNotNull);
        await newRef.set({"text": "ahoj"});

        var event = await newRef.once("value");
        expect(event.snapshot.val()["text"], "ahoj");
      });

      test("endAt", () async {
        var childRef = ref.child("flowers");
        childRef.push("rose");
        childRef.push("tulip");
        childRef.push("chicory");
        childRef.push("sunflower");

        var event = await childRef.orderByValue().endAt("rose").once("value");
        var flowers = [];
        event.snapshot.forEach((snapshot) {
          flowers.add(snapshot.val());
        });

        expect(flowers.length, 2);
        expect(flowers.contains("chicory"), isTrue);
        expect(flowers.contains("sunflower"), isFalse);
      });

      test("startAt", () async {
        var childRef = ref.child("flowers");
        childRef.push("rose");
        childRef.push("tulip");
        childRef.push("chicory");
        childRef.push("sunflower");

        var event = await childRef.orderByValue().startAt("rose").once("value");
        var flowers = [];
        event.snapshot.forEach((snapshot) {
          flowers.add(snapshot.val());
        });

        expect(flowers.length, 3);
        expect(flowers.contains("sunflower"), isTrue);
        expect(flowers.contains("chicory"), isFalse);
      });

      test("equalTo", () async {
        var childRef = ref.child("flowers");
        childRef.push("rose");
        childRef.push("tulip");

        var event = await childRef.orderByValue().equalTo("rose").once("value");
        var flowers = [];
        event.snapshot.forEach((snapshot) {
          flowers.add(snapshot.val());
        });

        expect(flowers, isNotNull);
        expect(flowers.length, 1);
        expect(flowers.first, "rose");
      });

      test("limitToFirst", () async {
        var childRef = ref.child("flowers");
        childRef.push("rose");
        childRef.push("tulip");
        childRef.push("chicory");
        childRef.push("sunflower");

        var event = await childRef.orderByValue().limitToFirst(2).once("value");
        var flowers = [];
        event.snapshot.forEach((snapshot) {
          flowers.add(snapshot.val());
        });

        expect(flowers, isNotEmpty);
        expect(flowers.length, 2);
        expect(flowers, contains("chicory"));
        expect(flowers, contains("rose"));
      });

      test("limitToLast", () async {
        var childRef = ref.child("flowers");
        childRef.push("rose");
        childRef.push("tulip");
        childRef.push("chicory");
        childRef.push("sunflower");

        var event = await childRef.orderByValue().limitToLast(1).once("value");
        var flowers = [];
        event.snapshot.forEach((snapshot) {
          flowers.add(snapshot.val());
        });

        expect(flowers, isNotEmpty);
        expect(flowers.length, 1);
        expect(flowers, contains("tulip"));
      });

      test("orderByKey", () async {
        var childRef = ref.child("flowers");
        childRef.child("one").set("rose");
        childRef.child("two").set("tulip");
        childRef.child("three").set("chicory");
        childRef.child("four").set("sunflower");

        var event = await childRef.orderByKey().once("value");
        var flowers = [];
        event.snapshot.forEach((snapshot) {
          flowers.add(snapshot.key);
        });

        expect(flowers, isNotEmpty);
        expect(flowers.length, 4);
        expect(flowers, ["four", "one", "three", "two"]);
      });

      test("orderByValue", () async {
        var childRef = ref.child("flowers");
        childRef.push("rose");
        childRef.push("tulip");
        childRef.push("chicory");
        childRef.push("sunflower");

        var event = await childRef.orderByValue().once("value");
        var flowers = [];
        event.snapshot.forEach((snapshot) {
          flowers.add(snapshot.val());
        });

        expect(flowers, isNotEmpty);
        expect(flowers.length, 4);
        expect(flowers, ["chicory", "rose", "sunflower", "tulip"]);
      });
    });
  });
}
