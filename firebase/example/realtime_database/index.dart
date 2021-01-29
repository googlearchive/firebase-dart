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

    MessagesApp().showMessages();
  } on fb.FirebaseJsNotLoadedException catch (e) {
    print(e);
  }
}

class MessagesApp {
  final fb.DatabaseReference ref;
  final UListElement messages;
  final InputElement newMessage;
  final InputElement submit;
  final FormElement newMessageForm;

  MessagesApp()
      : ref = fb.database().ref('pkg_firebase/examples/database'),
        messages = querySelector('#messages') as UListElement,
        newMessage = querySelector('#new_message') as InputElement,
        submit = querySelector('#submit') as InputElement,
        newMessageForm = querySelector('#new_message_form') as FormElement {
    newMessage.disabled = false;

    submit.disabled = false;

    newMessageForm.onSubmit.listen((e) async {
      e.preventDefault();

      if (newMessage.value!.trim().isNotEmpty) {
        final map = {'text': newMessage.value};

        try {
          await ref.push(map).future;
          newMessage.value = '';
        } catch (e) {
          print('Error while writing to db, $e');
        }
      }
    });
  }

  void showMessages() {
    ref.onChildAdded.listen((e) {
      final datasnapshot = e.snapshot;

      final spanElement = SpanElement()..text = datasnapshot.val()['text'];

      final aElementDelete = AnchorElement(href: '#')
        ..text = 'Delete'
        ..onClick.listen((e) {
          e.preventDefault();
          _deleteItem(datasnapshot);
        });

      final aElementUpdate = AnchorElement(href: '#')
        ..text = 'To Uppercase'
        ..onClick.listen((e) {
          e.preventDefault();
          _uppercaseItem(datasnapshot);
        });

      final element = LIElement()
        ..id = datasnapshot.key
        ..append(spanElement)
        ..append(aElementDelete)
        ..append(aElementUpdate);
      messages.append(element);
    });

    ref.onChildChanged.listen((e) {
      final datasnapshot = e.snapshot;
      final element = querySelector('#${datasnapshot.key} span');

      if (element != null) {
        element.text = datasnapshot.val()['text'];
      }
    });

    ref.onChildRemoved.listen((e) {
      final datasnapshot = e.snapshot;

      final element = querySelector('#${datasnapshot.key}');

      if (element != null) {
        element.remove();
      }
    });
  }

  Future _deleteItem(fb.DataSnapshot datasnapshot) async {
    try {
      await ref.child(datasnapshot.key).remove();
    } catch (e) {
      print('Error while deleting item, $e');
    }
  }

  Future<void> _uppercaseItem(fb.DataSnapshot datasnapshot) async {
    final value = datasnapshot.val();
    final valueUppercase = value['text'].toString().toUpperCase();
    value['text'] = valueUppercase;

    try {
      await ref.child(datasnapshot.key).update(value);
    } catch (e) {
      print('Error while updating item, $e');
    }
  }
}
