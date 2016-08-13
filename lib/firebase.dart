/// Firebase is a global namespace from which all the Firebase
/// services are accessed.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase>.
library firebase3.firebase;

import 'dart:async';

import 'package:firebase3/app.dart';
import 'package:firebase3/auth.dart';
import 'package:firebase3/database.dart';
import 'package:firebase3/src/interop/auth_interop.dart' as auth_interop;
import 'package:firebase3/src/interop/firebase_interop.dart' as firebase;
import 'package:firebase3/src/js.dart';
import 'package:firebase3/src/utils.dart';
import 'package:firebase3/storage.dart';
import 'package:func/func.dart';
import 'package:js/js.dart';

/// A (read-only) array of all the initialized Apps.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase#.apps>.
List<App> get apps =>
    firebase.apps.map((jsApp) => new App.fromJsObject(jsApp)).toList();

/// The current SDK version.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase#.SDK_VERSION>.
String get SDK_VERSION => firebase.SDK_VERSION;

const String _DEFAULT_APP_NAME = "[DEFAULT]";

/// Create (and intialize) a Firebase App.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase#.initializeApp>.
App initializeApp(
    {String apiKey,
    String authDomain,
    String databaseURL,
    String storageBucket,
    String name}) {
  if (name == null) {
    name = _DEFAULT_APP_NAME;
  }

  return new App.fromJsObject(firebase.initializeApp(
      new firebase.FirebaseOptionsJsImpl(
          apiKey: apiKey,
          authDomain: authDomain,
          databaseURL: databaseURL,
          storageBucket: storageBucket),
      name));
}

App _app;

/// Retrieve an instance of a FirebaseApp.
///
/// With no arguments, this returns the default App. With a single
/// string argument, it returns the named App.
///
/// This function throws an exception if the app you are trying
/// to access does not exist.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.app>.
App app([String name]) {
  var jsObject = (name != null) ? firebase.app(name) : firebase.app();

  if (_app != null) {
    _app.jsObject = jsObject;
  } else {
    _app = new App.fromJsObject(jsObject);
  }
  return _app;
}

Auth _auth;

/// Gets the Auth object for the default App or a given App.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth>.
Auth auth([App app]) {
  var jsObject = (app != null) ? firebase.auth(app.jsObject) : firebase.auth();

  if (_auth != null) {
    _auth.jsObject = jsObject;
  } else {
    _auth = new Auth.fromJsObject(jsObject);
  }
  return _auth;
}

Database _database;

/// Access the Database service for the default App (or a given app).
///
/// Firebase [Database] is also a namespace that can be used to access
/// global constants and methods associated with the database service.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.database>.
Database database([App app]) {
  var jsObject =
      (app != null) ? firebase.database(app.jsObject) : firebase.database();

  if (_database != null) {
    _database.jsObject = jsObject;
  } else {
    _database = new Database.fromJsObject(jsObject);
  }
  return _database;
}

Storage _storage;

/// The namespace for all Firebase Storage functionality.
/// The returned service is initialized with a particular app which contains
/// the project's storage location, or uses the default app if none is provided.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.storage>.
Storage storage([App app]) {
  var jsObject =
      (app != null) ? firebase.storage(app.jsObject) : firebase.storage();

  if (_storage != null) {
    _storage.jsObject = jsObject;
  } else {
    _storage = new Storage.fromJsObject(jsObject);
  }
  return _storage;
}

/// A user account.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.User>.
class User extends UserInfo {
  bool get emailVerified => jsObject.emailVerified;

  bool get isAnonymous => jsObject.isAnonymous;

  List<UserInfo> get providerData => (jsObject.providerData as List)
      .map((data) => new UserInfo.fromJsObject(data))
      .toList();

  String get refreshToken => jsObject.refreshToken;

  User.fromJsObject(jsObject) : super.fromJsObject(jsObject);

  Future delete() {
    Completer c = new Completer();
    var jsPromise = jsObject.delete();
    jsPromise.then(resolveCallback(c), resolveError(c));
    return c.future;
  }

  Future<String> getToken([bool opt_forceRefresh = false]) {
    Completer<String> c = new Completer<String>();
    var jsPromise = jsObject.getToken(opt_forceRefresh);
    jsPromise.then(resolveCallback(c), resolveError(c));
    return c.future;
  }

  Future<User> link(AuthCredential credential) {
    Completer<User> c = new Completer<User>();
    var jsPromise = jsObject.link(credential.jsObject);

    var resolveCallbackWrap = allowInterop((firebase.UserJsImpl u) {
      c.complete(new User.fromJsObject(u));
    });

    jsPromise.then(resolveCallbackWrap, resolveError(c));
    return c.future;
  }

  Future<UserCredential> linkWithPopup(AuthProvider provider) {
    Completer<UserCredential> c = new Completer<UserCredential>();
    var jsPromise = jsObject.linkWithPopup(provider.jsObject);

    var resolveCallbackWrap =
        allowInterop((auth_interop.UserCredentialJsImpl u) {
      c.complete(new UserCredential.fromJsObject(u));
    });

    jsPromise.then(resolveCallbackWrap, resolveError(c));
    return c.future;
  }

  Future linkWithRedirect(AuthProvider provider) {
    Completer c = new Completer();
    var jsPromise = jsObject.linkWithRedirect(provider.jsObject);
    jsPromise.then(resolveCallback(c), resolveError(c));
    return c.future;
  }

  Future reauthenticate(AuthCredential credential) {
    Completer c = new Completer();
    var jsPromise = jsObject.reauthenticate(credential.jsObject);
    jsPromise.then(resolveCallback(c), resolveError(c));
    return c.future;
  }

  Future reload() {
    Completer c = new Completer();
    var jsPromise = jsObject.reload();
    jsPromise.then(resolveCallback(c), resolveError(c));
    return c.future;
  }

  Future sendEmailVerification() {
    Completer c = new Completer();
    var jsPromise = jsObject.sendEmailVerification();
    jsPromise.then(resolveCallback(c), resolveError(c));
    return c.future;
  }

  Future<User> unlink(String providerId) {
    Completer<User> c = new Completer<User>();
    var jsPromise = jsObject.unlink(providerId);

    var resolveCallbackWrap = allowInterop((firebase.UserJsImpl u) {
      c.complete(new User.fromJsObject(u));
    });

    jsPromise.then(resolveCallbackWrap, resolveError(c));
    return c.future;
  }

  Future updateEmail(String newEmail) {
    Completer c = new Completer();
    var jsPromise = jsObject.updateEmail(newEmail);
    jsPromise.then(resolveCallback(c), resolveError(c));
    return c.future;
  }

  Future updatePassword(String newPassword) {
    Completer c = new Completer();
    var jsPromise = jsObject.updatePassword(newPassword);
    jsPromise.then(resolveCallback(c), resolveError(c));
    return c.future;
  }

  Future updateProfile(UserProfile profile) {
    Completer c = new Completer();
    var jsPromise = jsObject.updateProfile(profile.jsObject);
    jsPromise.then(resolveCallback(c), resolveError(c));
    return c.future;
  }
}

/// User profile information, visible only to the Firebase project's apps.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.UserInfo>.
class UserInfo extends JsObjectWrapper {
  String get displayName => jsObject.displayName;
  void set displayName(String s) {
    jsObject.displayName = s;
  }

  String get email => jsObject.email;
  void set email(String s) {
    jsObject.email = s;
  }

  String get photoURL => jsObject.photoURL;
  void set photoURL(String s) {
    jsObject.photoURL = s;
  }

  String get providerId => jsObject.providerId;
  void set providerId(String s) {
    jsObject.providerId = s;
  }

  String get uid => jsObject.uid;
  void set uid(String s) {
    jsObject.uid = s;
  }

  UserInfo.fromJsObject(jsObject) : super.fromJsObject(jsObject);
}

/// A Thenable is an interface for converting operations to Futures.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.Thenable>.
abstract class Thenable<T> {
  Future catchError(Func1<Error, dynamic> onError);
  Future<T> then(Func1<T, dynamic> onValue);
}

/// FirebaseError is a subclass of the standard Error object.
/// In addition to a message string, it contains a string-valued code.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.FirebaseError>.
class FirebaseError extends JsObjectWrapper {
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

  FirebaseError.fromJsObject(jsObject) : super.fromJsObject(jsObject);
}

/// A structure for [User]'s user profile.
class UserProfile extends JsObjectWrapper {
  String get displayName => jsObject.displayName;
  void set displayName(String s) {
    jsObject.displayName = s;
  }

  String get photoURL => jsObject.photoURL;
  void set photoURL(String s) {
    jsObject.photoURL = s;
  }

  factory UserProfile({String displayName, String photoURL}) =>
      new UserProfile.fromJsObject(new firebase.UserProfileJsImpl(
          displayName: displayName, photoURL: photoURL));

  UserProfile.fromJsObject(jsObject) : super.fromJsObject(jsObject);
}

/// A structure for options provided to Firebase.
class FirebaseOptions extends JsObjectWrapper {
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

  FirebaseOptions.fromJsObject(jsObject) : super.fromJsObject(jsObject);
}
