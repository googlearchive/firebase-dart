@JS()
library firebase.es6_interop;

import 'package:js/js.dart';

@JS('Promise')
class PromiseJsImpl<T> {
  external PromiseJsImpl(Function resolver);

  external PromiseJsImpl then([
    void Function(dynamic) onResolve,
    void Function(dynamic) onReject,
  ]);
}
