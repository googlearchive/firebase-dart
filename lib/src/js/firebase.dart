library firebase.js.firebase;

import 'dart:js';
import 'dart:async';

import 'auth_response.dart';
import 'data_snapshot.dart';
import 'disconnect.dart';
import 'util.dart';

import '../event.dart';
import '../firebase.dart';
import '../transaction_result.dart';
import '../disconnect.dart';

Firebase createFirebase(String url) => new JsFirebase(url);
final serverValue = new _ServerValue();

class JsFirebase extends JsQuery implements Firebase {
  Stream<Event> _onAuth;
  Disconnect _onDisconnect;

  JsFirebase(String url) : super(url);

  JsFirebase.fromJsObject(JsObject obj) : super.fromJsObject(obj);

  Disconnect get onDisconnect {
    if (_onDisconnect == null) {
      _onDisconnect = new JsDisconnect(_fb.callMethod('onDisconnect'));
    }
    return _onDisconnect;
  }

  @deprecated
  Future auth(String token) {
    var c = new Completer();
    // On failure, the first argument will be an Error object indicating the
    // failure. On success, the first argument will be null and the second
    // will be an object containing { auth: <auth payload>, expires:
    // <expiration time in seconds since the unix epoch> }.
    _fb.callMethod('auth', [
      token,
      _getAuthCallback(c),
      (err) {
        c.completeError(err);
      }
    ]);
    return c.future;
  }

  Future authWithCustomToken(String token) {
    var c = new Completer();
    _fb.callMethod('authWithCustomToken', [token, _getAuthCallback(c)]);
    return c.future;
  }

  Future authAnonymously({remember: 'default'}) {
    var c = new Completer();
    _fb.callMethod('authAnonymously', [
      _getAuthCallback(c),
      jsify({'remember': remember})
    ]);
    return c.future;
  }

  Future authWithPassword(Map credentials) {
    var c = new Completer();
    // On failure, the first argument will be an Error object indicating the
    // failure. On success, the first argument will be null and the second
    // will be an object containing { auth: <auth payload>, expires:
    // <expiration time in seconds since the unix epoch> }.
    _fb.callMethod(
        'authWithPassword', [jsify(credentials), _getAuthCallback(c)]);
    return c.future;
  }

  Future authWithOAuthPopup(provider, {remember: 'default', scope: ''}) {
    var c = new Completer();
    _fb.callMethod('authWithOAuthPopup', [
      provider,
      _getAuthCallback(c),
      jsify({'remember': remember, 'scope': scope})
    ]);
    return c.future;
  }

  Future authWithOAuthRedirect(provider, {remember: 'default', scope: ''}) {
    var c = new Completer();
    _fb.callMethod('authWithOAuthRedirect', [
      provider,
      _getAuthCallback(c),
      jsify({'remember': remember, 'scope': scope})
    ]);
    return c.future;
  }

  Future authWithOAuthToken(provider, credentials,
      {remember: 'default', scope: ''}) {
    var c = new Completer();
    _fb.callMethod('authWithOAuthToken', [
      provider,
      jsify(credentials),
      _getAuthCallback(c),
      jsify({'remember': remember, 'scope': scope})
    ]);
    return c.future;
  }

  ZoneBinaryCallback _getAuthCallback(Completer c) {
    return (err, [result]) {
      if (err != null) {
        c.completeError(err);
      } else {
        c.complete(decodeAuthData(result));
      }
    };
  }

  dynamic getAuth() {
    var authResponse = _fb.callMethod('getAuth');
    return authResponse == null ? null : decodeAuthData(authResponse);
  }

  Stream onAuth([context]) {
    if (_onAuth == null) {
      StreamController controller;

      if (context == null) {
        context = {};
      }

      void _handleOnAuth(authData) {
        if (authData != null) {
          controller.add(decodeAuthData(authData));
        } else {
          controller.add(null);
        }
      }

      void startListen() {
        _fb.callMethod('onAuth', [_handleOnAuth, jsify(context)]);
      }
      void stopListen() {
        _fb.callMethod('offAuth', [_handleOnAuth, jsify(context)]);
      }
      controller = new StreamController.broadcast(
          onListen: startListen, onCancel: stopListen, sync: false);
      return controller.stream;
    }
    return _onAuth;
  }

  void unauth() {
    _fb.callMethod('unauth');
  }

  Firebase child(String path) =>
      new JsFirebase.fromJsObject(_fb.callMethod('child', [path]));

  Firebase parent() {
    var parentFb = _fb.callMethod('parent');
    return parentFb == null ? null : new JsFirebase.fromJsObject(parentFb);
  }

  /**
   * Get a Firebase reference for the root of the Firebase.
   */
  Firebase root() => new JsFirebase.fromJsObject(_fb.callMethod('root'));

  String get key => _fb.callMethod('key');

  String toString() {
    return _fb.toString();
  }

  Future set(value) {
    var c = new Completer();
    value = jsify(value);
    _fb.callMethod('set', [
      value,
      (err) {
        _resolveFuture(c, err, null);
      }
    ]);
    return c.future;
  }

  Future update(Map<String, dynamic> value) {
    var c = new Completer();
    var jsValue = jsify(value);
    _fb.callMethod('update', [
      jsValue,
      (err) {
        _resolveFuture(c, err, null);
      }
    ]);
    return c.future;
  }

  Future remove() {
    var c = new Completer();
    _fb.callMethod('remove', [
      (err) {
        _resolveFuture(c, err, null);
      }
    ]);
    return c.future;
  }

  Firebase push({value, onComplete}) =>
      new JsFirebase.fromJsObject(_fb.callMethod('push', [
        value == null ? null : jsify(value),
        (error) {
          if (onComplete != null) {
            onComplete(error);
          }
        }
      ]));

  Future setWithPriority(value, int priority) {
    var c = new Completer();
    value = jsify(value);
    _fb.callMethod('setWithPriority', [
      value,
      priority,
      (err) {
        _resolveFuture(c, err, null);
      }
    ]);
    return c.future;
  }

  Future setPriority(int priority) {
    var c = new Completer();
    _fb.callMethod('setPriority', [
      priority,
      (err) {
        _resolveFuture(c, err, null);
      }
    ]);
    return c.future;
  }

  Future<TransactionResult> transaction(update(currentVal),
      {bool applyLocally: true}) {
    var c = new Completer();
    _fb.callMethod('transaction', [
      Zone.current.bindUnaryCallback((val) {
        var retValue = update(val);
        return jsify(retValue);
      }),
      (err, committed, snapshot) {
        if (err != null) {
          c.completeError(err);
        } else {
          snapshot = new JsDataSnapshot.fromJsObject(snapshot);
          c.complete(new TransactionResult(err, committed, snapshot));
        }
      },
      applyLocally
    ]);
    return c.future;
  }

  Future createUser(Map credentials) {
    var c = new Completer();
    _fb.callMethod('createUser', [
      jsify(credentials),
      (err, [userData]) {
        _resolveFuture(c, err, userData);
      }
    ]);
    return c.future;
  }

  Future changeEmail(Map credentials) {
    var c = new Completer();
    _fb.callMethod('changeEmail', [
      jsify(credentials),
      (err) {
        _resolveFuture(c, err, null);
      }
    ]);
    return c.future;
  }

  Future changePassword(Map credentials) {
    var c = new Completer();
    _fb.callMethod('changePassword', [
      jsify(credentials),
      (err) {
        _resolveFuture(c, err, null);
      }
    ]);
    return c.future;
  }

  Future removeUser(Map credentials) {
    var c = new Completer();
    _fb.callMethod('removeUser', [
      jsify(credentials),
      (err) {
        _resolveFuture(c, err, null);
      }
    ]);
    return c.future;
  }

  Future resetPassword(Map credentials) {
    var c = new Completer();
    _fb.callMethod('resetPassword', [
      jsify(credentials),
      (err) {
        _resolveFuture(c, err, null);
      }
    ]);
    return c.future;
  }

  void _resolveFuture(Completer c, err, res) {
    if (err != null) {
      c.completeError(err);
    } else {
      c.complete(res);
    }
  }
}

class _ServerValue {
  final TIMESTAMP = context['Firebase']['ServerValue']['TIMESTAMP'];
}

class JsQuery implements Query {
  final JsObject _fb;
  Stream<Event> _onValue;
  Stream<Event> _onChildAdded;
  Stream<Event> _onChildMoved;
  Stream<Event> _onChildChanged;
  Stream<Event> _onChildRemoved;

  JsQuery(String url) : _fb = new JsObject(context['Firebase'], [url]);

  JsQuery.fromJsObject(JsObject obj) : _fb = obj;

  Stream<Event> _createStream(String type) {
    StreamController<Event> controller;

    // the first argument is to align with the implementation of
    // JsFunction.withThis – the first arg is 'this'
    void addEvent(_, snapshot, [prevChild]) {
      controller
          .add(new Event(new JsDataSnapshot.fromJsObject(snapshot), prevChild));
    }

    // using this wrapper to avoid a checked-mode warning about the function
    // not being a JSObject.
    var jsFunc = new JsFunction.withThis(addEvent);

    void startListen() {
      _fb.callMethod('on', [type, jsFunc]);
    }
    void stopListen() {
      _fb.callMethod('off', [type]);
    }
    controller = new StreamController<Event>.broadcast(
        onListen: startListen, onCancel: stopListen, sync: true);
    return controller.stream;
  }

  Stream<Event> get onValue {
    if (_onValue == null) {
      _onValue = this._createStream('value');
    }
    return _onValue;
  }

  Stream<Event> get onChildAdded {
    if (_onChildAdded == null) {
      _onChildAdded = this._createStream('child_added');
    }
    return _onChildAdded;
  }

  Stream<Event> get onChildMoved {
    if (_onChildMoved == null) {
      _onChildMoved = this._createStream('child_moved');
    }
    return _onChildMoved;
  }

  Stream<Event> get onChildChanged {
    if (_onChildChanged == null) {
      _onChildChanged = this._createStream('child_changed');
    }
    return _onChildChanged;
  }

  Stream<Event> get onChildRemoved {
    if (_onChildRemoved == null) {
      _onChildRemoved = this._createStream('child_removed');
    }
    return _onChildRemoved;
  }

  Future<DataSnapshot> once(String eventType) {
    var completer = new Completer<DataSnapshot>();

    _fb.callMethod('once', [
      eventType,
      (jsSnapshot) {
        var snapshot = new JsDataSnapshot.fromJsObject(jsSnapshot);
        completer.complete(snapshot);
      },
      (error) {
        completer.completeError(error);
      }
    ]);
    return completer.future;
  }

  Query orderByChild(String key) =>
      new JsQuery.fromJsObject(_fb.callMethod('orderByChild', [key]));

  Query orderByKey() => new JsQuery.fromJsObject(_fb.callMethod('orderByKey'));

  Query orderByValue() =>
      new JsQuery.fromJsObject(_fb.callMethod('orderByValue'));

  Query orderByPriority() =>
      new JsQuery.fromJsObject(_fb.callMethod('orderByPriority'));

  Query startAt({dynamic value, String key}) => new Query.fromJsObject(
      _fb.callMethod('startAt', _removeTrailingNulls([value, key])));

  Query endAt({dynamic value, String key}) => new Query.fromJsObject(
      _fb.callMethod('endAt', _removeTrailingNulls([value, key])));

  Query equalTo(value, [key]) {
    var args = key == null ? [value] : [value, key];
    return new JsQuery.fromJsObject(_fb.callMethod('equalTo', args));
  }

  Query limitToFirst(int limit) =>
      new JsQuery.fromJsObject(_fb.callMethod('limitToFirst', [limit]));

  Query limitToLast(int limit) =>
      new JsQuery.fromJsObject(_fb.callMethod('limitToLast', [limit]));

  @deprecated
  Query limit(int limit) =>
      new JsQuery.fromJsObject(_fb.callMethod('limit', [limit]));

  Firebase ref() => new JsFirebase.fromJsObject(_fb.callMethod('ref'));
}

List _removeTrailingNulls(List args) {
  while (args.isNotEmpty && args.last == null) {
    args.removeLast();
  }
  return args;
}
