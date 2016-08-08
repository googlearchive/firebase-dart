library firebase3.example.auth;

import 'dart:html';
import 'package:firebase3/firebase.dart' as firebase;
import 'package:firebase3/auth.dart';
import 'package:firebase3/firebase.dart';

// Update firebase.initializeApp() with information from your project.
// See <https://firebase.google.com/docs/web/setup>.
void main() {
  firebase.initializeApp(
      apiKey: "TODO",
      authDomain: "TODO",
      databaseURL: "TODO",
      storageBucket: "TODO");

  new AuthApp();
}

class AuthApp {
  Auth auth;
  FormElement registerForm;
  InputElement email, password;
  AnchorElement logout;
  HeadingElement authInfo;
  ParagraphElement error;

  AuthApp() {
    this.auth = firebase.auth();
    this.email = querySelector("#email");
    this.password = querySelector("#password");
    this.authInfo = querySelector("#auth_info");
    this.error = querySelector("#register_form p");
    this.logout = querySelector("#logout_btn");
    this.logout.onClick.listen((e) {
      e.preventDefault();
      auth.signOut();
    });

    this.registerForm = querySelector("#register_form");
    this.registerForm.onSubmit.listen((e) {
      e.preventDefault();
      var emailValue = email.value.trim();
      var passwordvalue = password.value.trim();

      if (emailValue != "" && passwordvalue != "") {
        auth
            .createUserWithEmailAndPassword(emailValue, passwordvalue)
            .catchError((e) {
          error.text = e.toString();
        });
      } else {
        error.text = "Please fill correct e-mail and password.";
      }
    });

    // After opening
    if (auth.currentUser != null) {
      _setLayout(auth.currentUser);
    }

    // When auth state changes
    auth.onAuthStateChanged.listen((e) {
      User u = e.user;
      _setLayout(u);
    });
  }

  void _setLayout(User user) {
    if (user != null) {
      this.registerForm.style.display = "none";
      this.logout.style.display = "block";
      this.email.value = "";
      this.password.value = "";
      this.error.text = "";
      this.authInfo.style.display = "block";
      this.authInfo.text = user.email;
    } else {
      this.registerForm.style.display = "block";
      this.authInfo.style.display = "none";
      this.logout.style.display = "none";
      this.authInfo.children.clear();
    }
  }
}
