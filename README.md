# Dart wrapper library for the new Firebase

[![Build Status](https://travis-ci.org/Janamou/firebase3-dart.svg?branch=master)](https://travis-ci.org/Janamou/firebase3-dart)

This is an unofficial Dart wrapper library for the new [Firebase](https://firebase.google.com). 

You can find more information on how to use Firebase on [Getting started](https://firebase.google.com/docs/web/setup) page.

Don't forget to setup correct **rules** for your [realtime database](https://firebase.google.com/docs/database/security/) and/or [storage](https://firebase.google.com/docs/storage/security/) in Firebase console. 
Auth has to be also set in the Firebase console if you want to use it.

## Usage

### Installation

Install the library from the pub or Github.

### Include Firebase source

You must include the original Firebase JavaScript source into your `.html` file to be able to use the library.

```html
<script src="https://www.gstatic.com/firebasejs/3.3.0/firebase.js"></script>
```

### Use it

```dart
import 'package:firebase3/firebase.dart' as firebase;

void main() {
  firebase.initializeApp(
    apiKey: "YourApiKey",
    authDomain: "YourAuthDomain",
    databaseURL: "YourDatabaseUrl",
    storageBucket: "YourStorageBucket");
    
  Database database = firebase.database();
  DatabaseReference ref = database.ref("messages");  

  ref.onValue.listen((e) {
    DataSnapshot datasnapshot = e.snapshot;
    //Do something with datasnapshot
  });
  
  ...
}
```
You can also call `await config();` to load Firebase configuration from your `src/assets/config.json` file. See [examples](https://github.com/Janamou/firebase3-dart/tree/master/example).

## Examples

You can find more examples on realtime database, auth and storage in the [example](https://github.com/Janamou/firebase3-dart/tree/master/example) folder.

## Bugs

This is the first version of the library, the bugs may appear. If you find a bug, please create an [issue](https://github.com/Janamou/firebase3-dart/issues).

