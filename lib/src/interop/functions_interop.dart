// ignore_for_file: avoid_unused_constructor_parameters, non_constant_identifier_names

@JS('firebase.functions')
library firebase.functions_interop;

import 'package:js/js.dart';
import 'firebase_interop.dart';

@JS('Functions')
abstract class FunctionsJsImpl {
  external FunctionsJsImpl get functions;
  external HttpsCallableJsImpl httpsCallable(String name,
      [HttpsCallableOptionsJsImpl options]);
  external void useFunctionsEmulator(String url);
}

@JS('HttpsCallable')
abstract class HttpsCallableJsImpl {
  external PromiseJsImpl<HttpsCallableResultJsImpl> call(dynamic data);
}

@JS('HttpsCallableOptions')
abstract class HttpsCallableOptionsJsImpl {
  external int get timeout;
  external set timeout(int t);

  external factory HttpsCallableOptionsJsImpl({int timeout});
}

@JS('HttpsCallableResult')
@anonymous
abstract class HttpsCallableResultJsImpl {
  external Map<String, dynamic> get data;
}

@JS('HttpsError')
abstract class HttpsErrorJsImpl {
  external ErrorJsImpl get error;
  external set error(ErrorJsImpl e);
  external dynamic get code;
  external set code(dynamic c);
  external dynamic get details;
  external set details(dynamic d);
  external String get message;
  external set message(String s);
  external String get name;
  external set name(String s);
  external String get stack;
  external set stack(String s);
}

@JS('Error')
abstract class ErrorJsImpl {
  external String get message;
  external set message(String m);
  external String get fileName;
  external set fileName(String f);
  external String get lineNumber;
  external set lineNumber(String l);
}
