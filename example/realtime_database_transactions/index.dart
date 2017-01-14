import 'dart:html';

import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/src/assets/assets.dart';

main() async {
  // Use for firebase package development only
  await config();

  fb.initializeApp(
      apiKey: apiKey,
      authDomain: authDomain,
      databaseURL: databaseUrl,
      storageBucket: storageBucket);

  new MessagesApp().showMessages();
}

// This version of MessagesApp uses transaction() method
// for all updates on the data.
class MessagesApp {
  final fb.DatabaseReference ref;
  final UListElement messages;
  final InputElement newMessage;
  final InputElement submit;
  final FormElement newMessageForm;

  MessagesApp()
      : ref = fb.database().ref("pkg_firebase/examples/database_transaction"),
        messages = querySelector("#messages"),
        newMessage = querySelector("#new_message"),
        submit = querySelector('#submit'),
        newMessageForm = querySelector("#new_message_form") {
    newMessage.disabled = false;

    submit.disabled = false;

    this.newMessageForm.onSubmit.listen((e) async {
      e.preventDefault();

      if (newMessage.value.trim().isNotEmpty) {
        var map = {"text": newMessage.value};

        try {
          var childRef = ref.push();
          // Push of data via transaction
          await childRef.transaction((_) => map);
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
      // transaction((_) => null) doesn't work when compiled to JS
      // probably because of https://github.com/dart-lang/sdk/issues/24088
      await this.ref.child(datasnapshot.key).transaction((_) => {});
    } catch (e) {
      print("Error while deleting item, $e");
    }
  }

  _uppercaseItem(fb.DataSnapshot datasnapshot) async {
    try {
      // update data in transaction - e.g. take prev value,
      // update it and return it.
      await this.ref.child(datasnapshot.key).transaction(
          (prevValue) => {"text": prevValue["text"].toUpperCase()});
    } catch (e) {
      print("Error while updating item, $e");
    }
  }
}
