library firebase3.example.storage;

import 'dart:html';

import 'package:firebase3/firebase.dart' as fb;
import 'package:firebase3/src/assets/assets.dart';

// Update firebase.initializeApp() with information from your project.
// See <https://firebase.google.com/docs/web/setup>.
main() async {
  //Use for firebase3 package development only
  await config();

  var app = fb.initializeApp(
      apiKey: apiKey,
      authDomain: authDomain,
      databaseURL: databaseUrl,
      storageBucket: storageBucket);

  app.auth().signInAnonymously();

  new ImageUploadApp();
}

class ImageUploadApp {
  fb.Storage storage;
  fb.StorageReference ref;
  InputElement _uploadImage;

  ImageUploadApp() {
    storage = fb.storage();
    ref = storage.ref("images");
    _uploadImage = querySelector("#upload_image");
    _uploadImage.disabled = false;

    _uploadImage.onChange.listen((e) async {
      e.preventDefault();
      var file = (e.target as FileUploadInputElement).files[0];

      var customMetadata = {"location": "Prague", "owner": "You"};
      var uploadTask = ref.child(file.name).put(
          file,
          new fb.UploadMetadata(
              contentType: file.type, customMetadata: customMetadata));
      uploadTask.onStateChanged.listen((e) {
        var snapshot = e.snapshot;
        querySelector("#message").text =
            "Transfered ${snapshot.bytesTransferred}/${snapshot.totalBytes}...";
      });

      try {
        var snapshot = await uploadTask.future;
        var filePath = snapshot.downloadURL;
        var metadata = snapshot.metadata.customMetadata;
        var image = new ImageElement(src: filePath);
        document.body.append(image);
        querySelector("#message").text = "Metadata: ${metadata.toString()}";
      } catch (e) {
        print(e);
      }
    });
  }
}
