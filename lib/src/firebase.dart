library firebase.firebase;

import 'dart:async';

import 'data_snapshot.dart';
import 'disconnect.dart';
import 'event.dart';
import 'transaction_result.dart';

import 'firebase_factory.dart'
  if (dart.library.js) 'js/firebase.dart'
  if (dart.library.ui) 'mojo/firebase.dart';

/**
 * A Firebase represents a particular location in your Firebase and can be used
 * for reading or writing data to that Firebase location.
 */
abstract class Firebase extends Query {
  /**
   * Construct a new Firebase reference from a full Firebase URL.
   */
  factory Firebase(String url) => createFirebase(url);

  /**
   * Getter for onDisconnect.
   */
  Disconnect get onDisconnect;

  /**
   * Authenticates a Firebase client using a provided Authentication token.
   * Takes a single token as an argument and returns a Future that will be
   * resolved when the authentication succeeds (or fails).
   *
   * auth in the Firebase JS library has been deprecated. The same behaviour is
   * now achieved by using authWithCustomToken
   */
  @deprecated
  Future auth(String token);

  /**
   * Authenticates a Firebase client using an authentication token or Firebase Secret.
   * Takes a single token as an argument and returns a Future that will be
   * resolved when the authentication succeeds (or fails).
   */
  Future authWithCustomToken(String token);

  /**
   * Authenticates a Firebase client using a new, temporary guest account.
   */
  // https://www.firebase.com/docs/web/guide/login/anonymous.html#section-logging-in
  Future authAnonymously({remember: 'default'});

  /**
   * Authenticates a Firebase client using an email / password combination.
   */
  Future authWithPassword(Map credentials);

  /**
   * Authenticates a Firebase client using a third party provider (github, twitter,
   * google, facebook). This method presents login form with a popup.
   */
  Future authWithOAuthPopup(provider, {remember: 'default', scope: ''});

  /**
   * Authenticates a Firebase client using a third party provider (github, twitter,
   * google, facebook). This method redirects to a login form, then back to your app.
   */
  Future authWithOAuthRedirect(provider, {remember: 'default', scope: ''});

  /**
   * Authenticates a Firebase client using OAuth access tokens or credentials.
   */
  Future authWithOAuthToken(provider, credentials,
      {remember: 'default', scope: ''});

  /**
   * Synchronously retrieves the current authentication state of the client.
   */
  dynamic getAuth();

  /**
   * Listens for changes to the client's authentication state.
   */
  Stream onAuth([context]);

  /**
   * Unauthenticates a Firebase client (i.e. logs out).
   */
  void unauth();

  /**
   * Get a Firebase reference for a location at the specified relative path.
   *
   * The relative path can either be a simple child name, (e.g. 'fred') or a
   * deeper slash separated path (e.g. 'fred/name/first').
   */
  Firebase child(String path);

  /**
   * Get a Firebase reference for the parent location. If this instance refers
   * to the root of your Firebase, it has no parent, and therefore parent()
   * will return null.
   */
  Firebase parent();

  /**
   * Get a Firebase reference for the root of the Firebase.
   */
  Firebase root();

  /**
   * Returns the last token in a Firebase location.
   * [key] on the root of a Firebase is `null`.
   */
  String get key;

  /**
   * Gets the absolute URL corresponding to this Firebase reference's location.
   */
  String toString();

  /**
   * Write data to this Firebase location. This will overwrite any data at
   * this location and all child locations.
   *
   * The effect of the write will be visible immediately and the corresponding
   * events ('onValue', 'onChildAdded', etc.) will be triggered.
   * Synchronization of the data to the Firebase servers will also be started,
   * and the Future returned by this method will complete after synchronization
   * has finished.
   *
   * Passing null for the new value is equivalent to calling remove().
   *
   * A single set() will generate a single onValue event at the location where
   * the set() was performed.
   */
  Future set(value);

  /**
   * Write the enumerated children to this Firebase location. This will only
   * overwrite the children enumerated in the 'value' parameter and will leave
   * others untouched.
   *
   * The returned Future will be complete when the synchronization has
   * completed with the Firebase servers.
   */
  Future update(Map<String, dynamic> value);

  /**
   * Remove the data at this Firebase location. Any data at child locations
   * will also be deleted.
   *
   * The effect of this delete will be visible immediately and the
   * corresponding events (onValue, onChildAdded, etc.) will be triggered.
   * Synchronization of the delete to the Firebase servers will also be
   * started, and the Future returned by this method will complete after the
   * synchronization has finished.
   */
  Future remove();

  /**
   * Push generates a new child location using a unique name and returns a
   * Firebase reference to it. This is useful when the children of a Firebase
   * location represent a list of items.
   *
   * The unique name generated by push() is prefixed with a client-generated
   * timestamp so that the resulting list will be chronologically sorted.
   */
  Firebase push({value, onComplete});

  /**
   * Write data to a Firebase location, like set(), but also specify the
   * priority for that data. Identical to doing a set() followed by a
   * setPriority(), except it is combined into a single atomic operation to
   * ensure the data is ordered correctly from the start.
   *
   * Returns a Future which will complete when the data has been synchronized
   * with Firebase.
   */
  Future setWithPriority(value, int priority);

  /**
   * Set a priority for the data at this Firebase location. A priority can
   * be either a number or a string and is used to provide a custom ordering
   * for the children at a location. If no priorities are specified, the
   * children are ordered by name. This ordering affects the enumeration
   * order of DataSnapshot.forEach(), as well as the prevChildName parameter
   * passed to the onChildAdded and onChildMoved event handlers.
   *
   * You cannot set a priority on an empty location. For this reason,
   * setWithPriority() should be used when setting initial data with a
   * specific priority, and this function should be used when updating the
   * priority of existing data.
   */
  Future setPriority(int priority);

  /**
   * Atomically modify the data at this location. Unlike a normal set(), which
   * just overwrites the data regardless of its previous value, transaction()
   * is used to modify the existing value to a new value, ensuring there are
   * no conflicts with other clients writing to the same location at the same
   * time.
   *
   * To accomplish this, you pass [transaction] an update function which is
   * used to transform the current value into a new value. If another client
   * writes to the location before your new value is successfully written,
   * your update function will be called again with the new current value, and
   * the write will be retried. This will happen repeatedly until your write
   * succeeds without conflict or you abort the transaction by not returning
   * a value from your update function.
   *
   * The returned [Future] will be completed after the transaction has
   * finished.
   */
  Future<TransactionResult> transaction(update(currentVal),
      {bool applyLocally: true});

  /**
   * Creates a new user account using an email / password combination.
   */
  Future createUser(Map credentials);

  /**
   * Updates the email associated with an email / password user account.
   */
  Future changeEmail(Map credentials);

  /**
   * Changes the password of an existing user using an email / password combination.
   */
  Future changePassword(Map credentials);

  /**
   * Removes an existing user account using an email / password combination.
   */
  Future removeUser(Map credentials);

  /**
   * Sends a password-reset email to the owner of the account, containing a
   * token that may be used to authenticate and change the user's password.
   */
  Future resetPassword(Map credentials);

  static get ServerValue => serverValue;
}

abstract class Query {
  /**
   * Streams for various data events.
   */
  Stream<Event> get onValue;

  Stream<Event> get onChildAdded;

  Stream<Event> get onChildMoved;

  Stream<Event> get onChildChanged;

  Stream<Event> get onChildRemoved;

  /**
   * Listens for exactly one event of the specified event type, and then stops
   * listening.
   */
  Future<DataSnapshot> once(String eventType);

  /**
   * Generates a new Query object ordered by the specified child key.
   */
  Query orderByChild(String key);

  /**
   * Generates a new Query object ordered by key.
   */
  Query orderByKey();

  /**
   * Generates a new Query object ordered by child values.
   */
  Query orderByValue();

  /**
   * Generates a new Query object ordered by priority.
   */
  Query orderByPriority();

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
  Query startAt({dynamic value, String key});

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
  Query endAt({dynamic value, String key});

  /**
   * Creates a Query which includes children which match the specified value.
   */
  Query equalTo(value, [key]);

  /**
   * Generates a new Query object limited to the first certain number of children.
   */
  Query limitToFirst(int limit);

  /**
   * Generates a new Query object limited to the last certain number of children.
   */
  Query limitToLast(int limit);

  /**
   * Generate a Query object limited to the number of specified children. If
   * combined with startAt, the query will include the specified number of
   * children after the starting point. If combined with endAt, the query will
   * include the specified number of children before the ending point. If not
   * combined with startAt() or endAt(), the query will include the last
   * specified number of children.
   */
  @deprecated
  Query limit(int limit);

  /**
   * Queries are attached to a location in your Firebase. This method will
   * return a Firebase reference to that location.
   */
  Firebase ref();
}
