import 'dart:convert';
import 'dart:html';

import 'package:_shared_assets/assets.dart';
import 'package:firebase/firebase.dart' as fb;

Future<void> main() async {
  //Use for firebase package development only
  await config();

  try {
    fb.initializeApp(
        apiKey: apiKey,
        authDomain: authDomain,
        databaseURL: databaseUrl,
        storageBucket: storageBucket);

    AuthApp();
  } on fb.FirebaseJsNotLoadedException catch (e) {
    print(e);
  }
}

class AuthApp {
  final fb.Auth auth;
  final FormElement registerForm;
  final InputElement email, password;
  final AnchorElement logout;
  final TableElement authInfo;
  final ParagraphElement error;
  final SelectElement persistenceState, verifyEmailLanguage;
  final ButtonElement verifyEmail;
  final DivElement registeredUser, verifyEmailContainer;

  AuthApp()
      : auth = fb.auth(),
        email = querySelector('#email') as InputElement,
        password = querySelector('#password') as InputElement,
        authInfo = querySelector('#auth_info') as TableElement,
        error = querySelector('#register_form p') as ParagraphElement,
        logout = querySelector('#logout_btn') as AnchorElement,
        registerForm = querySelector('#register_form') as FormElement,
        persistenceState = querySelector('#persistent_state') as SelectElement,
        verifyEmail = querySelector('#verify_email') as ButtonElement,
        verifyEmailLanguage =
            querySelector('#verify_email_language') as SelectElement,
        registeredUser = querySelector('#registered_user') as DivElement,
        verifyEmailContainer =
            querySelector('#verify_email_container') as DivElement {
    logout.onClick.listen((e) {
      e.preventDefault();
      auth.signOut();
    });

    registerForm.onSubmit.listen((e) {
      e.preventDefault();
      final emailValue = email.value!.trim();
      final passwordValue = password.value!.trim();
      _registerUser(emailValue, passwordValue);
    });

    // After opening
    if (auth.currentUser != null) {
      _setLayout(auth.currentUser!);
    }

    // When auth state changes
    auth.onAuthStateChanged.listen(_setLayout);

    verifyEmail.onClick.listen((e) async {
      verifyEmail.disabled = true;
      verifyEmail.text = 'Sending verification email...';
      try {
        // you will get the verification email in selected language
        auth.languageCode = _getSelectedValue(verifyEmailLanguage);
        // url should be any authorized domain in your console - we use here,
        // for this example, authDomain because it is whitelisted by default
        // More info: https://firebase.google.com/docs/auth/web/passing-state-in-email-actions
        await auth.currentUser!.sendEmailVerification(
            fb.ActionCodeSettings(url: 'https://$authDomain'));
        verifyEmail.text = 'Verification email sent!';
      } catch (e) {
        verifyEmail
          ..text = e.toString()
          ..style.color = 'red';
      }
    });
  }

  Future<void> _registerUser(String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      var trySignin = false;
      try {
        // Modifies persistence state. More info: https://firebase.google.com/docs/auth/web/auth-state-persistence
        final selectedPersistence = _getSelectedValue(persistenceState);
        await auth.setPersistence(selectedPersistence);
        await auth.createUserWithEmailAndPassword(email, password);
      } on fb.FirebaseError catch (e) {
        if (e.code == 'auth/email-already-in-use') {
          trySignin = true;
        }
      } catch (e) {
        error.text = e.toString();
      }

      if (trySignin) {
        try {
          await auth.signInWithEmailAndPassword(email, password);
        } catch (e) {
          error.text = e.toString();
        }
      }
    } else {
      error.text = 'Please fill correct e-mail and password.';
    }
  }

  String _getSelectedValue(SelectElement element) =>
      element.options[element.selectedIndex!].value;

  void _setLayout(fb.User? user) {
    if (user != null) {
      registerForm.style.display = 'none';
      registeredUser.style.display = 'block';
      email.value = '';
      password.value = '';
      error.text = '';

      final data = <String, dynamic>{
        'email': user.email,
        'emailVerified': user.emailVerified,
        'isAnonymous': user.isAnonymous,
        'metadata.creationTime': user.metadata.creationTime,
        'metadata.lastSignInTime': user.metadata.lastSignInTime
      };

      data.forEach((k, v) {
        if (v != null) {
          final row = authInfo.addRow();

          row.addCell()
            ..text = k
            ..classes.add('header');
          row.addCell().text = '$v';
        }
      });

      print('User.toJson:');
      print(const JsonEncoder.withIndent(' ').convert(user));

      verifyEmailContainer.style.display =
          user.emailVerified ? 'none' : 'block';
    } else {
      registerForm.style.display = 'block';
      registeredUser.style.display = 'none';

      authInfo.children.clear();
    }
  }
}
