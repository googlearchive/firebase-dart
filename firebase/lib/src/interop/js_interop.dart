@JS()
library firebase.js_interop;

import 'package:js/js.dart';

@JS('Object.keys')
external List<String> objectKeys(Object obj);

@JS('Array.from')
external Object toJSArray(List source);
