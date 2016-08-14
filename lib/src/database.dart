import 'dart:async';

import 'package:func/func.dart';
import 'package:js/js.dart';

import 'app.dart';
import 'interop/database_interop.dart' as database_interop;
import 'js.dart';
import 'utils.dart';

/// Log debugging information to the console.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.database#.enableLogging>.
void enableLogging([logger, bool persistent = false]) =>
    database_interop.enableLogging(jsify(logger), persistent);

/// A placeholder value for auto-populating the current timestamp
/// (time since the Unix epoch, in milliseconds) as determined
/// by the Firebase servers.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.database#.ServerValue>.
abstract class ServerValue {
  static int get TIMESTAMP => database_interop.ServerValueJsImpl.TIMESTAMP;
}

/// The Firebase Database service class.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.database>.
class Database extends JsObjectWrapper<database_interop.DatabaseJsImpl> {
  App _app;
  App get app {
    if (_app != null) {
      _app.jsObject = jsObject.app;
    } else {
      _app = new App.fromJsObject(jsObject.app);
    }
    return _app;
  }

  Database.fromJsObject(database_interop.DatabaseJsImpl jsObject)
      : super.fromJsObject(jsObject);

  void goOffline() => jsObject.goOffline();

  void goOnline() => jsObject.goOnline();

  DatabaseReference ref([String path]) =>
      new DatabaseReference.fromJsObject(jsObject.ref(path));

  DatabaseReference refFromURL(String url) =>
      new DatabaseReference.fromJsObject(jsObject.refFromURL(url));
}

/// A Reference represents a specific location in your database and
/// can be used for reading or writing data to that database location.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.database.Reference>.
class DatabaseReference<T extends database_interop.ReferenceJsImpl>
    extends Query<T> {
  String get key => jsObject.key;

  DatabaseReference _parent;
  DatabaseReference get parent {
    if (jsObject.parent != null) {
      if (_parent != null) {
        _parent.jsObject = jsObject.parent;
      } else {
        _parent = new DatabaseReference.fromJsObject(jsObject.parent);
      }
    } else {
      _parent = null;
    }
    return _parent;
  }

  DatabaseReference _root;
  DatabaseReference get root {
    if (_root != null) {
      _root.jsObject = jsObject.root;
    } else {
      _root = new DatabaseReference.fromJsObject(jsObject.root);
    }
    return _root;
  }

  DatabaseReference.fromJsObject(T jsObject) : super.fromJsObject(jsObject);

  DatabaseReference child(String path) =>
      new DatabaseReference.fromJsObject(jsObject.child(path));

  OnDisconnect onDisconnect() =>
      new OnDisconnect.fromJsObject(jsObject.onDisconnect());

  ThenableReference push([value]) =>
      new ThenableReference.fromJsObject(jsObject.push(jsify(value)));

  Future remove() {
    Completer c = new Completer();
    jsObject.remove(allowInterop((e, _) {
      resolveFuture(c, e);
    }));
    return c.future;
  }

  Future set(value) {
    Completer c = new Completer();
    jsObject.set(jsify(value), allowInterop((e, _) {
      resolveFuture(c, e);
    }));
    return c.future;
  }

  Future setPriority(priority) {
    Completer c = new Completer();
    jsObject.setPriority(priority, allowInterop((e, _) {
      resolveFuture(c, e);
    }));
    return c.future;
  }

  Future setWithPriority(newVal, newPriority) {
    Completer c = new Completer();
    jsObject.setWithPriority(jsify(newVal), newPriority, allowInterop((e, _) {
      resolveFuture(c, e);
    }));
    return c.future;
  }

  Future<Transaction> transaction(Func1 transactionUpdate,
      [bool applyLocally = true]) {
    Completer<Transaction> c = new Completer<Transaction>();

    var transactionUpdateWrap =
        allowInterop((update) => jsify(transactionUpdate(dartify(update))));

    var onCompleteWrap = allowInterop(
        (error, bool committed, database_interop.DataSnapshotJsImpl snapshot) {
      var dataSnapshot =
          (snapshot != null) ? new DataSnapshot.fromJsObject(snapshot) : null;
      if (error != null) {
        c.completeError(error);
      } else {
        c.complete(
            new Transaction(committed: committed, snapshot: dataSnapshot));
      }
    });

    jsObject.transaction(transactionUpdateWrap, onCompleteWrap, applyLocally);
    return c.future;
  }

  Future update(values) {
    Completer c = new Completer();
    jsObject.update(jsify(values), allowInterop((e, _) {
      resolveFuture(c, e);
    }));
    return c.future;
  }
}

/// Event propagated in Stream controllers when path changes.
class QueryEvent {
  DataSnapshot snapshot;
  String prevChildKey;
  QueryEvent(this.snapshot, [this.prevChildKey]);
}

/// A Query sorts and filters the data at a database location so only
/// a subset of the child data is included. This can be used to order
/// a collection of data by some attribute (e.g. height of dinosaurs)
/// as well as to restrict a large list of items (e.g. chat messages)
/// down to a number suitable for synchronizing to the client.
/// Queries are created by chaining together one or more of the filter
/// methods defined here.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.database.Query>.
class Query<T extends database_interop.QueryJsImpl> extends JsObjectWrapper<T> {
  DatabaseReference _ref;
  DatabaseReference get ref {
    if (_ref != null) {
      _ref.jsObject = jsObject.ref;
    } else {
      _ref = new DatabaseReference.fromJsObject(jsObject.ref);
    }
    return _ref;
  }

  Stream<QueryEvent> _onValue;
  Stream<QueryEvent> get onValue {
    if (_onValue == null) {
      _onValue = _createStream("value");
    }
    return _onValue;
  }

  Stream<QueryEvent> _onChildAdded;
  Stream<QueryEvent> get onChildAdded {
    if (_onChildAdded == null) {
      _onChildAdded = _createStream("child_added");
    }
    return _onChildAdded;
  }

  Stream<QueryEvent> _onChildRemoved;
  Stream<QueryEvent> get onChildRemoved {
    if (_onChildRemoved == null) {
      _onChildRemoved = _createStream("child_removed");
    }
    return _onChildRemoved;
  }

  Stream<QueryEvent> _onChildChanged;
  Stream<QueryEvent> get onChildChanged {
    if (_onChildChanged == null) {
      _onChildChanged = _createStream("child_changed");
    }
    return _onChildChanged;
  }

  Stream<QueryEvent> _onChildMoved;
  Stream<QueryEvent> get onChildMoved {
    if (_onChildMoved == null) {
      _onChildMoved = _createStream("child_moved");
    }
    return _onChildMoved;
  }

  Query.fromJsObject(T jsObject) : super.fromJsObject(jsObject);

  Query endAt(value, [String key]) =>
      new Query.fromJsObject(jsObject.endAt(value, key));

  Query equalTo(value, [String key]) =>
      new Query.fromJsObject(jsObject.equalTo(value, key));

  Query limitToFirst(int limit) =>
      new Query.fromJsObject(jsObject.limitToFirst(limit));

  Query limitToLast(int limit) =>
      new Query.fromJsObject(jsObject.limitToLast(limit));

  Stream<QueryEvent> _createStream(String eventType) {
    StreamController<QueryEvent> streamController;

    var callbackWrap = allowInterop((database_interop.DataSnapshotJsImpl data,
        [String string]) {
      streamController
          .add(new QueryEvent(new DataSnapshot.fromJsObject(data), string));
    });

    void startListen() {
      jsObject.on(eventType, callbackWrap);
    }

    void stopListen() {
      jsObject.off(eventType);
    }

    streamController = new StreamController<QueryEvent>.broadcast(
        onListen: startListen, onCancel: stopListen, sync: true);
    return streamController.stream;
  }

  Future<QueryEvent> once(String eventType) {
    Completer<QueryEvent> c = new Completer<QueryEvent>();

    jsObject.once(eventType, allowInterop(
        (database_interop.DataSnapshotJsImpl snapshot, [String string]) {
      c.complete(
          new QueryEvent(new DataSnapshot.fromJsObject(snapshot), string));
    }), resolveError(c));

    return c.future;
  }

  Query orderByChild(String path) =>
      new Query.fromJsObject(jsObject.orderByChild(path));

  Query orderByKey() => new Query.fromJsObject(jsObject.orderByKey());

  Query orderByPriority() => new Query.fromJsObject(jsObject.orderByPriority());

  Query orderByValue() => new Query.fromJsObject(jsObject.orderByValue());

  Query startAt(value, [String key]) =>
      new Query.fromJsObject(jsObject.startAt(value, key));

  String toString() => jsObject.toString();
}

/// A DataSnapshot contains data from a database location.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.database.DataSnapshot>.
class DataSnapshot
    extends JsObjectWrapper<database_interop.DataSnapshotJsImpl> {
  String get key => jsObject.key;

  DatabaseReference _ref;
  DatabaseReference get ref {
    if (_ref != null) {
      _ref.jsObject = jsObject.ref;
    } else {
      _ref = new DatabaseReference.fromJsObject(jsObject.ref);
    }
    return _ref;
  }

  DataSnapshot.fromJsObject(database_interop.DataSnapshotJsImpl jsObject)
      : super.fromJsObject(jsObject);

  DataSnapshot child(String path) =>
      new DataSnapshot.fromJsObject(jsObject.child(path));

  bool exists() => jsObject.exists();

  dynamic exportVal() => dartify(jsObject.exportVal());

  bool forEach(Func1<DataSnapshot, dynamic> action) {
    var actionWrap = allowInterop((database_interop.DataSnapshotJsImpl data) {
      if (action != null) {
        action(new DataSnapshot.fromJsObject(data));
      }
    });
    return jsObject.forEach(actionWrap);
  }

  dynamic getPriority() => jsObject.getPriority();

  bool hasChild(String path) => jsObject.hasChild(path);

  bool hasChildren() => jsObject.hasChildren();

  int numChildren() => jsObject.numChildren();

  dynamic val() => dartify(jsObject.val());
}

/// The OnDisconnect class allows you to write or clear data when your client
/// disconnects from the database server. These updates occur whether your client
/// disconnects cleanly or not, so you can rely on them to clean up data even
/// if a connection is dropped or a client crashes.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.database.OnDisconnect>.
class OnDisconnect
    extends JsObjectWrapper<database_interop.OnDisconnectJsImpl> {
  OnDisconnect.fromJsObject(database_interop.OnDisconnectJsImpl jsObject)
      : super.fromJsObject(jsObject);

  Future cancel() {
    Completer c = new Completer();
    jsObject.cancel(allowInterop((e, _) {
      resolveFuture(c, e);
    }));
    return c.future;
  }

  Future remove() {
    Completer c = new Completer();
    jsObject.remove(allowInterop((e, _) {
      resolveFuture(c, e);
    }));
    return c.future;
  }

  Future set(value) {
    Completer c = new Completer();
    jsObject.set(jsify(value), allowInterop((e, _) {
      resolveFuture(c, e);
    }));
    return c.future;
  }

  Future setWithPriority(value, priority) {
    Completer c = new Completer();
    jsObject.setWithPriority(jsify(value), priority, allowInterop((e, _) {
      resolveFuture(c, e);
    }));
    return c.future;
  }

  Future update(values) {
    Completer c = new Completer();
    jsObject.update(jsify(values), allowInterop((e, _) {
      resolveFuture(c, e);
    }));
    return c.future;
  }
}

/// See: <https://firebase.google.com/docs/reference/js/firebase.database.ThenableReference>.
class ThenableReference
    extends DatabaseReference<database_interop.ThenableReferenceJsImpl> {
  Completer<DatabaseReference> _completer;

  ThenableReference.fromJsObject(
      database_interop.ThenableReferenceJsImpl jsObject)
      : super.fromJsObject(jsObject);

  Future<DatabaseReference> get future {
    if (_completer == null) {
      _completer = new Completer<DatabaseReference>();
      handleThenable(jsObject,
          mapper: (val) => new DatabaseReference.fromJsObject(val),
          completer: _completer);
    }
    return _completer.future;
  }
}

/// A structure used in [DatabaseReference.transaction].
class Transaction extends JsObjectWrapper<database_interop.TransactionJsImpl> {
  bool get committed => jsObject.committed;
  void set committed(bool c) {
    jsObject.committed = c;
  }

  DataSnapshot _snapshot;
  DataSnapshot get snapshot {
    if (jsObject.snapshot != null) {
      if (_snapshot != null) {
        _snapshot.jsObject = jsObject.snapshot;
      } else {
        _snapshot = new DataSnapshot.fromJsObject(jsObject.snapshot);
      }
    } else {
      _snapshot = null;
    }
    return _snapshot;
  }

  void set snapshot(DataSnapshot s) {
    _snapshot = s;
    jsObject.snapshot = s.jsObject;
  }

  Transaction.fromJsObject(database_interop.TransactionJsImpl jsObject)
      : super.fromJsObject(jsObject);

  factory Transaction({bool committed, DataSnapshot snapshot}) =>
      new Transaction.fromJsObject(new database_interop.TransactionJsImpl(
          committed: committed, snapshot: snapshot.jsObject));
}
