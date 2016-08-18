@TestOn('browser')
import 'package:firebase3/firebase.dart' as fb;
import 'package:firebase3/src/assets/assets.dart';
import 'package:test/test.dart';

// Update constants with information from your project.
// See <https://firebase.google.com/docs/web/setup>.

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
        storageBucket: storageBucket);
  });

  tearDown(() async {
    if (app != null) {
      await app.delete();
      app = null;
    }
  });

  group('anonymous user', () {
    fb.Auth auth;
    fb.User user;
    setUp(() async {
      auth = fb.auth();
      expect(auth.currentUser, isNull);

      try {
        user = await auth.signInAnonymously();
      } on fb.FirebaseError catch (e) {
        print([e.name, e.code, e.message, e.stack]
            .where((s) => s != null)
            .join('\n'));
        rethrow;
      }
    });

    test('properties', () {
      expect(user.isAnonymous, isTrue);
      expect(user.emailVerified, isFalse);
      expect(user.providerData, isEmpty);
      expect(user.providerId, 'firebase');
    });

    test('delete', () async {
      await user.delete();
      expect(auth.currentUser, isNull);

      try {
        await user.delete();
        fail('user.delete should throw');
      } on fb.FirebaseError catch (e) {
        expect(e.code, 'auth/app-deleted');
      } catch (e) {
        fail('Should have been a FirebaseError');
      }
    });
  });
}
