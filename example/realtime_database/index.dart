library firebase3.example.realtime_database;

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

  new MessagesApp().showMessages();
}

class MessagesApp {
  fb.Database database;
  fb.DatabaseReference ref;
  UListElement messages;
  InputElement newMessage;
  InputElement submit;
  FormElement newMessageForm;

  MessagesApp() {
    this.database = fb.database();
    this.ref = database.ref("messages");
    this.messages = querySelector("#messages");
    this.newMessage = querySelector("#new_message");
    newMessage.disabled = false;

    this.submit = querySelector('#submit');
    submit.disabled = false;

    this.newMessageForm = querySelector("#new_message_form");
    this.newMessageForm.onSubmit.listen((e) async {
      e.preventDefault();

      if (newMessage.value.trim().isNotEmpty) {
        var map = {"text": newMessage.value};

        try {
          await ref.push(map).future;
          newMessage.value = "";
        } catch (e) {
          print("Error while writing to db, $e");
        }
      }
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

  _deleteItem(fb.DataSnapshot datasnapshot) async {
    try {
      await this.ref.child(datasnapshot.key).remove();
    } catch (e) {
      print("Error while deleting item, $e");
    }
  }

  _uppercaseItem(fb.DataSnapshot datasnapshot) async {
    var value = datasnapshot.val();
    var valueUppercase = value["text"].toString().toUpperCase();
    value["text"] = valueUppercase;

    try {
      await this.ref.child(datasnapshot.key).update(value);
    } catch (e) {
      print("Error while updating item, $e");
    }
  }
}
