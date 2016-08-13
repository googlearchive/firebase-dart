@TestOn('browser')
import 'dart:convert';

import 'package:firebase3/app.dart';
import 'package:firebase3/firebase.dart' as firebase;
import 'package:http/browser_client.dart' as http;
import 'package:test/test.dart';

// Update constants with information from your project.
// See <https://firebase.google.com/docs/web/setup>.

void main() {
  group("App", () {
    String apiKey, authDomain, databaseUrl, storageBucket;

    setUpAll(() async {
      var client = new http.BrowserClient();
      Map<String, String> config;

      try {
        var jsonString = (await client.get('config.json')).body;
        config = JSON.decode(jsonString) as Map<String, String>;
      } catch (e) {
        print("Error getting `config.json`. Make sure it exists.");
        rethrow;
      } finally {
        client.close();
      }

      apiKey = config['API_KEY'];
      authDomain = config['AUTH_DOMAIN'];
      databaseUrl = config['DATABASE_URL'];
      storageBucket = config['STORAGE_BUCKET'];
    });

    group('instance', () {
      App app;

      setUpAll(() {
        app = firebase.initializeApp(
            apiKey: apiKey,
            authDomain: authDomain,
            databaseURL: databaseUrl,
            storageBucket: storageBucket);
      });

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
        expect(app.options.apiKey, apiKey);
        expect(app.options.storageBucket, storageBucket);
        expect(app.options.authDomain, authDomain);
        expect(app.options.databaseURL, databaseUrl);
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

    test("Can be created with name", () {
      var app2 = firebase.initializeApp(
          apiKey: apiKey,
          authDomain: authDomain,
          databaseURL: databaseUrl,
          storageBucket: storageBucket,
          name: "MySuperApp");

      expect(app2, isNotNull);
      expect(firebase.app("MySuperApp"), isNotNull);
      expect(app2.name, "MySuperApp");
      expect(firebase.apps.length, 2); //[DEFAULT] and MySuperApp
    });

    test("Can be deleted", () {
      firebase.initializeApp(
          apiKey: apiKey,
          authDomain: authDomain,
          databaseURL: databaseUrl,
          storageBucket: storageBucket,
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
  });

  group("Firebase", () {
    test("SDK version", () {
      expect(firebase.SDK_VERSION, startsWith("3."));
    });
  });
}
