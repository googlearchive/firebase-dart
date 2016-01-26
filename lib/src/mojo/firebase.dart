library firebase.mojo.firebase;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sky_services/firebase/firebase.mojom.dart' as mojo;

import '../firebase.dart';
import '../disconnect.dart';
import '../event.dart';
import '../data_snapshot.dart';
import '../transaction_result.dart';

import 'auth_response.dart';
import 'data_snapshot.dart';

class FirebaseImpl extends MojoFirebase {
  FirebaseImpl(String url) : super(url);
  static final ServerValue = null;
}

class MojoFirebase extends MojoQuery implements Firebase {
  MojoFirebase(String url) : super(url);

  MojoFirebase._withProxy(mojo.FirebaseProxy firebase) : super._withProxy(firebase);

  Disconnect get onDisconnect => null;

  @deprecated
  Future auth(String token) => null;

  Future authWithCustomToken(String token) => null;

  Future authAnonymously({remember: 'default'}) => null;

  Future authWithPassword(Map credentials) {
    Completer c = new Completer();
    _firebase.ptr
      .authWithPassword(credentials["email"], credentials["password"])
      .then((mojo.FirebaseAuthWithPasswordResponseParams response) {
      if (response.error != null) {
        c.completeError(response.error);
      } else {
        c.complete(decodeAuthData(response.authData));
      }
    });
    return c.future;
  }

  Future authWithOAuthPopup(provider, {remember: 'default', scope: ''}) => null;

  Future authWithOAuthRedirect(provider, {remember: 'default', scope: ''}) => null;

  Future authWithOAuthToken(String provider, String credentials,
      {remember: 'default', scope: ''}) {
    // TODO(jackson): Implement remember and scope
    Completer c = new Completer();
    _firebase.ptr
      .authWithOAuthToken(provider, credentials)
      .then((mojo.FirebaseAuthWithOAuthTokenResponseParams response) {
      if (response.error != null) {
        c.completeError(response.error);
      } else {
        c.complete(decodeAuthData(response.authData));
      }
    });
    return c.future;
  }

  dynamic getAuth() => null;

  Stream onAuth([context]) => null;

  void unauth() => null;

  Firebase child(String path) {
    mojo.FirebaseProxy proxy = new mojo.FirebaseProxy.unbound();
    _firebase.ptr.getChild(path, proxy);
    return new MojoFirebase._withProxy(proxy);
  }

  Firebase parent() => null;

  Firebase root() {
    mojo.FirebaseProxy proxy = new mojo.FirebaseProxy.unbound();
    _firebase.ptr.getRoot(proxy);
    return new MojoFirebase._withProxy(proxy);
  }

  String get key => null;

  String toString() => null;

  Future set(value) async {
    var c = new Completer();
    String jsonValue = JSON.encode({ "value": value });
    _firebase
      .ptr.setValue(jsonValue, null)
      .then((mojo.FirebaseSetValueResponseParams response) {
      if (response.error != null) {
        c.completeError(response.error);
      } else {
        c.complete();
      }
    });
    return c.future;
  }

  Future update(Map<String, dynamic> value) => null;

  Future remove() => null;

  Firebase push({value, onComplete}) => null;

  Future setWithPriority(value, int priority) => null;

  Future setPriority(int priority) => null;

  Future<TransactionResult> transaction(update(currentVal),
      {bool applyLocally: true}) => null;

  Future createUser(Map credentials) => null;

  Future changeEmail(Map credentials) => null;

  Future changePassword(Map credentials) => null;

  Future removeUser(Map credentials) => null;

  Future resetPassword(Map credentials) => null;
}

class _ValueEventListener implements mojo.ValueEventListener {
  StreamController<Event> controller;
  _ValueEventListener(this.controller);

  void onCancelled(mojo.Error error) {
    print("ValueEventListener onCancelled: ${error}");
  }

  void onDataChange(mojo.DataSnapshot snapshot) {
    controller
      .add(new Event(new MojoDataSnapshot.fromMojoObject(snapshot), null));
  }
}

class MojoQuery implements Query {
  mojo.FirebaseProxy _firebase;
  Stream<Event> _onValue;

  MojoQuery(String url) : _firebase = new mojo.FirebaseProxy.unbound() {
    shell.connectToService("firebase::Firebase", _firebase);
    _firebase.ptr.initWithUrl(url);
  }

  MojoQuery._withProxy(mojo.FirebaseProxy firebase) : _firebase = firebase;

  Stream<Event> get onValue {
    if (_onValue == null) {
      mojo.ValueEventListenerStub stub = new mojo.ValueEventListenerStub.unbound();
      StreamController<Event> controller = new StreamController<Event>.broadcast(
        onListen: () => _firebase.ptr.addValueEventListener(stub),
        onCancel: () => stub.close(),
        sync: true
      );
      stub.impl = new _ValueEventListener(controller);
      _onValue = controller.stream;
    }
    return _onValue;
  }

  Stream<Event> get onChildAdded => null;

  Stream<Event> get onChildMoved => null;

  Stream<Event> get onChildChanged => null;

  Stream<Event> get onChildRemoved => null;

  /**
   * Listens for exactly one event of the specified event type, and then stops
   * listening.
   */
  Future<DataSnapshot> once(String eventType) async {
    mojo.EventType mojoEventType = _stringToMojoEventType(eventType);
    mojo.DataSnapshot result =
      (await _firebase.ptr.observeSingleEventOfType(mojoEventType)).snapshot;
    return new MojoDataSnapshot.fromMojoObject(result);
  }

  /**
   * Generates a new Query object ordered by the specified child key.
   */
  Query orderByChild(String key) => null;

  /**
   * Generates a new Query object ordered by key.
   */
  Query orderByKey() => null;

  /**
   * Generates a new Query object ordered by child values.
   */
  Query orderByValue() => null;

  /**
   * Generates a new Query object ordered by priority.
   */
  Query orderByPriority() => null;

  /**
   * Creates a Query with the specified starting point. The generated Query
   * includes children which match the specified starting point. If no arguments
   * are provided, the starting point will be the beginning of the data.
   *
   * The starting point is inclusive, so children with exactly the specified
   * priority will be included. Though if the optional name is specified, then
   * the children that have exactly the specified priority must also have a
   * name greater than or equal to the specified name.
   *
   * startAt() can be combined with endAt() or limitToFirst() or limitToLast()
   * to create further restrictive queries.
   */
  Query startAt({dynamic value, String key}) => null;

  /**
   * Creates a Query with the specified ending point. The generated Query
   * includes children which match the specified ending point. If no arguments
   * are provided, the ending point will be the end of the data.
   *
   * The ending point is inclusive, so children with exactly the specified
   * priority will be included. Though if the optional name is specified, then
   * children that have exactly the specified priority must also have a name
   * less than or equal to the specified name.
   *
   * endAt() can be combined with startAt() or limitToFirst() or limitToLast()
   * to create further restrictive queries.
   */
  Query endAt({dynamic value, String key}) => null;

  /**
   * Creates a Query which includes children which match the specified value.
   */
  Query equalTo(value, [key]) => null;

  /**
   * Generates a new Query object limited to the first certain number of children.
   */
  Query limitToFirst(int limit) => null;

  /**
   * Generates a new Query object limited to the last certain number of children.
   */
  Query limitToLast(int limit) => null;

  /**
   * Generate a Query object limited to the number of specified children. If
   * combined with startAt, the query will include the specified number of
   * children after the starting point. If combined with endAt, the query will
   * include the specified number of children before the ending point. If not
   * combined with startAt() or endAt(), the query will include the last
   * specified number of children.
   */
  @deprecated
  Query limit(int limit) => null;

  /**
   * Queries are attached to a location in your Firebase. This method will
   * return a Firebase reference to that location.
   */
  Firebase ref() => null;
}

mojo.EventType _stringToMojoEventType(String eventType) {
  switch(eventType) {
    case "value": return mojo.EventType.EventTypeValue;
    case "child_added": return mojo.EventType.EventTypeChildAdded;
    case "child_changed": return mojo.EventType.EventTypeChildChanged;
    case "child_removed": return mojo.EventType.EventTypeChildRemoved;
    case "child_moved": return mojo.EventType.EventTypeChildMoved;
    default:
      assert(false);
      return null;
  }
}
