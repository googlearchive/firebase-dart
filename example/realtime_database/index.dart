library firebase3.example.realtime_database;

import 'dart:html';
import 'package:firebase3/firebase.dart' as firebase;
import 'package:firebase3/database.dart';

// Update firebase.initializeApp() with information from your project.
// See <https://firebase.google.com/docs/web/setup>.
void main() {
  firebase.initializeApp(
      apiKey: "TODO",
      authDomain: "TODO",
      databaseURL: "TODO",
      storageBucket: "TODO");

  new MessagesApp()..showMessages();
}

class MessagesApp {
  Database database;
  DatabaseReference ref;
  UListElement messages;
  InputElement newMessage;
  FormElement newMessageForm;

  MessagesApp() {
    this.database = firebase.database();
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
      DataSnapshot datasnapshot = e.snapshot;

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
      DataSnapshot datasnapshot = e.snapshot;
      var element = querySelector("#${datasnapshot.key} span");

      if (element != null) {
        element.text = datasnapshot.val()["text"];
      }
    });

    this.ref.onChildRemoved.listen((e) {
      DataSnapshot datasnapshot = e.snapshot;

      var element = querySelector("#${datasnapshot.key}");

      if (element != null) {
        element.remove();
      }
    });
  }

  void _deleteItem(DataSnapshot datasnapshot) {
    this
        .ref
        .child(datasnapshot.key)
        .remove()
        .catchError((e) => print("Error while deleting item, $e"));
  }

  void _uppercaseItem(DataSnapshot datasnapshot) {
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
