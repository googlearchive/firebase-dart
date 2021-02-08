@TestOn('browser')
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:_shared_assets/assets.dart';
import 'package:firebase/firebase.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import 'test_util.dart';

void main() {
  late App app;

  setUpAll(() async {
    await config();

    app = initializeApp(
      apiKey: apiKey,
      authDomain: authDomain,
      databaseURL: databaseUrl,
      storageBucket: storageBucket,
    );

    addTearDown(app.delete);
  });

  group('Reference', () {
    final pathPrefix = validDatePath();
    const fileName = 'storage_test.json';
    final filePath = p.join(pathPrefix, fileName);

    late StorageReference ref;

    Future<void> doUpload(Object object) async {
      final storage = app.storage();

      addTearDown(ref.delete);

      final metadata = UploadMetadata(
        contentType: r'application/json',
        customMetadata: {'the answer': '42'},
      );

      final upload = ref.put(object, metadata);

      final snapShot = await upload.future;
      ref = storage.ref(filePath);

      expect(snapShot.bytesTransferred, 7);
      expect(snapShot.state, TaskState.SUCCESS);

      final md = snapShot.metadata;
      expect(md.bucket, storageBucket);
      expect(md.name, fileName);
      expect(md.fullPath, filePath);
      expect(md.size, 7);
      expect(md.contentType, 'application/json');
      expect(md.timeCreated, md.updated);
      expect(md.customMetadata, isNotNull);
      expect(md.customMetadata, hasLength(1));
      expect(md.customMetadata, containsPair('the answer', '42'));
      expect(md.md5Hash, '8eRvMo5t7NVsZN1edh3Ctw==');
    }

    group('upload big', () {
      const totalBytes = 1024 * 1024;
      test('success', () async {
        final storage = app.storage();

        ref = storage.ref(filePath);

        final upload = ref.put(Uint8List(totalBytes));

        final sub = upload.onStateChanged.listen((event) {
          expect(event.totalBytes, totalBytes);
          expect(event.state, TaskState.RUNNING);
        });

        addTearDown(sub.cancel);

        final snapShot = await upload.future;
        addTearDown(ref.delete);

        expect(snapShot.totalBytes, totalBytes);
      });

      test('success', () async {
        final storage = app.storage();

        ref = storage.ref(filePath);

        final upload = ref.put(Uint8List(totalBytes));

        var canceled = false;

        final sub = upload.onStateChanged.listen((event) {
          if (canceled) {
            print(['canceled!', event.state]);
          } else {
            expect(event.totalBytes, totalBytes);
            expect(event.state, TaskState.RUNNING);

            canceled = true;
            expect(upload.cancel(), isTrue);
          }
        }, onError: (Object error) {
          expect((error as FirebaseError).code, 'storage/canceled');
        });

        addTearDown(sub.cancel);

        try {
          await upload.future;
          fail('should not get here!');
        } on FirebaseError catch (e) {
          expect(e.code, 'storage/canceled');
        }
      });
    });

    final toEncodeAndSend = jsonEncode([1, 2, 3]);

    test('upload blob', () async {
      final blob = Blob([toEncodeAndSend]);
      await doUpload(blob);
    });

    group('after upload', () {
      setUp(() async {
        final data = utf8.encode(toEncodeAndSend);
        expect(data, isA<Uint8List>());
        await doUpload(data);
      });

      test('getDownloadURL', () async {
        final downloadUrl = await ref.getDownloadURL();

        expect(downloadUrl.toString(), contains(storageBucket));
        expect(downloadUrl.pathSegments.last, contains(filePath));
      });

      test('getMetadata', () async {
        final md = await ref.getMetadata();

        expect(md.bucket, storageBucket);
        expect(md.name, fileName);
        expect(md.fullPath, filePath);
        expect(md.size, 7);
        expect(md.contentType, 'application/json');
        expect(md.timeCreated, md.updated);
        expect(md.customMetadata, isNotNull);
        expect(md.customMetadata!['the answer'], '42');
      });

      test('updateMetadata', () async {
        final newMetadata = SettableMetadata(contentType: 'text/plain');

        final md = await ref.updateMetadata(newMetadata);

        expect(md.bucket, storageBucket);
        expect(md.name, fileName);
        expect(md.fullPath, filePath);
        expect(md.size, 7);
        expect(md.contentType, 'text/plain');
        expect(md.updated.isAfter(md.timeCreated), isTrue);
        expect(md.customMetadata, isNull);
      });
    });
  });

  group('List API', () {
    late StorageReference subfolder;
    late Iterable<StorageReference> refs;

    setUp(() async {
      final storage = app.storage();
      subfolder = storage.ref(validDatePath()).child('sub');
      refs = ['a', 'b', 'c', 'd'].map((n) => subfolder.child(n));
      await Future.wait(refs.map((r) => r.putString('Dartlang <3').future));

      addTearDown(() => Future.wait(refs.map((r) => r.delete())));
    });

    test('paginated list', () async {
      final pageA = await subfolder.list(ListOptions(maxResults: 2));

      expect(pageA.prefixes, hasLength(0));
      expect(pageA.items, hasLength(2));
      expect(pageA.items.map((f) => f.name), containsAllInOrder(['a', 'b']));
      expect(pageA.nextPageToken, isNotNull);

      final pageB = await subfolder
          .list(ListOptions(maxResults: 2, pageToken: pageA.nextPageToken));

      expect(pageB.items, hasLength(2));
      expect(pageB.items.map((f) => f.name), containsAllInOrder(['c', 'd']));
    });

    test('listAll', () async {
      final folder = await subfolder.parent.listAll();

      expect(folder.prefixes, hasLength(1));
      expect(folder.prefixes.first.name, equals('sub'));
      expect(folder.items, hasLength(0));

      final sub = await subfolder.listAll();

      expect(sub.prefixes, hasLength(0));
      expect(sub.items, hasLength(4));
      expect(sub.items.map((f) => f.name),
          containsAllInOrder(['a', 'b', 'c', 'd']));
    });
  });
}
