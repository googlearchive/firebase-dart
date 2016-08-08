library firebase3.app;

import 'dart:async';
import 'package:firebase3/src/js.dart';
import 'package:firebase3/src/utils.dart';
import 'package:firebase3/database.dart';
import 'package:firebase3/auth.dart';
import 'package:firebase3/firebase.dart';
import 'package:firebase3/storage.dart';

/// A Firebase App holds the initialization information for a collection
/// of services.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.app>.
class App extends JsObjectWrapper {
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

  App.fromJsObject(jsObject) : super.fromJsObject(jsObject);

  Auth auth() => new Auth.fromJsObject(jsObject.auth());

  Database database() => new Database.fromJsObject(jsObject.database());

  Future delete() {
    Completer c = new Completer();
    var jsPromise = jsObject.delete();
    jsPromise.then(resolveCallback(c), resolveError(c));
    return c.future;
  }

  Storage storage() => new Storage.fromJsObject(jsObject.storage());
}
