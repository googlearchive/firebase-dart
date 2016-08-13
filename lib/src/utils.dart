import 'dart:async';
import 'dart:convert';
import 'dart:js';

import 'package:js/js.dart';

import 'interop/js_interop.dart' as js;

/// Returns Dart representation from JS Object.
dynamic dartify(jsObject) {
  String json = js.stringify(jsObject);
  return JSON.decode(json);
}

/// Returns JS implementation from Dart Object.
dynamic jsify(dartObject) {
  if (dartObject is Map || dartObject is Iterable) {
    String json = JSON.encode(dartObject);
    return js.parse(json);
  }
  return dartObject;
}

ZoneUnaryCallback resolveCallback(Completer c) {
  return allowInterop(([value]) {
    c.complete(value);
  });
}

ZoneUnaryCallback resolveError(Completer c) {
  return allowInterop((error) {
    c.completeError(error);
  });
}

void resolveFuture(Completer c, error, [value]) {
  if (error != null) {
    c.completeError(error);
  } else {
    c.complete(value);
  }
}
