import 'dart:async';
import 'dart:convert';
import 'dart:js';

import 'package:func/func.dart';
import 'package:js/js.dart';

import 'interop/firebase_interop.dart';
import 'interop/js_interop.dart' as js;

/// Returns Dart representation from JS Object.
dynamic dartify(Object jsObject) {
  String json = js.stringify(jsObject);
  return json == null ? null : JSON.decode(json);
}

/// Returns JS implementation from Dart Object.
dynamic jsify(Object dartObject) {
  if (dartObject is Map || dartObject is Iterable) {
    String json = JSON.encode(dartObject);
    return js.parse(json);
  }
  return dartObject;
}

Future/*<T>*/ handleThenable/*<T>*/(ThenableJsImpl thenable) {
  var completer = new Completer/*<T>*/();

  thenable.then(allowInterop(([value]) {
    completer.complete(value);
  }), resolveError(completer));
  return completer.future;
}

Future/*<T>*/ handleThenableWithMapper/*<T>*/(
    ThenableJsImpl thenable, Func1/*<dynamic,T>*/ mapper) {
  var completer = new Completer/*<T>*/();

  thenable.then(allowInterop((val) {
    var mappedValue = mapper(val);
    completer.complete(mappedValue);
  }), resolveError(completer));
  return completer.future;
}

VoidFunc1 resolveError(Completer c) => allowInterop(c.completeError);
