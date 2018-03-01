import 'dart:async';

import 'package:js/js.dart';
import 'package:func/func.dart';

import 'interop/messaging_interop.dart' as messaging_interop;
import 'js.dart';
import 'utils.dart';

class Messaging extends JsObjectWrapper<messaging_interop.MessagingJsImpl> {
  static final _expando = new Expando<Messaging>();

  static Messaging getInstance(messaging_interop.MessagingJsImpl jsObject) {
    if (jsObject == null) {
      return null;
    }
    return _expando[jsObject] ??= new Messaging._fromJsObject(jsObject);
  }

  Messaging._fromJsObject(messaging_interop.MessagingJsImpl jsObject)
      : super.fromJsObject(jsObject);

  void usePublicVapidKey(String key) => jsObject.usePublicVapidKey(key);

  void useServiceWorker(registration) =>
      jsObject.useServiceWorker(registration);

  Future requestPermission() =>
      handleThenableWithMapper(jsObject.requestPermission(), dartify);

  Future<String> getToken() =>
      handleThenableWithMapper(jsObject.getToken(), (s) => s);

  void setBackgroundMessageHandler(Func1<Payload, void> f) =>
      jsObject.setBackgroundMessageHandler(
          allowInterop((payload) => f(new Payload._fromJsObject(payload))));

  StreamController<Payload> _onMessageController;
  StreamController<Null> _onTokenRefresh;

  Stream<Payload> get onMessage =>
      _createPayloadStream(_onMessageController, jsObject.onMessage);
  Stream<Null> get onTokenRefresh => _createNullStream(_onTokenRefresh);

  Stream<Payload> _createPayloadStream(
      StreamController controller, Func2 function) {
    if (controller == null) {
      var nextWrapper = allowInterop(
          (payload) => controller.add(new Payload._fromJsObject(payload)));
      var errorWrapper = allowInterop((e) => controller.addError(e));
      ZoneCallback onSnapshotUnsubscribe;

      void startListen() {
        onSnapshotUnsubscribe = function(nextWrapper, errorWrapper);
      }

      void stopListen() {
        onSnapshotUnsubscribe();
        onSnapshotUnsubscribe = null;
      }

      controller = new StreamController<Payload>.broadcast(
          onListen: startListen, onCancel: stopListen, sync: true);
    }
    return controller.stream;
  }

  Stream<Null> _createNullStream(StreamController controller) {
    if (controller == null) {
      var nextWrapper = allowInterop((_) => null);
      var errorWrapper = allowInterop((e) => controller.addError(e));
      ZoneCallback onSnapshotUnsubscribe;

      void startListen() {
        onSnapshotUnsubscribe = jsObject.onMessage(nextWrapper, errorWrapper);
      }

      void stopListen() {
        onSnapshotUnsubscribe();
        onSnapshotUnsubscribe = null;
      }

      controller = new StreamController<Null>.broadcast(
          onListen: startListen, onCancel: stopListen, sync: true);
    }
    return controller.stream;
  }
}

class Notification
    extends JsObjectWrapper<messaging_interop.NotificationJsImpl> {
  Notification._fromJsObject(messaging_interop.NotificationJsImpl jsObject)
      : super.fromJsObject(jsObject);

  String get title => jsObject.title;
  String get body => jsObject.body;
  String get clickAction => jsObject.click_action;
  String get icon => jsObject.icon;
}

class Payload extends JsObjectWrapper<messaging_interop.PayloadJsImpl> {
  Payload._fromJsObject(messaging_interop.PayloadJsImpl jsObject)
      : super.fromJsObject(jsObject);

  Notification get notification =>
      new Notification._fromJsObject(jsObject.notification);
  String get collapseKey => jsObject.collapse_key;
  String get from => jsObject.from;
  Map<String, String> get data => dartify(jsObject.data);
}
