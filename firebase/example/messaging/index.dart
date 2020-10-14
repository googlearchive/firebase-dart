import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:firebase/firebase.dart' as fb;
import 'package:http/browser_client.dart';
import 'package:service_worker/window.dart' as sw;
import 'package:_shared_assets/assets.dart';

void main() async {
  //Use for firebase package development only
  await config();

  try {
    fb.initializeApp(
      apiKey: apiKey,
      appId: appId,
      projectId: projectId,
      authDomain: authDomain,
      databaseURL: databaseUrl,
      storageBucket: storageBucket,
      messagingSenderId: messagingSenderId,
    );
  } on fb.FirebaseJsNotLoadedException catch (e) {
    print(e);
  }

  final enableButton =
      document.querySelector('#enable_notifications') as ButtonElement;

  enableButton.disabled = false;

  enableButton.onClick.listen((e) {
    MessagesApp().showMessages();
    enableButton.hidden = true;
    document.querySelector('#content').hidden = false;
  });
}

class MessagesApp {
  final InputElement tokenInput;
  final ButtonElement newNotification;
  final ParagraphElement payloadData;
  final InputElement permissionInput;

  MessagesApp()
      : tokenInput = document.querySelector('#token'),
        newNotification = document.querySelector('#new_notification'),
        payloadData = document.querySelector('#payload_data'),
        permissionInput = document.querySelector('#permission');

  Future showMessages() async {
    await sw.register('sw.dart.js');
    final registration = await sw.ready;
    final messaging = fb.messaging()
      ..usePublicVapidKey(vapidKey)
      ..useServiceWorker(registration.jsObject);

    try {
      await messaging.requestPermission();
      permissionInput.value = 'granted';
      newNotification.disabled = false;
      final token = await messaging.getToken();
      tokenInput.value = token;
      messaging.onMessage.listen((payload) {
        payloadData.text = payload.data.toString();
        Notification(payload.notification.title,
            body: payload.notification.body);
      });
      newNotification.onClick.listen((_) async {
        final client = BrowserClient();

        await client.post('https://fcm.googleapis.com/fcm/send',
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'key=$serverKey',
            },
            body: jsonEncode({
              'notification': {
                'title': 'New demo message!',
                'body': 'There is a new message in Messaging Demo',
              },
              'data': {'Current time': DateTime.now().toIso8601String()},
              'to': token
            }));
      });
    } catch (e, stack) {
      permissionInput.value = 'denied';
      print('$e\n$stack');
    }
  }
}
