import 'dart:html';

import 'package:_shared_assets/assets.dart';
import 'package:firebase/firebase.dart' as fb;

Future<void> main() async {
  //Use for firebase package development only
  await config();

  try {
    fb.initializeApp(
        apiKey: apiKey,
        authDomain: authDomain,
        databaseURL: databaseUrl,
        storageBucket: storageBucket);

    ImageUploadApp();
  } on fb.FirebaseJsNotLoadedException catch (e) {
    print(e);
  }
}

class ImageUploadApp {
  final fb.StorageReference ref;
  final InputElement _uploadImage;

  ImageUploadApp()
      : ref = fb.storage().ref('pkg_firebase/examples/storage'),
        _uploadImage = querySelector('#upload_image') as InputElement {
    _uploadImage.disabled = false;

    _uploadImage.onChange.listen((e) async {
      e.preventDefault();
      final file = (e.target as FileUploadInputElement).files![0];

      final customMetadata = {'location': 'Prague', 'owner': 'You'};
      final uploadTask = ref.child(file.name).put(
          file,
          fb.UploadMetadata(
              contentType: file.type, customMetadata: customMetadata));
      uploadTask.onStateChanged.listen((e) {
        querySelector('#message')!.text =
            'Transfered ${e.bytesTransferred}/${e.totalBytes}...';
      });

      try {
        final snapshot = await uploadTask.future;
        final filePath = await snapshot.ref.getDownloadURL();
        final image = ImageElement(src: filePath.toString());
        document.body!.append(image);
        final metadata = snapshot.metadata.customMetadata;
        querySelector('#message')!.text = 'Metadata: ${metadata.toString()}';
      } catch (e) {
        print(e);
      }
    });
  }
}
