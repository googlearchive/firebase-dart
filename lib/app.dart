library firebase3.app;

import 'dart:async';

import 'package:firebase3/auth.dart';
import 'package:firebase3/database.dart';
import 'package:firebase3/firebase.dart';
import 'package:firebase3/src/js.dart';
import 'package:firebase3/src/utils.dart';
import 'package:firebase3/storage.dart';

/// A Firebase App holds the initialization information for a collection
/// of services.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.app>.
class App extends JsObjectWrapper {
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
  App.fromJsObject(jsObject) : super.fromJsObject(jsObject);

  /// Returns [Auth] service.
  Auth auth() => new Auth.fromJsObject(jsObject.auth());

  /// Returns [Database] service.
  Database database() => new Database.fromJsObject(jsObject.database());

  /// Deletes the app and frees resources of all App's services.
  Future delete() {
    Completer c = new Completer();
    var jsPromise = jsObject.delete();
    jsPromise.then(resolveCallback(c), resolveError(c));
    return c.future;
  }

  /// Returns [Storage] service.
  Storage storage() => new Storage.fromJsObject(jsObject.storage());
}
