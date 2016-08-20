import 'dart:async';

import 'package:js/js.dart';

import 'app.dart';
import 'interop/auth_interop.dart';
import 'interop/firebase_interop.dart' as firebase_interop;
import 'js.dart';
import 'utils.dart';

export 'interop/auth_interop.dart'
    show
        ActionCodeInfo,
        ActionCodeEmail,
        AuthCredential,
        EmailAuthProvider,
        FacebookAuthProvider,
        GithubAuthProvider,
        GoogleAuthProvider,
        TwitterAuthProvider;
export 'interop/firebase_interop.dart' show UserProfile;

/// User profile information, visible only to the Firebase project's apps.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.UserInfo>.
class UserInfo<T extends firebase_interop.UserInfoJsImpl>
    extends JsObjectWrapper<T> {
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

  UserInfo.fromJsObject(T jsObject) : super.fromJsObject(jsObject);
}

/// User account.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.User>.
class User extends UserInfo<firebase_interop.UserJsImpl> {
  bool get emailVerified => jsObject.emailVerified;

  bool get isAnonymous => jsObject.isAnonymous;

  List<UserInfo> get providerData => jsObject.providerData
      .map((data) =>
          new UserInfo<firebase_interop.UserInfoJsImpl>.fromJsObject(data))
      .toList();

  String get refreshToken => jsObject.refreshToken;

  User.fromJsObject(firebase_interop.UserJsImpl jsObject)
      : super.fromJsObject(jsObject);

  Future delete() => handleThenable(jsObject.delete());

  Future<String> getToken([bool opt_forceRefresh = false]) =>
      handleThenable(jsObject.getToken(opt_forceRefresh));

  Future<User> link(AuthCredential credential) => handleThenableWithMapper(
      jsObject.link(credential), (u) => new User.fromJsObject(u));

  Future<UserCredential> linkWithPopup(AuthProvider provider) =>
      handleThenableWithMapper(jsObject.linkWithPopup(provider),
          (u) => new UserCredential.fromJsObject(u));

  Future linkWithRedirect(AuthProvider provider) =>
      handleThenable(jsObject.linkWithRedirect(provider));

  Future reauthenticate(AuthCredential credential) =>
      handleThenable(jsObject.reauthenticate(credential));

  Future reload() => handleThenable(jsObject.reload());

  Future sendEmailVerification() =>
      handleThenable(jsObject.sendEmailVerification());

  Future<User> unlink(String providerId) => handleThenableWithMapper(
      jsObject.unlink(providerId),
      (firebase_interop.UserJsImpl u) => new User.fromJsObject(u));

  Future updateEmail(String newEmail) =>
      handleThenable(jsObject.updateEmail(newEmail));

  Future updatePassword(String newPassword) =>
      handleThenable(jsObject.updatePassword(newPassword));

  Future updateProfile(firebase_interop.UserProfile profile) =>
      handleThenable(jsObject.updateProfile(profile));
}

/// The Firebase Auth service class.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.Auth>.
class Auth extends JsObjectWrapper<AuthJsImpl> {
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

  Auth.fromJsObject(AuthJsImpl jsObject) : super.fromJsObject(jsObject);

  Future applyActionCode(String code) =>
      handleThenable(jsObject.applyActionCode(code));

  Future<ActionCodeInfo> checkActionCode(String code) =>
      handleThenable(jsObject.checkActionCode(code));

  Future confirmPasswordReset(String code, String newPassword) =>
      handleThenable(jsObject.confirmPasswordReset(code, newPassword));

  Future<User> createUserWithEmailAndPassword(String email, String password) =>
      handleThenableWithMapper(
          jsObject.createUserWithEmailAndPassword(email, password),
          (u) => new User.fromJsObject(u));

  Future<List<String>> fetchProvidersForEmail(String email) =>
      handleThenable(jsObject.fetchProvidersForEmail(email));

  Future<UserCredential> getRedirectResult() => handleThenableWithMapper(
      jsObject.getRedirectResult(), (u) => new UserCredential.fromJsObject(u));

  Future sendPasswordResetEmail(String email) =>
      handleThenable(jsObject.sendPasswordResetEmail(email));

  Future<User> signInAnonymously() => handleThenableWithMapper(
      jsObject.signInAnonymously(), (u) => new User.fromJsObject(u));

  Future<User> signInWithCredential(AuthCredential credential) =>
      handleThenableWithMapper(jsObject.signInWithCredential(credential),
          (u) => new User.fromJsObject(u));

  Future<User> signInWithCustomToken(String token) => handleThenableWithMapper(
      jsObject.signInWithCustomToken(token), (u) => new User.fromJsObject(u));

  Future<User> signInWithEmailAndPassword(String email, String password) =>
      handleThenableWithMapper(
          jsObject.signInWithEmailAndPassword(email, password),
          (u) => new User.fromJsObject(u));

  Future<UserCredential> signInWithPopup(AuthProvider provider) =>
      handleThenableWithMapper(jsObject.signInWithPopup(provider),
          (u) => new UserCredential.fromJsObject(u));

  Future signInWithRedirect(AuthProvider provider) =>
      handleThenable(jsObject.signInWithRedirect(provider));

  Future signOut() => handleThenable(jsObject.signOut());

  Future<String> verifyPasswordResetCode(String code) =>
      handleThenable(jsObject.verifyPasswordResetCode(code));
}

/// Event propagated in Stream controllers when auth state changes.
class AuthEvent {
  final User user;
  AuthEvent(this.user);
}

/// An authentication error.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.Error>.
class AuthError extends JsObjectWrapper<ErrorJsImpl> {
  String get code => jsObject.code;
  void set code(String s) {
    jsObject.code = s;
  }

  String get message => jsObject.message;
  void set message(String s) {
    jsObject.message = s;
  }

  AuthError.fromJsObject(ErrorJsImpl jsObject) : super.fromJsObject(jsObject);
}

/// A structure containing [User] and [AuthCredential].
class UserCredential extends JsObjectWrapper<UserCredentialJsImpl> {
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

  AuthCredential get credential => jsObject.credential;

  void set credential(AuthCredential c) {
    jsObject.credential = c;
  }

  UserCredential.fromJsObject(UserCredentialJsImpl jsObject)
      : super.fromJsObject(jsObject);

  factory UserCredential({User user, AuthCredential credential}) =>
      new UserCredential.fromJsObject(new UserCredentialJsImpl(
          user: user.jsObject, credential: credential));
}
