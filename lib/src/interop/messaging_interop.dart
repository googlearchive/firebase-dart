@JS('firebase.messaging')
library firebase.messaging_interop;

import 'package:func/func.dart';
import 'package:js/js.dart';

import 'firebase_interop.dart';

@JS('Messaging')
abstract class MessagingJsImpl {
  external void usePublicVapidKey(String key);
  external PromiseJsImpl requestPermission();
  external PromiseJsImpl<String> getToken();
  external VoidFunc0 onMessage(optionsOrObserverOrOnNext, observerOrOnNextOrOnError);
  external VoidFunc0 onTokenRefresh(optionsOrObserverOrOnNext, observerOrOnNextOrOnError);
}


//  {
//    collapse_key: do_not_collapse,
//    from: 288369714417,
//    notification: {
//      title: New chat message!,
//      body: There is a new message in FriendlyChat,
//      click_action: http://localhost:5000
//    }
//  }

@JS()
@anonymous
abstract class Notification {
  external String get title;
  external String get body;
  external String get clickAction;
}

@JS()
@anonymous
abstract class Payload {
  external Notification get notification;
}