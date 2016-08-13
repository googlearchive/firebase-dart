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
      AuthCredentialJsImpl credential);
  external PromiseJsImpl<UserJsImpl> signInWithCustomToken(String token);
  external PromiseJsImpl<UserJsImpl> signInWithEmailAndPassword(
      String email, String password);
  external PromiseJsImpl<UserCredentialJsImpl> signInWithPopup(
      AuthProviderJsImpl provider);
  external PromiseJsImpl signInWithRedirect(AuthProviderJsImpl provider);
  external PromiseJsImpl signOut();
  external PromiseJsImpl<String> verifyPasswordResetCode(String code);
}

@JS('AuthCredential')
abstract class AuthCredentialJsImpl {
  external String get provider;
  external void set provider(String s);
}

@JS('AuthProvider')
abstract class AuthProviderJsImpl {
  external String get providerId;
  external void set providerId(String s);
}

@JS('EmailAuthProvider')
class EmailAuthProviderJsImpl extends AuthProviderJsImpl {
  external EmailAuthProviderJsImpl();
  external static String get PROVIDER_ID;
  external AuthCredentialJsImpl credential(String email, String password);
}

@JS('FacebookAuthProvider')
class FacebookAuthProviderJsImpl extends AuthProviderJsImpl {
  external FacebookAuthProviderJsImpl();
  external static String get PROVIDER_ID;
  external void addScope(String scope);
  external AuthCredentialJsImpl credential(String token);
}

@JS('GithubAuthProvider')
class GithubAuthProviderJsImpl extends AuthProviderJsImpl {
  external GithubAuthProviderJsImpl();
  external static String get PROVIDER_ID;
  external void addScope(String scope);
  external AuthCredentialJsImpl credential(String token);
}

@JS('GoogleAuthProvider')
class GoogleAuthProviderJsImpl extends AuthProviderJsImpl {
  external GoogleAuthProviderJsImpl();
  external static String get PROVIDER_ID;
  external void addScope(String scope);
  external AuthCredentialJsImpl credential(
      [String idToken, String accessToken]);
}

@JS('TwitterAuthProvider')
class TwitterAuthProviderJsImpl extends AuthProviderJsImpl {
  external TwitterAuthProviderJsImpl();
  external static String get PROVIDER_ID;
  external AuthCredentialJsImpl credential(String token, String secret);
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
  external AuthCredentialJsImpl get credential;
  external void set credential(AuthCredentialJsImpl c);

  external factory UserCredentialJsImpl(
      {UserJsImpl user, AuthCredentialJsImpl credential});
}
