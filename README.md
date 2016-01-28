[![Build Status](https://travis-ci.org/firebase/firebase-dart.svg?branch=master)](https://travis-ci.org/firebase/firebase-dart)

A Dart wrapper for [Firebase](https://www.firebase.com).

This package contains two implementations of the same ```Firebase``` Dart API:
* The ```JsFirebase``` implementation uses `dart:js` to wrap functionality provided by `firebase.js`
in Dart classes. You'll need this implementation to build Firebase apps for the web.
* The ```MojoFirebase``` implementation uses [Mojo](https://github.com/domokit/mojo) to wrap functionality provided by Firebase iOS and Android SDKs. You'll need this implementation to build Firebase apps with [Flutter](http:/flutter.io).

Right now the ```MojoFirebase``` implementation is default, but you can change this in lib/src/firebase.dart. Once [dart-lang/sdk#24581](https://github.com/dart-lang/sdk/issues/24581) is fixed you'll get the right implementation automatically.

#### Installing

Follow the instructions on the [pub page](http://pub.dartlang.org/packages/firebase#installing).

**The firebase.js library MUST be included for the JavaScript wrapper to work**:

```html
<script src="https://cdn.firebase.com/js/client/2.3.2/firebase.js"></script>
```

