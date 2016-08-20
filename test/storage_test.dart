@TestOn('browser')
import 'dart:convert';

import 'package:firebase3/firebase.dart';
import 'package:firebase3/src/assets/assets.dart';
import 'package:test/test.dart';

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
    test('put, getDownloadURL, custom metadata', () async {
      var storage = app.storage();

      var fileName = 'storage_test.json';
      var ref = storage.ref(fileName);
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
      expect(md.fullPath, fileName);
      expect(md.size, 7);
      expect(md.contentType, 'application/json');
      expect(md.timeCreated, md.updated);
      expect(md.downloadURLs.single, contains(fileName));
      expect(md.downloadURLs.single, contains(storageBucket));
      expect(md.customMetadata, isNotNull);
      expect(md.customMetadata['the answer'], '42');

      var downloadUrl = await ref.getDownloadURL();

      expect(downloadUrl, contains(storageBucket));
      expect(downloadUrl, md.downloadURLs.single);
    });
  });
}
