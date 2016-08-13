library firebase3.example.realtime_database;

import 'dart:html';
import 'package:firebase3/firebase.dart' as fb;
import 'package:firebase3/src/assets/assets.dart';

// Update firebase.initializeApp() with information from your project.
// See <https://firebase.google.com/docs/web/setup>.
main() async {
  await config();

  var app = fb.initializeApp(
      apiKey: apiKey,
      authDomain: authDomain,
      databaseURL: databaseUrl,
      storageBucket: storageBucket);

  await app.auth().signInAnonymously();

  new MessagesApp()..showMessages();
}

class MessagesApp {
  fb.Database database;
  fb.DatabaseReference ref;
  UListElement messages;
  InputElement newMessage;
  FormElement newMessageForm;

  MessagesApp() {
    this.database = fb.database();
    this.ref = database.ref("messages");
    this.messages = querySelector("#messages");
    this.newMessage = querySelector("#new_message");

    this.newMessageForm = querySelector("#new_message_form");
    this.newMessageForm.onSubmit.listen((e) {
      e.preventDefault();
      var map = {"text": newMessage.value};
      this
          .ref
          .push(map)
          .then((_) => newMessage.value = "")
          .catchError((e) => print("Error while writing to db, $e"));
    });
  }

  void showMessages() {
    this.ref.onChildAdded.listen((e) {
      fb.DataSnapshot datasnapshot = e.snapshot;

      var spanElement = new SpanElement()..text = datasnapshot.val()["text"];

      var aElementDelete = new AnchorElement(href: "#")
        ..text = "Delete"
        ..onClick.listen((e) {
          e.preventDefault();
          _deleteItem(datasnapshot);
        });

      var aElementUpdate = new AnchorElement(href: "#")
        ..text = "To Uppercase"
        ..onClick.listen((e) {
          e.preventDefault();
          _uppercaseItem(datasnapshot);
        });

      var element = new LIElement()
        ..id = datasnapshot.key
        ..append(spanElement)
        ..append(aElementDelete)
        ..append(aElementUpdate);
      messages.append(element);
    });

    this.ref.onChildChanged.listen((e) {
      fb.DataSnapshot datasnapshot = e.snapshot;
      var element = querySelector("#${datasnapshot.key} span");

      if (element != null) {
        element.text = datasnapshot.val()["text"];
      }
    });

    this.ref.onChildRemoved.listen((e) {
      fb.DataSnapshot datasnapshot = e.snapshot;

      var element = querySelector("#${datasnapshot.key}");

      if (element != null) {
        element.remove();
      }
    });
  }

  void _deleteItem(fb.DataSnapshot datasnapshot) {
    this
        .ref
        .child(datasnapshot.key)
        .remove()
        .catchError((e) => print("Error while deleting item, $e"));
  }

  void _uppercaseItem(fb.DataSnapshot datasnapshot) {
    var value = datasnapshot.val();
    var valueUppercase = value["text"].toString().toUpperCase();
    value["text"] = valueUppercase;
    this
        .ref
        .child(datasnapshot.key)
        .update(value)
        .catchError((e) => print("Error while updating item, $e"));
  }
}
