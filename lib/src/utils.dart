import 'dart:async';
import 'dart:convert';
import 'dart:js';

import 'package:func/func.dart';
import 'package:js/js.dart';

import 'interop/firebase_interop.dart';
import 'interop/js_interop.dart' as js;

/// Returns Dart representation from JS Object.
dynamic dartify(Object jsObject) {
  if (jsObject == null ||
      jsObject is num ||
      jsObject is bool ||
      jsObject is String) {
    return jsObject;
  }
  var json = js.stringify(jsObject);
  return JSON.decode(json);
}

/// Returns JS implementation from Dart Object.
dynamic jsify(Object dartObject) {
  if (dartObject == null ||
      dartObject is num ||
      dartObject is bool ||
      dartObject is String) {
    return dartObject;
  }

  Object json;
  try {
    json = JSON.encode(dartObject, toEncodable: _noCustomEncodable);
  } on JsonUnsupportedObjectError {
    throw new ArgumentError('only basic JS types are supported');
  }
  return js.parse(json);
}

_noCustomEncodable(value) => throw "Object with toJson shouldn't work either";

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
