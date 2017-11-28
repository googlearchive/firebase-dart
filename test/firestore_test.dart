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

    group("CollectionReference", () {
      fs.CollectionReference ref;

      setUp(() {
        ref = firestore.collection("messages");
      });

      tearDown(() async {
        // TODO delete collection - more complicated
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
        var docRef = ref.doc("mes1");

        expect(docRef, isNotNull);
        expect(docRef.id, "mes1");
        expect(docRef.parent.id, ref.id);
      });

      test("get document in collection", () {
        var docRef = ref.doc("mes2");
        var docRefSecond = firestore.doc("messages/mes2");
        expect(docRefSecond, isNotNull);
        expect(docRefSecond.id, docRef.id);
      });

      /*test("set document", () {
        ref.doc("mes1").set({"text": "Hi!"});
      });*/
    });
  });
}
