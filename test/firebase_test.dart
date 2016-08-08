import 'package:test/test.dart';
import 'package:firebase3/firebase.dart' as firebase;

// Update constants with information from your project.
// See <https://firebase.google.com/docs/web/setup>.
const API_KEY = "TODO";
const AUTH_DOMAIN = "TODO";
const DATABASE_URL = "TODO";
const STORAGE_BUCKET = "TODO";

void main() {
  var app = firebase.initializeApp(
      apiKey: API_KEY,
      authDomain: AUTH_DOMAIN,
      databaseURL: DATABASE_URL,
      storageBucket: STORAGE_BUCKET);

  group("App", () {
    test("Exists", () {
      expect(app, isNotNull);
      expect(firebase.app(), isNotNull);
      expect(firebase.apps.first.name, app.name);
    });

    test("Is [DEFAULT]", () {
      expect(app.name, "[DEFAULT]");
    });

    test("Has options", () {
      expect(app.options, isNotNull);
      expect(app.options.apiKey, API_KEY);
      expect(app.options.storageBucket, STORAGE_BUCKET);
      expect(app.options.authDomain, AUTH_DOMAIN);
      expect(app.options.databaseURL, DATABASE_URL);
    });

    test("Can be created with name", () {
      var app2 = firebase.initializeApp(
          apiKey: API_KEY,
          authDomain: AUTH_DOMAIN,
          databaseURL: DATABASE_URL,
          storageBucket: STORAGE_BUCKET,
          name: "MySuperApp");

      expect(app2, isNotNull);
      expect(firebase.app("MySuperApp"), isNotNull);
      expect(app2.name, "MySuperApp");
      expect(firebase.apps.length, 2); //[DEFAULT] and MySuperApp
    });

    test("Can be deleted", () {
      firebase.initializeApp(
          apiKey: API_KEY,
          authDomain: AUTH_DOMAIN,
          databaseURL: DATABASE_URL,
          storageBucket: STORAGE_BUCKET,
          name: "MyDeletedApp");

      expect(firebase.app("MyDeletedApp"), isNotNull);
      expect(firebase.apps.where((app) => app.name == "MyDeletedApp").toList(),
          isNotEmpty);

      firebase.app("MyDeletedApp").delete().then(expectAsync((_) {
        expect(
            firebase.apps.where((app) => app.name == "MyDeletedApp").toList(),
            isEmpty);
      }));
    });

    test("Get database", () {
      expect(app.database(), isNotNull);
    });

    test("Get Auth", () {
      expect(app.auth(), isNotNull);
    });

    test("Get storage", () {
      expect(app.storage(), isNotNull);
    });
  });

  group("Firebase", () {
    test("SDK version", () {
      expect(firebase.SDK_VERSION, startsWith("3."));
    });
  });
}
