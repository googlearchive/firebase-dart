import 'dart:async';
import 'dart:html';

import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/src/assets/assets.dart';
import 'package:http/http.dart' as http;

main() async {
  //Use for firebase package development only
  await config();

  try {
    fb.initializeApp(
        apiKey: apiKey,
        authDomain: authDomain,
        databaseURL: databaseUrl,
        storageBucket: storageBucket,
        messagingSenderId: messagingSenderId);

    await new MessagesApp().showMessages();
  } on fb.FirebaseJsNotLoadedException catch (e) {
    print(e);
  }
}

class MessagesApp {
  final InputElement tokenInput;
  final ButtonElement newNotification;
  final ParagraphElement payloadData;

  MessagesApp()
      : tokenInput = document.querySelector("#token"),
        newNotification = document.querySelector('#new_notification'),
        payloadData = document.querySelector("#payload_data");

  Future showMessages() async {
    final messaging = fb.messaging();
    await messaging.requestPermission();
    final token = await messaging.getToken();
    tokenInput.value = token;

    messaging.onMessage.listen((payload) {
      payloadData.text = payload.data.toString();
    });

    newNotification.onClick.listen((_) async {
      await http.post('https://fcm.googleapis.com/fcm/send', headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      }, body: {
        "notification": {
          "title": "New chat message!",
          "body": "There is a new message in FriendlyChat",
          "click_action": "http://localhost:5000"
        },
        "data": {"toto": "titi"},
        "to": token
      });
    });
  }
}
