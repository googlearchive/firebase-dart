library firebase.firebase;

import 'dart:async';

import '../firebase.dart';
import '../disconnect.dart';
import '../event.dart';
import '../data_snapshot.dart';
import '../transaction_result.dart';

class FirebaseImpl extends MojoFirebase {
  FirebaseImpl(String url) : super(url);
  static final ServerValue = null;
}

class MojoFirebase extends MojoQuery implements Firebase {
  MojoFirebase(String url) : super(url);

  Disconnect get onDisconnect => null;

  @deprecated
  Future auth(String token) => null;

  Future authWithCustomToken(String token) => null;

  Future authAnonymously({remember: 'default'}) => null;

  Future authWithPassword(Map credentials) => null;

  Future authWithOAuthPopup(provider, {remember: 'default', scope: ''}) => null;

  Future authWithOAuthRedirect(provider, {remember: 'default', scope: ''}) => null;

  Future authWithOAuthToken(provider, credentials,
      {remember: 'default', scope: ''}) => null;

  dynamic getAuth() => null;

  Stream onAuth([context]) => null;

  void unauth() => null;

  Firebase child(String path) => null;

  Firebase parent() => null;

  Firebase root() => null;

  String get key => null;

  String toString() => null;

  Future set(value) => null;

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

class MojoQuery implements Query {

  /**
   * Construct a new default Query for a given URL.
   */
  MojoQuery(String url);

  /**
   * Streams for various data events.
   */
  Stream<Event> get onValue => null;

  Stream<Event> get onChildAdded => null;

  Stream<Event> get onChildMoved => null;

  Stream<Event> get onChildChanged => null;

  Stream<Event> get onChildRemoved => null;

  /**
   * Listens for exactly one event of the specified event type, and then stops
   * listening.
   */
  Future<DataSnapshot> once(String eventType) => null;

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
