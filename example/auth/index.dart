library firebase3.example.auth;

import 'dart:html';
import 'package:firebase3/firebase.dart' as fb;
import 'package:firebase3/src/assets/assets.dart';

// Update firebase.initializeApp() with information from your project.
// See <https://firebase.google.com/docs/web/setup>.
main() async {
  await config();

  fb.initializeApp(
      apiKey: apiKey,
      authDomain: authDomain,
      databaseURL: databaseUrl,
      storageBucket: storageBucket);

  new AuthApp();
}

class AuthApp {
  fb.Auth auth;
  FormElement registerForm;
  InputElement email, password;
  AnchorElement logout;
  HeadingElement authInfo;
  ParagraphElement error;

  AuthApp() {
    this.auth = fb.auth();
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
      fb.User u = e.user;
      _setLayout(u);
    });
  }

  void _setLayout(fb.User user) {
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
