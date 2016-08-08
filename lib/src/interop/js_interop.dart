@JS()
library firebase3.js_interop;

import 'package:js/js.dart';

@JS("JSON.stringify")
external String stringify(obj);

@JS("JSON.parse")
external dynamic parse(s);
