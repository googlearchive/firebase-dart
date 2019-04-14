import 'dart:async';

import 'interop/functions_interop.dart' as functions_interop;
import 'js.dart';
import 'utils.dart';

class Functions extends JsObjectWrapper<functions_interop.FunctionsJsImpl> {
  static final _expando = Expando<Functions>();

  /// Creates a new Functions from a [jsObject].
  static Functions getInstance(functions_interop.FunctionsJsImpl jsObject) {
    if (jsObject == null) {
      return null;
    }
    return _expando[jsObject] ??= Functions._fromJsObject(jsObject);
  }

  Functions._fromJsObject(functions_interop.FunctionsJsImpl jsObject)
      : super.fromJsObject(jsObject);

  Functions get functions => getInstance(jsObject);

  HttpsCallable httpsCallable(String name, [HttpsCallableOptions options]) {
    functions_interop.HttpsCallableJsImpl httpCallableImpl;
    if (options != null) {
      httpCallableImpl = jsObject.httpsCallable(name, options.jsObject);
    } else {
      httpCallableImpl = jsObject.httpsCallable(name);
    }
    return HttpsCallable.getInstance(httpCallableImpl);
  }

  void useFunctionsEmulator(String url) => jsObject.useFunctionsEmulator(url);
}

class HttpsCallable
    extends JsObjectWrapper<functions_interop.HttpsCallableJsImpl> {
  static final _expando = Expando<HttpsCallable>();

  /// Creates a new HttpsCallable from a [jsObject].
  static HttpsCallable getInstance(
      functions_interop.HttpsCallableJsImpl jsObject) {
    if (jsObject == null) {
      return null;
    }
    return _expando[jsObject] ??= HttpsCallable._fromJsObject(jsObject);
  }

  HttpsCallable._fromJsObject(functions_interop.HttpsCallableJsImpl jsObject)
      : super.fromJsObject(jsObject);

  Future<HttpsCallableResult> call(data) {
    return handleThenable(jsObject
        .call(jsify(data))
        .then((result) => HttpsCallableResult.getInstance(jsify(result))));
  }
}

class HttpsCallableOptions
    extends JsObjectWrapper<functions_interop.HttpsCallableOptionsJsImpl> {
  factory HttpsCallableOptions({int timeout}) =>
      HttpsCallableOptions._fromJsObject(
          functions_interop.HttpsCallableOptionsJsImpl(timeout: timeout));

  static final _expando = Expando<HttpsCallableOptions>();

  /// Creates a new HttpsCallableOptions from a [jsObject].
  static HttpsCallableOptions getInstance(
      functions_interop.HttpsCallableOptionsJsImpl jsObject) {
    if (jsObject == null) {
      return null;
    }
    return _expando[jsObject] ??= HttpsCallableOptions._fromJsObject(jsObject);
  }

  HttpsCallableOptions._fromJsObject(
      functions_interop.HttpsCallableOptionsJsImpl jsObject)
      : super.fromJsObject(jsObject);

  int get timeout => jsObject.timeout;
  set(int timeout) => jsObject.timeout = timeout;
}

class HttpsCallableResult
    extends JsObjectWrapper<functions_interop.HttpsCallableResultJsImpl> {
  static final _expando = Expando<HttpsCallableResult>();

  /// Creates a new HttpsCallableResult from a [jsObject].
  static HttpsCallableResult getInstance(
      functions_interop.HttpsCallableResultJsImpl jsObject) {
    if (jsObject == null) {
      return null;
    }
    return _expando[jsObject] ??= HttpsCallableResult._fromJsObject(jsObject);
  }

  HttpsCallableResult._fromJsObject(
      functions_interop.HttpsCallableResultJsImpl jsObject)
      : super.fromJsObject(jsObject);

  Map<String, dynamic> get data => dartify(jsObject.data);
}
