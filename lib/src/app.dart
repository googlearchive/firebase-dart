import 'dart:async';

import 'auth.dart';
import 'database.dart';
import 'interop/app_interop.dart';
import 'interop/firebase_interop.dart' as firebase;
import 'js.dart';
import 'storage.dart';
import 'utils.dart';

/// A Firebase App holds the initialization information for a collection
/// of services.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.app>.
class App extends JsObjectWrapper<AppJsImpl> {
  String get name => jsObject.name;

  FirebaseOptions _options;
  FirebaseOptions get options {
    if (_options != null) {
      _options.jsObject = jsObject.options;
    } else {
      _options = new FirebaseOptions.fromJsObject(jsObject.options);
    }
    return _options;
  }

  App.fromJsObject(AppJsImpl jsObject) : super.fromJsObject(jsObject);

  Auth auth() => new Auth.fromJsObject(jsObject.auth());

  Database database() => new Database.fromJsObject(jsObject.database());

  Future delete() => handleJsPromise(jsObject.delete());

  Storage storage() => new Storage.fromJsObject(jsObject.storage());
}

/// FirebaseError is a subclass of the standard Error object.
/// In addition to a message string, it contains a string-valued code.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.FirebaseError>.
class FirebaseError extends JsObjectWrapper<firebase.FirebaseErrorJsImpl> {
  String get code => jsObject.code;
  void set code(String s) {
    jsObject.code = s;
  }

  String get message => jsObject.message;
  void set message(String s) {
    jsObject.message = s;
  }

  String get name => jsObject.name;
  void set name(String s) {
    jsObject.name = s;
  }

  String get stack => jsObject.stack;
  void set stack(String s) {
    jsObject.stack = s;
  }

  FirebaseError.fromJsObject(firebase.FirebaseErrorJsImpl jsObject)
      : super.fromJsObject(jsObject);
}

/// A structure for options provided to Firebase.
class FirebaseOptions extends JsObjectWrapper<firebase.FirebaseOptionsJsImpl> {
  String get apiKey => jsObject.apiKey;
  void set apiKey(String s) {
    jsObject.apiKey = s;
  }

  String get authDomain => jsObject.authDomain;
  void set authDomain(String s) {
    jsObject.authDomain = s;
  }

  String get databaseURL => jsObject.databaseURL;
  void set databaseURL(String s) {
    jsObject.databaseURL = s;
  }

  String get storageBucket => jsObject.storageBucket;
  void set storageBucket(String s) {
    jsObject.storageBucket = s;
  }

  factory FirebaseOptions(
          {String apiKey,
          String authDomain,
          String databaseURL,
          String storageBucket}) =>
      new FirebaseOptions.fromJsObject(new firebase.FirebaseOptionsJsImpl(
          apiKey: apiKey,
          authDomain: authDomain,
          databaseURL: databaseURL,
          storageBucket: storageBucket));

  FirebaseOptions.fromJsObject(firebase.FirebaseOptionsJsImpl jsObject)
      : super.fromJsObject(jsObject);
}
