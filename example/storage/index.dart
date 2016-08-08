library firebase3.example.storage;

import 'dart:html';
import 'package:firebase3/firebase.dart' as firebase;
import 'package:firebase3/storage.dart' as firebase_storage;

// Update firebase.initializeApp() with information from your project.
// See <https://firebase.google.com/docs/web/setup>.
void main() {
  firebase.initializeApp(
      apiKey: "TODO",
      authDomain: "TODO",
      databaseURL: "TODO",
      storageBucket: "TODO");

  new ImageUploadApp();
}

class ImageUploadApp {
  firebase_storage.Storage storage;
  firebase_storage.StorageReference ref;
  HtmlElement uploadForm, uploadImage;

  ImageUploadApp() {
    this.storage = firebase.storage();
    this.ref = storage.ref("images");
    this.uploadForm = querySelector("#upload_form");
    this.uploadImage = querySelector("#upload_image");

    this.uploadImage.onChange.listen((e) {
      e.preventDefault();
      var file = e.target.files[0];

      firebase_storage.UploadTask uploadTask = this
          .ref
          .child(file.name)
          .put(file, new firebase_storage.UploadMetadata(contentType: file.type));
      uploadTask
        ..onStateChanged.listen((e) {
          var snapshot = e.snapshot;
          querySelector("#message").text =
              "Transfered ${snapshot.bytesTransferred}/${snapshot.totalBytes}...";
        })
        ..then((snapshot) {
          var filePath = snapshot.downloadURL;
          var image = new ImageElement(src: filePath);
          document.body.append(image);
          querySelector("#message").text = "";
        }).catchError((e) => print(e.code));
    });

    this.uploadForm.onSubmit.listen((e) {
      e.preventDefault();
      this.uploadImage.click();
    });
  }
}
