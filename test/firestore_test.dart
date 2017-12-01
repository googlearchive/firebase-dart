@TestOn('browser')
import 'dart:async';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firebase_firestore.dart' as fs;
import 'package:firebase/src/assets/assets.dart';
import 'package:test/test.dart';
import 'test_util.dart';

// Delete entire collection
// <https://firebase.google.com/docs/firestore/manage-data/delete-data#collections>
Future _deleteCollection(db, collectionRef, batchSize) {
  Completer completer = new Completer();

  var query = collectionRef.orderBy('__name__').limit(batchSize);
  _deleteQueryBatch(db, query, batchSize, completer);

  return completer.future;
}

_deleteQueryBatch(db, query, batchSize, completer) async {
  try {
    var snapshot = await query.get();

    // When there are no documents left, we are done
    if (snapshot.size == 0) {
      completer.complete();
      return;
    }

    // Delete documents in a batch
    var batch = db.batch();
    snapshot.docs.forEach((doc) => batch.delete(doc.ref));
    await batch.commit();

    var numDeleted = snapshot.size;
    if (numDeleted <= batchSize) {
      completer.complete();
      return;
    }

    // Recurse with delay, to avoid exploding the stack.
    new Future.delayed(const Duration(milliseconds: 10),
        () => _deleteQueryBatch(db, query, batchSize, completer));
  } catch (e) {
    print(e);
    completer.completeError(e);
  }
}

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

      tearDown(() async {
        if (ref != null) {
          await _deleteCollection(firestore, ref, 4);
          ref = null;
        }
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

      tearDown(() async {
        if (ref != null) {
          await _deleteCollection(firestore, ref, 4);
          ref = null;
        }
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
          "dateExample": new DateTime.now().toIso8601String(),
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

      test("transaction fails", () async {
        // update is before get -> transaction fails
        var docRef = ref.doc("message7");
        await docRef.set({"text": "Hi"});

        expect(firestore.runTransaction((transaction) async {
          transaction.update(docRef, {"text": "Some value"});
          await transaction.get(docRef);
        }),
            throwsToString(
                contains('Transactions lookups are invalid after writes.')));
      });

      test("WriteBatch operations", () async {
        ref = firestore.collection("cities");
        var nycRef = ref.doc("NYC");
        await nycRef.set({"name": "NYC"});
        var sfRef = ref.doc("SF");
        await sfRef.set({"name": "SF", "population": 0});
        var laRef = ref.doc("LA");
        await laRef.set({"name": "LA"});

        var collectionSnapshot = await ref.get();
        expect(collectionSnapshot.size, 3);

        var batch = firestore.batch();
        batch.set(nycRef, {"name": "New York"});
        batch.update(sfRef, {"population": 1000000});
        batch.delete(laRef);
        await batch.commit();

        var snapshot = await nycRef.get();
        var snapshotData = snapshot.data();
        expect(snapshotData["name"], "New York");

        snapshot = await sfRef.get();
        snapshotData = snapshot.data();
        expect(snapshotData["population"], 1000000);

        collectionSnapshot = await ref.get();
        expect(collectionSnapshot.size, 2);
      });

      /*test("delete", () async {
        ref = firestore.collection("flowers");
        await ref.doc("DC").set({"name": "DC"});

        await ref.doc("DC").delete();

        var collectionSnapshot = await ref.get();
        print(collectionSnapshot.docs);
        expect(collectionSnapshot.empty, isTrue);
      });*/

      // TODO finish delete!!!!
      // https://firebase.google.com/docs/firestore/manage-data/delete-data#top_of_page
    });

    group("Quering data", () {
      fs.CollectionReference ref;

      setUp(() async {
        ref = firestore.collection("messages");

        await _deleteCollection(firestore, ref, 4);

        await ref
            .doc("message1")
            .set({"text": "hello", "lang": "en", "new": true});
        await ref.doc("message2").set({
          "text": "hi",
          "lang": "en",
          "description": {"text": "description text"}
        });
        await ref
            .doc("message3")
            .set({"text": "ahoj", "lang": "cs", "new": true});
        await ref.doc("message4").set({"text": "cau", "lang": "cs"});
      });

      tearDown(() async {
        if (ref != null) {
          await _deleteCollection(firestore, ref, 4);
          ref = null;
        }
      });

      test("get document data", () async {
        var docRef = ref.doc("message1");
        var snapshot = await docRef.get();
        expect(snapshot, isNotNull);
        expect(snapshot.exists, isTrue);

        var data = snapshot.data();
        expect(data, isNotNull);
        expect(data["text"], "hello");
      });

      test("get nonexistent document", () async {
        var docRef = ref.doc("message0");
        var snapshot = await docRef.get();
        expect(snapshot.exists, isFalse);
      });

      test("get documents where", () async {
        var snapshot = await ref.where("new", "==", true).get();
        expect(snapshot.size, 2);
      });

      test("get documents where with FieldPath", () async {
        var snapshot =
            await ref.where(new fs.FieldPath("new"), "==", true).get();
        expect(snapshot.size, 2);
      });

      test("get documents using compound query", () async {
        var snapshot = await ref
            .where("new", "==", true)
            .where("text", "==", "hello")
            .get();
        expect(snapshot.size, 1);
        expect(snapshot.docs.length, 1);
        expect(snapshot.docs[0].data()["text"], "hello");
      });

      test("get all documents", () async {
        var snapshot = await ref.get();
        expect(snapshot.size, 4);
        expect(snapshot.docs, isNotEmpty);
        expect(snapshot.docs.length, snapshot.size);
        expect(snapshot.docs[0].data()["text"],
            anyOf("hello", "hi", "ahoj", "cau"));
      });

      // TODO onSnapshot
      // https://firebase.google.com/docs/firestore/query-data/listen

      test("order by", () async {
        var snapshot = await ref.orderBy("text").get();

        expect(snapshot.size, 4);
        expect(snapshot.docs[0].data()["text"], "ahoj");
        expect(snapshot.docs[3].data()["text"], "hi");

        snapshot = await ref.orderBy("text", "desc").get();

        expect(snapshot.size, 4);
        expect(snapshot.docs[0].data()["text"], "hi");
        expect(snapshot.docs[3].data()["text"], "ahoj");
      });

      test("limit", () async {
        var snapshot = await ref.get();
        expect(snapshot.size, 4);

        snapshot = await ref.limit(2).get();
        expect(snapshot.size, 2);
      });

      test("get documents where with limit", () async {
        var snapshot = await ref.where("new", "==", true).limit(1).get();
        expect(snapshot.size, 1);
      });

      // !!!IMPORTANT: You need to build index for lang and text under messages
      // collection to be able to run these tests.
      // (You can do this in Firebase console)
      test("startAt", () async {
        var snapshot = await ref
            .orderBy("lang")
            .orderBy("text")
            .startAt(fields: ["cs", "cau"]).get();
        expect(snapshot.size, 3);
        expect(snapshot.docs[0].data()["text"], "cau");
        expect(snapshot.docs[2].data()["text"], "hi");

        snapshot = await ref.orderBy("description").startAt(fields: [
          {"text": "description text"}
        ]).get();

        expect(snapshot.size, 1);
        expect(snapshot.docs[0].data()["description"],
            {"text": "description text"});

        var message2Snapshot = await ref.doc("message2").get();
        snapshot =
            await ref.orderBy("text").startAt(snapshot: message2Snapshot).get();

        // message2 text = "hi" => it is the last one
        expect(snapshot.size, 1);
        expect(snapshot.docs[0].data()["text"], "hi");
      });

      test("startAfter", () async {
        var snapshot = await ref
            .orderBy("lang")
            .orderBy("text")
            .startAfter(fields: ["cs", "cau"]).get();
        expect(snapshot.size, 2);
        expect(snapshot.docs[0].data()["text"], "hello");
        expect(snapshot.docs[1].data()["text"], "hi");

        snapshot = await ref.orderBy("description").startAfter(fields: [
          {"text": "description text"}
        ]).get();

        expect(snapshot.empty, isTrue);

        var message2Snapshot = await ref.doc("message2").get();
        snapshot =
        await ref.orderBy("text").startAfter(snapshot: message2Snapshot).get();

        // message2 text = "hi"
        expect(snapshot.empty, isTrue);
      });

      test("endBefore", () async {
        var snapshot = await ref
            .orderBy("lang")
            .orderBy("text")
            .endBefore(fields: ["en", "hello"]).get();
        expect(snapshot.size, 2);
        expect(snapshot.docs[0].data()["text"], "ahoj");
        expect(snapshot.docs[1].data()["text"], "cau");

        snapshot = await ref.orderBy("description").endBefore(fields: [
          {"text": "description text"}
        ]).get();

        expect(snapshot.empty, isTrue);

        var message2Snapshot = await ref.doc("message2").get();
        snapshot =
        await ref.orderBy("text").endBefore(snapshot: message2Snapshot).get();

        // message2 text = "hi"
        expect(snapshot.size, 3);
        expect(snapshot.docs[0].data()["text"], "ahoj");
        expect(snapshot.docs[2].data()["text"], "hello");
      });

      test("endAt", () async {
        var snapshot = await ref
            .orderBy("lang")
            .orderBy("text")
            .endAt(fields: ["en", "hello"]).get();
        expect(snapshot.size, 3);
        expect(snapshot.docs[0].data()["text"], "ahoj");
        expect(snapshot.docs[2].data()["text"], "hello");

        snapshot = await ref.orderBy("description").endAt(fields: [
          {"text": "description text"}
        ]).get();

        expect(snapshot.size, 1);
        expect(snapshot.docs[0].data()["description"],
            {"text": "description text"});

        var message2Snapshot = await ref.doc("message2").get();
        snapshot =
        await ref.orderBy("text").endAt(snapshot: message2Snapshot).get();

        // message2 text = "hi"
        expect(snapshot.size, 4);
        expect(snapshot.docs[0].data()["text"], "ahoj");
        expect(snapshot.docs[3].data()["text"], "hi");
      });
    });
  });
}
