import 'dart:html';

import 'package:firebase_web/firebase.dart' as fb;
import 'package:firebase_web/src/assets/assets.dart';

main() async {
  //Use for firebase package development only
  await config();

  try {
    fb.initializeApp(
        apiKey: apiKey,
        authDomain: authDomain,
        databaseURL: databaseUrl,
        storageBucket: storageBucket,
        projectId: projectId);

    //Your app here
  } on fb.FirebaseJsNotLoadedException catch (e) {
    print(e);
  }
}
