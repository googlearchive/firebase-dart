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
    FunctionsApp();
  } on fb.FirebaseJsNotLoadedException catch (e) {
    print(e);
  }
}

class FunctionsApp {
  final fb.Functions functions;
  final ParagraphElement resultText;
  final InputElement newName;
  final InputElement submit;
  final FormElement helloWorldForm;

  FunctionsApp()
      : functions = fb.functions(),
        resultText = querySelector('#result'),
        newName = querySelector("#new_name"),
        submit = querySelector('#submit'),
        helloWorldForm = querySelector("#hello_world_form") {
    newName.disabled = false;
    submit.disabled = false;

    this.helloWorldForm.onSubmit.listen((e) async {
      e.preventDefault();

      if (newName.value.trim().isNotEmpty) {
        try {
          fb.HttpsCallableResult result =
              await triggerHelloWorld(newName.value);
          if (result.data.isNotEmpty) {
            resultText.text = result.data['text'];
          }
          newName.value = "";
        } catch (e) {
          print(e);
        }
      }
    });
  }

  triggerHelloWorld(String name) async {
    final httpsCallable =
        this.functions.httpsCallable('helloWorld').call({'text': name});
    return await httpsCallable.then((result) {
      return result;
    }).catchError((e) => print);
  }
}
