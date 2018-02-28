import 'dart:async';

import 'package:js/js.dart';

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

  Future requestPermission() =>
      handleThenableWithMapper(jsObject.requestPermission(), dartify);

  Future<String> getToken() =>
      handleThenableWithMapper(jsObject.getToken(), (s) => s);

  StreamController<messaging_interop.Payload> _onMessageController;
  StreamController<Null> _onTokenRefresh;

  Stream<messaging_interop.Payload> get onMessage =>
      _createPayloadStream(_onMessageController);
  Stream<Null> get onTokenRefresh => _createNullStream(_onTokenRefresh);

  Stream<messaging_interop.Payload> _createPayloadStream(StreamController controller) {
    if (controller == null) {
      var nextWrapper = allowInterop((payload) => controller.add(payload));
      var errorWrapper = allowInterop((e) => controller.addError(e));
      ZoneCallback onSnapshotUnsubscribe;

      void startListen() {
        onSnapshotUnsubscribe = jsObject.onMessage(nextWrapper, errorWrapper);
      }

      void stopListen() {
        onSnapshotUnsubscribe();
        onSnapshotUnsubscribe = null;
      }

      controller = new StreamController<messaging_interop.Payload>.broadcast(
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
