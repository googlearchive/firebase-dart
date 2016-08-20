@TestOn('browser')
import 'dart:convert';

import 'package:firebase3/firebase.dart';
import 'package:firebase3/src/assets/assets.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

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

  group('Reference', () {
    final pathPrefix = validDatePath();
    final fileName = 'storage_test.json';
    final filePath = p.join(pathPrefix, fileName);

    StorageReference ref;

    setUp(() async {
      var storage = app.storage();

      ref = storage.ref(filePath);
      var metadata = new UploadMetadata(
          contentType: r'application/json',
          customMetadata: {'the answer': '42'});
      var bytes = new JsonUtf8Encoder().convert([1, 2, 3]);

      var upload = ref.put(bytes, metadata);
      var snapShot = await upload.future;

      expect(snapShot.bytesTransferred, 7);
      expect(snapShot.downloadURL, contains(fileName));
      expect(snapShot.state, TaskState.SUCCESS);

      var md = snapShot.metadata;
      expect(md.bucket, storageBucket);
      expect(md.name, fileName);
      expect(md.fullPath, filePath);
      expect(md.size, 7);
      expect(md.contentType, 'application/json');
      expect(md.timeCreated, md.updated);
      expect(md.downloadURLs.single, contains(fileName));
      expect(md.downloadURLs.single, contains(storageBucket));
      expect(md.customMetadata, isNotNull);
      expect(md.customMetadata['the answer'], '42');
    });

    tearDown(() async {
      await ref.delete();
      ref = null;
    });

    test('getDownloadURL', () async {
      var downloadUrl = await ref.getDownloadURL();

      var url = Uri.parse(downloadUrl);

      expect(downloadUrl, contains(storageBucket));
      expect(url.pathSegments.last, contains(filePath));
    });

    test('getMetadata', () async {
      var md = await ref.getMetadata();

      expect(md.bucket, storageBucket);
      expect(md.name, fileName);
      expect(md.fullPath, filePath);
      expect(md.size, 7);
      expect(md.contentType, 'application/json');
      expect(md.timeCreated, md.updated);
      expect(md.downloadURLs.single, contains(fileName));
      expect(md.downloadURLs.single, contains(storageBucket));
      expect(md.customMetadata, isNotNull);
      expect(md.customMetadata['the answer'], '42');
    });

    test('updateMetadata', () async {
      var newMetadata = new SettableMetadata(contentType: 'text/plain');

      var md = await ref.updateMetadata(newMetadata);

      expect(md.bucket, storageBucket);
      expect(md.name, fileName);
      expect(md.fullPath, filePath);
      expect(md.size, 7);
      expect(md.contentType, 'text/plain');
      var createdTime = DateTime.parse(md.timeCreated);
      var updatedTime = DateTime.parse(md.updated);

      expect(updatedTime.isAfter(createdTime), isTrue);
      expect(md.downloadURLs.single, contains(fileName));
      expect(md.downloadURLs.single, contains(storageBucket));
      expect(md.customMetadata, isNull);
    });
  });
}
