@JS('firebase.app')
library firebase3.app_interop;

import 'package:js/js.dart';
import 'package:firebase3/src/interop/storage_interop.dart';
import 'package:firebase3/src/interop/firebase_interop.dart';
import 'package:firebase3/src/interop/auth_interop.dart';
import 'package:firebase3/src/interop/database_interop.dart';

@JS('App')
abstract class AppJsImpl {
  external String get name;
  external FirebaseOptionsJsImpl get options;
  external AuthJsImpl auth();
  external DatabaseJsImpl database();
  external PromiseJsImpl delete();
  external StorageJsImpl storage();
}
