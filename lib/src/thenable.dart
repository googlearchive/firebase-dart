import 'dart:async';

import 'package:func/func.dart';

/// A Thenable is an interface for converting operations to Futures.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.Thenable>.
abstract class Thenable<T> {
  Future catchError(Func1<Error, dynamic> onError);
  Future<T> then(Func1<T, dynamic> onValue);
}
