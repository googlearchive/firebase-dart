library firebase3.auth;

import 'dart:async';

import 'package:firebase3/app.dart';
import 'package:firebase3/firebase.dart';
import 'package:firebase3/src/interop/auth_interop.dart' as auth_interop;
import 'package:firebase3/src/interop/firebase_interop.dart'
    as firebase_interop;
import 'package:firebase3/src/js.dart';
import 'package:firebase3/src/utils.dart';
import 'package:js/js.dart';

/// The Firebase Auth service class.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.Auth>.
class Auth extends JsObjectWrapper {
  App _app;
  App get app {
    if (_app != null) {
      _app.jsObject = jsObject.app;
    } else {
      _app = new App.fromJsObject(jsObject.app);
    }
    return _app;
  }

  User _currentUser;
  User get currentUser {
    if (jsObject.currentUser != null) {
      if (_currentUser != null) {
        _currentUser.jsObject = jsObject.currentUser;
      } else {
        _currentUser = new User.fromJsObject(jsObject.currentUser);
      }
    } else {
      _currentUser = null;
    }
    return _currentUser;
  }

  var _onAuthUnsubscribe;
  Stream<AuthEvent> _onAuthStateChanged;
  Stream<AuthEvent> get onAuthStateChanged {
    if (_onAuthStateChanged == null) {
      StreamController<AuthEvent> streamController;

      var callbackWrap = allowInterop((firebase_interop.UserJsImpl user) {
        streamController.add(
            new AuthEvent((user != null) ? new User.fromJsObject(user) : null));
      });

      void startListen() {
        _onAuthUnsubscribe = jsObject.onAuthStateChanged(callbackWrap);
      }

      void stopListen() {
        _onAuthUnsubscribe();
      }

      streamController = new StreamController<AuthEvent>.broadcast(
          onListen: startListen, onCancel: stopListen, sync: true);
      _onAuthStateChanged = streamController.stream;
    }
    return _onAuthStateChanged;
  }

  Auth.fromJsObject(jsObject) : super.fromJsObject(jsObject);

  Future applyActionCode(String code) {
    Completer c = new Completer();
    var jsPromise = jsObject.applyActionCode(code);
    jsPromise.then(resolveCallback(c), resolveError(c));
    return c.future;
  }

  Future<ActionCodeInfo> checkActionCode(String code) {
    Completer<ActionCodeInfo> c = new Completer<ActionCodeInfo>();
    var jsPromise = jsObject.checkActionCode(code);

    var resolveCallbackWrap =
        allowInterop((auth_interop.ActionCodeInfoJsImpl a) {
      c.complete(new ActionCodeInfo.fromJsObject(a));
    });

    jsPromise.then(resolveCallbackWrap, resolveError(c));
    return c.future;
  }

  Future confirmPasswordReset(String code, String newPassword) {
    Completer c = new Completer();
    var jsPromise = jsObject.confirmPasswordReset(code, newPassword);
    jsPromise.then(resolveCallback(c), resolveError(c));
    return c.future;
  }

  Future<User> createUserWithEmailAndPassword(String email, String password) {
    Completer<User> c = new Completer<User>();
    var jsPromise = jsObject.createUserWithEmailAndPassword(email, password);

    var resolveCallbackWrap = allowInterop((firebase_interop.UserJsImpl u) {
      c.complete(new User.fromJsObject(u));
    });

    jsPromise.then(resolveCallbackWrap, resolveError(c));
    return c.future;
  }

  Future<List<String>> fetchProvidersForEmail(String email) {
    Completer<List<String>> c = new Completer<List<String>>();
    var jsPromise = jsObject.fetchProvidersForEmail(email);
    jsPromise.then(resolveCallback(c), resolveError(c));
    return c.future;
  }

  Future<UserCredential> getRedirectResult() {
    Completer<UserCredential> c = new Completer<UserCredential>();
    var jsPromise = jsObject.getRedirectResult();

    var resolveCallbackWrap =
        allowInterop((auth_interop.UserCredentialJsImpl u) {
      c.complete(new UserCredential.fromJsObject(u));
    });

    jsPromise.then(resolveCallbackWrap, resolveError(c));
    return c.future;
  }

  Future sendPasswordResetEmail(String email) {
    Completer c = new Completer();
    var jsPromise = jsObject.sendPasswordResetEmail(email);
    jsPromise.then(resolveCallback(c), resolveError(c));
    return c.future;
  }

  Future<User> signInAnonymously() {
    Completer<User> c = new Completer<User>();
    var jsPromise = jsObject.signInAnonymously();

    var resolveCallbackWrap = allowInterop((firebase_interop.UserJsImpl u) {
      c.complete(new User.fromJsObject(u));
    });

    jsPromise.then(resolveCallbackWrap, resolveError(c));
    return c.future;
  }

  Future<User> signInWithCredential(AuthCredential credential) {
    Completer<User> c = new Completer<User>();
    var jsPromise = jsObject.signInWithCredential(credential.jsObject);

    var resolveCallbackWrap = allowInterop((firebase_interop.UserJsImpl u) {
      c.complete(new User.fromJsObject(u));
    });

    jsPromise.then(resolveCallbackWrap, resolveError(c));
    return c.future;
  }

  Future<User> signInWithCustomToken(String token) {
    Completer<User> c = new Completer<User>();
    var jsPromise = jsObject.signInWithCustomToken(token);

    var resolveCallbackWrap = allowInterop((firebase_interop.UserJsImpl u) {
      c.complete(new User.fromJsObject(u));
    });

    jsPromise.then(resolveCallbackWrap, resolveError(c));
    return c.future;
  }

  Future<User> signInWithEmailAndPassword(String email, String password) {
    Completer<User> c = new Completer<User>();
    var jsPromise = jsObject.signInWithEmailAndPassword(email, password);

    var resolveCallbackWrap = allowInterop((firebase_interop.UserJsImpl u) {
      c.complete(new User.fromJsObject(u));
    });

    jsPromise.then(resolveCallbackWrap, resolveError(c));
    return c.future;
  }

  Future<UserCredential> signInWithPopup(AuthProvider provider) {
    Completer<UserCredential> c = new Completer<UserCredential>();
    var jsPromise = jsObject.signInWithPopup(provider.jsObject);

    var resolveCallbackWrap =
        allowInterop((auth_interop.UserCredentialJsImpl u) {
      c.complete(new UserCredential.fromJsObject(u));
    });

    jsPromise.then(resolveCallbackWrap, resolveError(c));
    return c.future;
  }

  Future signInWithRedirect(AuthProvider provider) {
    Completer c = new Completer();
    var jsPromise = jsObject.signInWithRedirect(provider.jsObject);
    jsPromise.then(resolveCallback(c), resolveError(c));
    return c.future;
  }

  Future signOut() {
    Completer c = new Completer();
    var jsPromise = jsObject.signOut();
    jsPromise.then(resolveCallback(c), resolveError(c));
    return c.future;
  }

  Future<String> verifyPasswordResetCode(String code) {
    Completer<String> c = new Completer<String>();
    var jsPromise = jsObject.verifyPasswordResetCode(code);
    jsPromise.then(resolveCallback(c), resolveError(c));
    return c.future;
  }
}

/// Event propagated in Stream controllers when auth state changes.
class AuthEvent {
  User user;
  AuthEvent(this.user);
}

/// Represents the credentials returned by an auth provider.
/// Implementations specify the details about each auth provider's credential
/// requirements.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.AuthCredential>.
class AuthCredential extends JsObjectWrapper {
  String get provider => jsObject.provider;
  void set provider(String s) {
    jsObject.provider = s;
  }

  AuthCredential.fromJsObject(jsObject) : super.fromJsObject(jsObject);
}

/// Represents an auth provider.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.AuthProvider>.
class AuthProvider extends JsObjectWrapper {
  String get providerId => jsObject.providerId;
  void set providerId(String s) {
    jsObject.providerId = s;
  }

  AuthProvider.fromJsObject(jsObject) : super.fromJsObject(jsObject);
}

/// Email and password auth provider implementation.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.EmailAuthProvider>.
class EmailAuthProvider extends AuthProvider {
  static String PROVIDER_ID = auth_interop.EmailAuthProviderJsImpl.PROVIDER_ID;

  EmailAuthProvider.fromJsObject(jsObject) : super.fromJsObject(jsObject);

  factory EmailAuthProvider() => new EmailAuthProvider.fromJsObject(
      new auth_interop.EmailAuthProviderJsImpl());

  AuthCredential credential(String email, String password) =>
      new AuthCredential.fromJsObject(jsObject.credential(email, password));
}

/// Facebook auth provider.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.FacebookAuthProvider>.
class FacebookAuthProvider extends AuthProvider {
  static String PROVIDER_ID =
      auth_interop.FacebookAuthProviderJsImpl.PROVIDER_ID;

  FacebookAuthProvider.fromJsObject(jsObject) : super.fromJsObject(jsObject);

  factory FacebookAuthProvider() => new FacebookAuthProvider.fromJsObject(
      new auth_interop.FacebookAuthProviderJsImpl());

  void addScope(String scope) => jsObject.addScope(scope);

  AuthCredential credential(String token) =>
      new AuthCredential.fromJsObject(jsObject.credential(token));
}

/// Github auth provider.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.GithubAuthProvider>.
class GithubAuthProvider extends AuthProvider {
  static String PROVIDER_ID = auth_interop.GithubAuthProviderJsImpl.PROVIDER_ID;

  GithubAuthProvider.fromJsObject(jsObject) : super.fromJsObject(jsObject);

  factory GithubAuthProvider() => new GithubAuthProvider.fromJsObject(
      new auth_interop.GithubAuthProviderJsImpl());

  void addScope(String scope) => jsObject.addScope(scope);

  AuthCredential credential(String token) =>
      new AuthCredential.fromJsObject(jsObject.credential(token));
}

/// Google auth provider.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.GoogleAuthProvider>.
class GoogleAuthProvider extends AuthProvider {
  static String PROVIDER_ID = auth_interop.GoogleAuthProviderJsImpl.PROVIDER_ID;

  GoogleAuthProvider.fromJsObject(jsObject) : super.fromJsObject(jsObject);

  factory GoogleAuthProvider() => new GoogleAuthProvider.fromJsObject(
      new auth_interop.GoogleAuthProviderJsImpl());

  void addScope(String scope) => jsObject.addScope(scope);

  AuthCredential credential([String idToken, String accessToken]) =>
      new AuthCredential.fromJsObject(
          jsObject.credential(idToken, accessToken));
}

/// Twitter auth provider.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.TwitterAuthProvider>.
class TwitterAuthProvider extends AuthProvider {
  static String PROVIDER_ID =
      auth_interop.TwitterAuthProviderJsImpl.PROVIDER_ID;

  TwitterAuthProvider.fromJsObject(jsObject) : super.fromJsObject(jsObject);

  factory TwitterAuthProvider() => new TwitterAuthProvider.fromJsObject(
      new auth_interop.TwitterAuthProviderJsImpl());

  AuthCredential credential([String token, String secret]) =>
      new AuthCredential.fromJsObject(jsObject.credential(token, secret));
}

/// A response from [Auth.checkActionCode].
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.ActionCodeInfo>.
class ActionCodeInfo extends JsObjectWrapper {
  ActionCodeEmail _data;
  ActionCodeEmail get data {
    if (_data != null) {
      _data.jsObject = jsObject.data;
    } else {
      _data = new ActionCodeEmail.fromJsObject(jsObject.data);
    }
    return _data;
  }

  void set data(ActionCodeEmail a) {
    _data = a;
    jsObject.data = a.jsObject;
  }

  ActionCodeInfo.fromJsObject(jsObject) : super.fromJsObject(jsObject);
}

/// An authentication error.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.Error>.
class AuthError extends JsObjectWrapper {
  String get code => jsObject.code;
  void set code(String s) {
    jsObject.code = s;
  }

  String get message => jsObject.message;
  void set message(String s) {
    jsObject.message = s;
  }

  AuthError.fromJsObject(jsObject) : super.fromJsObject(jsObject);
}

/// A structure containing data for [ActionCodeInfo].
class ActionCodeEmail extends JsObjectWrapper {
  String get email => jsObject.email;
  void set email(String s) {
    jsObject.email = s;
  }

  ActionCodeEmail.fromJsObject(jsObject) : super.fromJsObject(jsObject);

  factory ActionCodeEmail({String email}) => new ActionCodeEmail.fromJsObject(
      new auth_interop.ActionCodeEmailJsImpl(email: email));
}

/// A structure containing [User] and [AuthCredential].
class UserCredential extends JsObjectWrapper {
  User _user;
  User get user {
    if (jsObject.user != null) {
      if (_user != null) {
        _user.jsObject = jsObject.user;
      } else {
        _user = new User.fromJsObject(jsObject.user);
      }
    } else {
      _user = null;
    }
    return _user;
  }

  void set user(User u) {
    _user = u;
    jsObject.user = u.jsObject;
  }

  AuthCredential _credential;
  AuthCredential get credential {
    if (jsObject.credential != null) {
      if (_credential != null) {
        _credential.jsObject = jsObject.credential;
      } else {
        _credential = new AuthCredential.fromJsObject(jsObject.credential);
      }
    } else {
      _credential = null;
    }
    return _credential;
  }

  void set credential(AuthCredential c) {
    _credential = c;
    jsObject.credential = c.jsObject;
  }

  UserCredential.fromJsObject(jsObject) : super.fromJsObject(jsObject);

  factory UserCredential({User user, AuthCredential credential}) =>
      new UserCredential.fromJsObject(new auth_interop.UserCredentialJsImpl(
          user: user.jsObject, credential: credential.jsObject));
}
