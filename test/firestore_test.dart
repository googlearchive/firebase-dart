@TestOn('browser')
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firebase_firestore.dart' as fs;
import 'package:firebase/src/assets/assets.dart';
import 'package:test/test.dart';

void main() {
  fb.App app;

  setUpAll(() async {
    await config();
  });

  setUp(() async {
    app = fb.initializeApp(
        apiKey: apiKey,
        authDomain: authDomain,
        databaseURL: databaseUrl,
        projectId: projectId,
        storageBucket: storageBucket);
  });

  tearDown(() async {
    if (app != null) {
      await app.delete();
      app = null;
    }
  });

  group("Firestore", () {
    fs.Firestore firestore;

    setUp(() {
      firestore = fb.firestore();
    });

    group("instance", () {
      test("App exists", () {
        expect(firestore, isNotNull);
        expect(firestore.app, isNotNull);
        expect(firestore.app.name, fb.app().name);
      });
    });

    group("Collections and documents", () {
      fs.CollectionReference ref;

      setUp(() {
        ref = firestore.collection("messages");
      });

      tearDown(() {
        // TODO delete collection - more complicated
        // TODO delete subcollections
        ref = null;
      });

      test("collection exists", () {
        expect(ref, isNotNull);
        expect(ref.id, "messages");
      });

      test("create document with auto generated ID", () {
        var docRef = ref.doc();

        expect(docRef, isNotNull);
        expect(docRef.id, isNotEmpty);
      });

      test("create document", () {
        var docRef = ref.doc("message1");

        expect(docRef, isNotNull);
        expect(docRef.id, "message1");
        expect(docRef.parent.id, ref.id);
      });

      test("get document in collection", () {
        var docRef = ref.doc("message2");
        var docRefSecond = firestore.doc("messages/message2");
        expect(docRefSecond, isNotNull);
        expect(docRefSecond.id, docRef.id);
      });

      test("get document in collection of document", () {
        var docRef = ref.doc("message3").collection("words").doc("word1");
        expect(docRef, isNotNull);
        expect(docRef.id, "word1");
      });

      test("collection path", () {
        var collectionRef = firestore.collection("messages/message4/words");
        expect(collectionRef, isNotNull);
        expect(collectionRef.id, "words");
        expect(collectionRef.parent.id, "message4");
      });
    });

    group("DocumentReference", () {
      fs.CollectionReference ref;

      setUp(() {
        ref = firestore.collection("messages");
      });

      tearDown(() {
        // TODO delete collection - more complicated
        // TODO delete subcollections
        ref = null;
      });

      test("set document", () async {
        var docRef = ref.doc("message1");
        await docRef.set({"text": "Hi!"});

        var snapshot = await docRef.get();
        expect(snapshot.id, "message1");
        expect(snapshot.exists, true);
      });

      test("set overwrites document", () async {
        var docRef = ref.doc("message2");

        await docRef.set({"text": "Message2"});
        var snapshot = await docRef.get();
        var snapshotData = snapshot.data();

        expect(snapshotData, new isInstanceOf<Map>());
        expect(snapshotData["text"], "Message2");

        await docRef.set({"title": "Ahoj"});
        snapshot = await docRef.get();
        snapshotData = snapshot.data();

        expect(snapshotData["text"], isNull);
        expect(snapshotData["title"], "Ahoj");
      });

      test("set with merge", () async {
        var docRef = ref.doc("message3");

        await docRef.set({"text": "Message3"});
        var snapshot = await docRef.get();
        var snapshotData = snapshot.data();

        await docRef.set({"text": "MessageNew", "title": "Ahoj"},
            new fs.SetOptions(merge: true));
        snapshot = await docRef.get();
        snapshotData = snapshot.data();

        expect(snapshotData["text"], "MessageNew");
        expect(snapshotData["title"], "Ahoj");
      });

      test("set various types", () async {
        var docRef = ref.doc("message4");

        var map = {
          "stringExample": "Hello world!",
          "booleanExample": true,
          "numberExample": 3.14159265,
          "dateExample": new DateTime.now(),
          "arrayExample": [5, true, "hello"],
          "nullExample": null,
          "mapExample": {
            "a": 5,
            "b": {"nested": "foo"}
          }
        };

        await docRef.set(map);
        var snapshot = await docRef.get();
        var snapshotData = snapshot.data();

        expect(snapshotData["stringExample"], map["stringExample"]);
        expect(snapshotData["booleanExample"], map["booleanExample"]);
        expect(snapshotData["numberExample"], map["numberExample"]);
        expect(snapshotData["dateExample"], isNotNull); // different format
        expect(snapshotData["arrayExample"], map["arrayExample"]);
        expect(snapshotData["nullExample"], map["nullExample"]);
        expect(snapshotData["mapExample"], map["mapExample"]);
      });

      test("add document", () async {
        var docRef = await ref.add({"text": "MessageAdd"});

        expect(docRef, isNotNull);
        expect(docRef.id, isNotNull);
        expect(docRef.parent.id, ref.id);
      });

      test("update document with Map", () async {
        var docRef = await ref.add({"text": "Ahoj"});
        await docRef.update({"text": "Ahoj2"});

        var snapshot = await docRef.get();
        var snapshotData = snapshot.data();

        expect(snapshotData["text"], "Ahoj2");

        await docRef.update({"text": "Ahoj", "text_en": "Hi"});

        snapshot = await docRef.get();
        snapshotData = snapshot.data();

        expect(snapshotData["text"], "Ahoj");
        expect(snapshotData["text_en"], "Hi");
      });

      test("update with serverTimestamp", () async {
        var docRef = await ref.add({"text": "Good night"});
        await docRef.update({"timestamp": fs.FieldValue.serverTimestamp()});

        var snapshot = await docRef.get();
        var snapshotData = snapshot.data();

        expect(snapshotData["timestamp"], isNotNull);
      });

      test("update nested with dot notation", () async {
        var docRef = await ref.add({
          "greeting": {"text": "Good Morning"}
        });
        await docRef.update({"greeting.text": "Good Morning after update"});

        var snapshot = await docRef.get();
        var snapshotData = snapshot.data();

        expect(snapshotData["greeting"]["text"], "Good Morning after update");
      });

      test("transaction", () async {
        var docRef = ref.doc("message5");
        await docRef.set({"text": "Hi"});

        await firestore.runTransaction((transaction) async {
          transaction.update(docRef, {"text": "Hi from transaction"});
        });

        var snapshot = await docRef.get();
        var snapshotData = snapshot.data();

        expect(snapshotData["text"], "Hi from transaction");
      });

      test("transaction returns updated value", () async {
        var docRef = ref.doc("message6");
        await docRef.set({"text": "Hi"});

        var newValue = await firestore.runTransaction((transaction) async {
          var documentSnapshot = await transaction.get(docRef);
          var value = documentSnapshot.data()["text"] + " val from transaction";
          transaction.update(docRef, {"text": value});
          return value;
        });

        expect(newValue, "Hi val from transaction");

        var snapshot = await docRef.get();
        var snapshotData = snapshot.data();

        expect(snapshotData["text"], newValue);
      });
    });
  });
}
