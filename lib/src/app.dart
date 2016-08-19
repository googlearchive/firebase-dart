import 'dart:async';

import 'auth.dart';
import 'database.dart';
import 'interop/app_interop.dart';
import 'interop/firebase_interop.dart' as firebase;
import 'js.dart';
import 'storage.dart';
import 'utils.dart';

export 'interop/firebase_interop.dart' show FirebaseError;

/// A Firebase App holds the initialization information for a collection
/// of services.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.app>.
class App extends JsObjectWrapper<AppJsImpl> {
  /// Name of the app.
  String get name => jsObject.name;

  FirebaseOptions _options;

  /// Options used during [firebase.initializeApp()].
  FirebaseOptions get options {
    if (_options != null) {
      _options.jsObject = jsObject.options;
    } else {
      _options = new FirebaseOptions.fromJsObject(jsObject.options);
    }
    return _options;
  }

  /// Creates a new App from [jsObject].
  App.fromJsObject(AppJsImpl jsObject) : super.fromJsObject(jsObject);

  /// Returns [Auth] service.
  Auth auth() => new Auth.fromJsObject(jsObject.auth());

  /// Returns [Database] service.
  Database database() => new Database.fromJsObject(jsObject.database());

  /// Deletes the app and frees resources of all App's services.
  Future delete() => handleThenable(jsObject.delete());

  /// Returns [Storage] service.
  Storage storage() => new Storage.fromJsObject(jsObject.storage());
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
