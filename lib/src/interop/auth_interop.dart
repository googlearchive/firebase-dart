@JS('firebase.auth')
library firebase3.auth_interop;

import 'package:func/func.dart';
import 'package:js/js.dart';

import 'app_interop.dart';
import 'firebase_interop.dart';

@JS('Auth')
abstract class AuthJsImpl {
  external AppJsImpl get app;
  external void set app(AppJsImpl a);
  external UserJsImpl get currentUser;
  external void set currentUser(UserJsImpl u);
  external PromiseJsImpl applyActionCode(String code);
  external PromiseJsImpl<ActionCodeInfoJsImpl> checkActionCode(String code);
  external PromiseJsImpl confirmPasswordReset(String code, String newPassword);
  external PromiseJsImpl<UserJsImpl> createUserWithEmailAndPassword(
      String email, String password);
  external PromiseJsImpl<List<String>> fetchProvidersForEmail(String email);
  external PromiseJsImpl<UserCredentialJsImpl> getRedirectResult();
  external Func0 onAuthStateChanged(nextOrObserver,
      [Func1 opt_error, Func0 opt_completed]);
  external PromiseJsImpl sendPasswordResetEmail(String email);
  external PromiseJsImpl<UserJsImpl> signInAnonymously();
  external PromiseJsImpl<UserJsImpl> signInWithCredential(
      AuthCredential credential);
  external PromiseJsImpl<UserJsImpl> signInWithCustomToken(String token);
  external PromiseJsImpl<UserJsImpl> signInWithEmailAndPassword(
      String email, String password);
  external PromiseJsImpl<UserCredentialJsImpl> signInWithPopup(
      AuthProvider provider);
  external PromiseJsImpl signInWithRedirect(AuthProvider provider);
  external PromiseJsImpl signOut();
  external PromiseJsImpl<String> verifyPasswordResetCode(String code);
}

/// Represents the credentials returned by an auth provider.
/// Implementations specify the details about each auth provider's credential
/// requirements.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.AuthCredential>.
@JS()
abstract class AuthCredential {
  external String get provider;
}

/// Represents an auth provider.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.AuthProvider>.
@JS()
abstract class AuthProvider {
  external String get providerId;
}

/// Email and password auth provider implementation.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.EmailAuthProvider>.
@JS()
class EmailAuthProvider extends AuthProvider {
  external factory EmailAuthProvider();
  external static String get PROVIDER_ID;
  external static AuthCredential credential(String email, String password);
}

/// Facebook auth provider.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.FacebookAuthProvider>.
@JS()
class FacebookAuthProvider extends AuthProvider {
  external factory FacebookAuthProvider();
  external static String get PROVIDER_ID;
  external void addScope(String scope);
  external static AuthCredential credential(String token);
}

/// Github auth provider.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.GithubAuthProvider>.
@JS()
class GithubAuthProvider extends AuthProvider {
  external factory GithubAuthProvider();
  external static String get PROVIDER_ID;
  external void addScope(String scope);
  external static AuthCredential credential(String token);
}

/// Google auth provider.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.GoogleAuthProvider>.
@JS()
class GoogleAuthProvider extends AuthProvider {
  external factory GoogleAuthProvider();
  external static String get PROVIDER_ID;
  external void addScope(String scope);
  external static AuthCredential credential(
      [String idToken, String accessToken]);
}

/// Twitter auth provider.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.auth.TwitterAuthProvider>.
@JS()
class TwitterAuthProvider extends AuthProvider {
  external factory TwitterAuthProvider();
  external static String get PROVIDER_ID;
  external static AuthCredential credential(String token, String secret);
}

@JS('ActionCodeInfo')
abstract class ActionCodeInfoJsImpl {
  external ActionCodeEmailJsImpl get data;
  external void set data(ActionCodeEmailJsImpl a);
}

@JS('Error')
abstract class ErrorJsImpl {
  external String get code;
  external void set code(String s);
  external String get message;
  external void set message(String s);
}

@JS()
@anonymous
class ActionCodeEmailJsImpl {
  external String get email;
  external void set email(String s);

  external factory ActionCodeEmailJsImpl({String email});
}

@JS()
@anonymous
class UserCredentialJsImpl {
  external UserJsImpl get user;
  external void set user(UserJsImpl u);
  external AuthCredential get credential;
  external void set credential(AuthCredential c);

  external factory UserCredentialJsImpl(
      {UserJsImpl user, AuthCredential credential});
}
