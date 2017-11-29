import 'dart:async';
import 'dart:typed_data' show Uint8List;

import 'package:func/func.dart';
import 'package:js/js.dart';

import 'app.dart';
import 'interop/firestore_interop.dart' as firestore_interop;
import 'js.dart';
import 'utils.dart';

export 'interop/firestore_interop.dart'
    show FieldValue, FieldPath, SetOptions, Settings;
// TODO export more stuff

/// The Cloud Firestore service interface.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.firestore.Firestore>.
class Firestore extends JsObjectWrapper<firestore_interop.FirestoreJsImpl> {
  static final _expando = new Expando<Firestore>();

  /// App for this instance of firestore service.
  App get app => App.get(jsObject.app);

  /// Creates a new Firestore from a [jsObject].
  static Firestore get(firestore_interop.FirestoreJsImpl jsObject) {
    if (jsObject == null) {
      return null;
    }
    return _expando[jsObject] ??= new Firestore._fromJsObject(jsObject);
  }

  Firestore._fromJsObject(firestore_interop.FirestoreJsImpl jsObject)
      : super.fromJsObject(jsObject);

  /// Creates a write batch, used for performing multiple writes
  /// as a single atomic operation.
  ///
  /// Returns non-null [WriteBatch] that can be used to atomically execute
  /// multiple writes.
  WriteBatch batch() => WriteBatch.get(jsObject.batch());

  /// Gets a slash-separated path to a collection.
  /// The [collectionPath] parameter is a slash-separated path to a collection.
  ///
  /// Returns non-null [CollectionReference] instance.
  CollectionReference collection(String collectionPath) =>
      CollectionReference.getInstance(jsObject.collection(collectionPath));

  /// Gets a [DocumentReference] instance that refers to
  /// the document at the specified path.
  /// The [documentPath] parameter is a slash-separated path to a document.
  ///
  /// Returns non-null [DocumentReference] instance.
  DocumentReference doc(String documentPath) =>
      DocumentReference.getInstance(jsObject.doc(documentPath));

  /// Attempts to enable persistent storage, if possible.
  ///
  /// Must be called before any other methods (other than [settings()]).
  ///
  /// If this fails, [enablePersistence()] will reject the Future it returns.
  /// Note that even after this failure, the firestore instance will remain
  /// usable, however offline persistence will be disabled.
  ///
  /// There are several reasons why this can fail, which can be identified by
  /// the `code` on the error.
  /// * failed-precondition: The app is already open in another browser tab.
  /// * unimplemented: The browser is incompatible with the offline
  /// persistence implementation.
  ///
  /// Returns non-null [Future] that represents successfully enabling
  /// persistent storage.
  Future<Null> enablePersistence() =>
      handleThenable(jsObject.enablePersistence());

  /// Executes the given [updateFunction] and then attempts to commit the
  /// changes applied within the transaction. If any document read within
  /// the transaction has changed, Cloud Firestore retries
  /// the [updateFunction].
  /// If it fails to commit after 5 attempts, the transaction fails.
  ///
  /// Returns non-null [Future] if the transaction completed successfully
  /// or was explicitly aborted (the [updateFunction] returned a failed Future),
  /// the Future returned by the [updateFunction] is returned here.
  /// Else, if the transaction failed, a rejected Future with the corresponding
  /// failure error will be returned.
  Future runTransaction(updateFunction(Transaction transaction)) {
    var updateFunctionWrap = allowInterop((transaction) => handleFuture(
        updateFunction(Transaction.getInstance(transaction)), (v) => jsify(v)));

    return handleThenableWithMapper(
        jsObject.runTransaction(updateFunctionWrap), (d) => dartify(d));
  }

  /// Sets the verbosity of Cloud Firestore logs.
  ///
  /// Parameter [logLevel] is the verbosity you set for activity and
  /// error logging.
  /// Can be any of the following values:
  /// * [:debug:] for the most verbose logging level, primarily for debugging.
  /// * [:error:] to log errors only.
  /// * [:silent:] to turn off logging.
  void setLogLevel(String logLevel) => jsObject.setLogLevel(logLevel);

  /// Specifies custom [Settings] to be used to configure the Firestore
  /// instance. Must be set before invoking any other methods.
  ///
  /// The [Settings] parameter is the settings for your Cloud Firestore instance.
  /// Value must not be null.
  void settings(firestore_interop.Settings settings) =>
      jsObject.settings(settings);
}

/// An immutable object representing a List of bytes.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.firestore.Blob>.
class Blob extends JsObjectWrapper<firestore_interop.BlobJsImpl> {
  Blob.fromJsObject(firestore_interop.BlobJsImpl jsObject)
      : super.fromJsObject(jsObject);

  /// Creates a new Blob from the given [base64] string, converting it to bytes.
  static Blob fromBase64String(String base64) => new Blob.fromJsObject(
      firestore_interop.BlobJsImpl.fromBase64String(base64));

  /// Creates a new Blob from the given Uint8List.
  /// The [list] parameter must not be null.
  static Blob fromUint8List(Uint8List list) =>
      new Blob.fromJsObject(firestore_interop.BlobJsImpl.fromUint8Array(list));

  /// Returns the bytes of this Blob as a Base64-encoded string.
  String toBase64() => jsObject.toBase64();

  /// Returns the bytes of this Blob in a new Uint8List.
  Uint8List toUint8List() => jsObject.toUint8Array();
}

/// A write batch, used to perform multiple writes as a single atomic unit.
///
/// A [WriteBatch] object can be acquired by calling the [Firestore.batch()]
/// function. It provides methods for adding writes to the write batch.
/// None of the writes are committed (or visible locally) until
/// [WriteBatch.commit()] is called.
///
/// Unlike transactions, write batches are persisted offline and therefore
/// are preferable when you don't need to condition your writes on read data.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.firestore.WriteBatch>.
class WriteBatch extends JsObjectWrapper<firestore_interop.WriteBatchJsImpl> {
  static final _expando = new Expando<WriteBatch>();

  /// Creates a new WriteBatch from a [jsObject].
  static WriteBatch get(firestore_interop.WriteBatchJsImpl jsObject) {
    if (jsObject == null) {
      return null;
    }
    return _expando[jsObject] ??= new WriteBatch._fromJsObject(jsObject);
  }

  WriteBatch._fromJsObject(firestore_interop.WriteBatchJsImpl jsObject)
      : super.fromJsObject(jsObject);

  /// Commits all of the writes in this write batch as a single atomic unit.
  ///
  /// Returns non-null [Future] that resolves once all of the writes in the
  /// batch have been successfully written to the backend as an atomic unit.
  /// Note that it won't resolve while you're offline.
  Future<Null> commit() => handleThenable(jsObject.commit());

  /// Deletes the document referred to by the provided [DocumentReference].
  ///
  /// [DocumentReference] is a reference to the document to be deleted.
  /// Value must not be null.
  ///
  /// Returns non-null [WriteBatch] instance. Used for chaining method calls.
  WriteBatch delete(DocumentReference documentRef) =>
      WriteBatch.get(jsObject.delete(documentRef.jsObject));

  /// Writes to the document referred to by the provided [DocumentReference].
  /// If the document does not exist yet, it will be created.
  /// If you pass [options], the provided data can be merged into
  /// the existing document.
  ///
  /// The [DocumentReference] parameter is a reference to the document to be
  /// created. Value must not be null.
  ///
  /// The [data] parameter is an object of the fields and values
  /// for the document. Value must not be null.
  ///
  /// The optional [SetOptions] parameters is an object to configure the set
  /// behavior. Pass [: {merge: true} :] to only replace the values specified in
  /// the data argument. Fields omitted will remain untouched. Value may be null.
  ///
  /// Returns non-null [WriteBatch] instance. Used for chaining method calls.
  // TODO shouldnt be SetOptions Map?
  WriteBatch set(DocumentReference documentRef, data,
      [firestore_interop.SetOptions options]) {
    var jsObjectSet = (options != null)
        ? jsObject.set(documentRef.jsObject, jsify(data), options)
        : jsObject.set(documentRef.jsObject, jsify(data));
    return WriteBatch.get(jsObjectSet);
  }

  /// Updates fields in the document referred to by this [DocumentReference].
  /// The update will fail if applied to a document that does not exist.
  ///
  /// Nested fields can be updated by providing dot-separated field path strings
  /// or by providing [FieldPath] objects.
  ///
  /// The [DocumentReference] parameter is a reference to the document to
  /// be updated. Value must not be null.
  ///
  /// TODO: Either an object containing all of the fields and values to update,
  /// or a series of arguments alternating between fields
  /// (as string or [FieldPath] objects) and values. Value may be repeated.
  // TODO this method needs more work
  WriteBatch update(
          DocumentReference documentRef, Map<dynamic, dynamic> args) =>
      null;
}

/// A [DocumentReference] refers to a document location in a
/// Firestore database and can be used to write, read, or listen to the location.
/// The document at the referenced location may or may not exist.
///
/// A [DocumentReference] can also be used to create a [CollectionReference]
/// to a subcollection.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.firestore.DocumentReference>.
class DocumentReference
    extends JsObjectWrapper<firestore_interop.DocumentReferenceJsImpl> {
  static final _expando = new Expando<DocumentReference>();

  /// Non-null [Firestore] the document is in.
  /// This is useful for performing transactions, for example.
  Firestore get firestore => Firestore.get(jsObject.firestore);

  /// The document's identifier within its collection.
  String get id => jsObject.id;

  /// Non-null [CollectionReference].
  /// The Collection this [DocumentReference] belongs to.
  CollectionReference get parent =>
      CollectionReference.getInstance(jsObject.parent);

  /// Creates a new DocumentReference from a [jsObject].
  static DocumentReference getInstance(
      firestore_interop.DocumentReferenceJsImpl jsObject) {
    if (jsObject == null) {
      return null;
    }
    return _expando[jsObject] ??= new DocumentReference._fromJsObject(jsObject);
  }

  DocumentReference._fromJsObject(
      firestore_interop.DocumentReferenceJsImpl jsObject)
      : super.fromJsObject(jsObject);

  /// Gets a [CollectionReference] instance that refers to the collection at
  /// the specified path.
  ///
  /// The [collectionPath] parameter is a slash-separated path to a collection.
  ///
  /// Returns non-null [CollectionReference] instance.
  CollectionReference collection(String collectionPath) =>
      CollectionReference.getInstance(jsObject.collection(collectionPath));

  /// Deletes the document referred to by this [DocumentReference].
  ///
  /// Returns non-null [Future] that resolves once the document has been
  /// successfully deleted from the backend (Note that it won't resolve
  /// while you're offline).
  Future<Null> delete() => handleThenable(jsObject.delete());

  /// Reads the document referred to by this [DocumentReference].
  /// Note: [get()] attempts to provide up-to-date data when possible
  /// by waiting for data from the server, but it may return cached data or
  /// fail if you are offline and the server cannot be reached.
  ///
  /// Returns non-null [Future] containing non-null [DocumentSnapshot]
  /// that resolves with a [DocumentSnapshot] containing the current document
  /// contents.
  Future<DocumentSnapshot> get() =>
      handleThenableWithMapper(jsObject.get(), DocumentSnapshot.getInstance);

  // TODO implement
  VoidFunc0 onSnapshot(optionsOrObserverOrOnNext, observerOrOnNextOrOnError,
          [Func1<FirebaseError, dynamic> onError]) =>
      null;

  /// Writes to the document referred to by this [DocumentReference].
  /// If the document does not exist yet, it will be created.
  /// If you pass [options], the provided data can be merged into the
  /// existing document.
  ///
  /// The [data] parameter is an object of the fields and values for the
  /// document. Value must not be null.
  ///
  /// The optional [SetOptions] is an object to configure the set behavior.
  /// Pass [: {merge: true} :] to only replace the values specified in the data
  /// argument. Fields omitted will remain untouched. Value may be null.
  ///
  /// Returns non-null [Future] that resolves once the data has been successfully
  /// written to the backend. (Note that it won't resolve while you're offline).
  Future<Null> set(data, [firestore_interop.SetOptions options]) {
    var jsObjectSet = (options != null)
        ? jsObject.set(jsify(data), options)
        : jsObject.set(jsify(data));
    return handleThenable(jsObjectSet);
  }

  /// Updates fields in the document referred to by this [DocumentReference].
  /// The update will fail if applied to a document that does not exist.
  ///
  /// Nested fields can be updated by providing dot-separated field path strings.
  ///
  /// The [data] param is the object containing all of the fields and values
  /// to update.
  ///
  /// Returns non-null [Future] that resolves once the data has been successfully
  /// written to the backend (Note that it won't resolve while you're offline).
  // TODO in future: varargs parameter
  Future<Null> update(Map<String, dynamic> data) =>
      handleThenable(jsObject.update(jsify(data)));
}

/// A Query refers to a Query which you can read or listen to.
/// You can also construct refined [Query] objects by adding filters
/// and ordering.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.firestore.Query>.
class Query<T extends firestore_interop.QueryJsImpl>
    extends JsObjectWrapper<T> {
  /// Non-null [Firestore] for the Cloud Firestore database
  /// (useful for performing transactions, etc.).
  Firestore get firestore => Firestore.get(jsObject.firestore);

  /// Creates a new Query from a [jsObject].
  Query.fromJsObject(T jsObject) : super.fromJsObject(jsObject);

  /// Creates a new [Query] where the results end at the provided document
  /// (inclusive). The end position is relative to the order of the query.
  /// The document must contain all of the fields provided in the orderBy
  /// of this query.
  ///
  /// Parameter is the [DocumentSnapshot] of the document the query results
  /// should end at or the field values to start this query at, in order of
  /// the query's order by.
  ///
  /// Returns non-null created [Query].
  ///
  // TODO parameter
  Query endAt(dynamic /*DocumentSnapshot|List<dynamic>*/ snapshotOrVarArgs) =>
      new Query.fromJsObject(jsObject.endAt(snapshotOrVarArgs));

  /// Creates a new [Query] where the results end before the provided document
  /// (exclusive). The end position is relative to the order of the query.
  /// The document must contain all of the fields provided in the orderBy of
  /// this query.
  ///
  /// Parameter is the [DocumentSnapshot] of the document the query results
  /// should end before or the field values to start this query at, in order of
  /// the query's order by.
  ///
  /// Returns non-null created [Query].
  ///
  // TODO DocumentSnapshot convert
  Query endBefore(
          dynamic /*DocumentSnapshot|List<dynamic>*/ snapshotOrVarArgs) =>
      new Query.fromJsObject(jsObject.endBefore(snapshotOrVarArgs));

  /// Executes the query and returns the results as a [QuerySnapshot].
  ///
  /// Returns non-null Future that will be resolved with the results of the
  /// query.
  Future<QuerySnapshot> get() =>
      handleThenableWithMapper(jsObject.get(), QuerySnapshot.get);

  /// Creates a new [Query] where the results are limited to the specified
  /// number of documents.
  ///
  /// The [limit] parameter is the maximum number of items to return.
  ///
  /// Returns non-null created [Query].
  Query limit(num limit) => new Query.fromJsObject(jsObject.limit(limit));

  // TODO implement
  VoidFunc0 onSnapshot(optionsOrObserverOrOnNext, observerOrOnNextOrOnError,
          [Func1<FirebaseError, dynamic> onError,
          firestore_interop.QueryListenOptions onCompletion]) =>
      null;

  /// Creates a new [Query] where the results are sorted by the specified field,
  /// in descending or ascending order.
  ///
  /// The [fieldPath] parameter is a String or [FieldPath] to sort by.
  ///
  /// The optional [directionStr] parameter is a direction to sort by
  /// ([:asc:] or [:desc:]). If not specified, the default order is ascending.
  ///
  /// Returns non-null created [Query].
  // TODO implement
  Query orderBy(/*String|FieldPath*/ fieldPath,
          [String /*'desc'|'asc'*/ directionStr]) =>
      new Query.fromJsObject(jsObject.orderBy(fieldPath, directionStr));

  /// Creates a new [Query] where the results start after the provided document
  /// (exclusive). The starting position is relative to the order of the query.
  /// The document must contain all of the fields provided in the [orderBy]
  /// of this query.
  ///
  /// The [snapshotOrVarArgs] parameter is the [DocumentSnapshot] of the
  /// document to start after or the field values to start this query at,
  /// in order of the query's order by.
  ///
  /// Returns non-null created [Query].
  // TODO DocumentSnapshot convert
  Query startAfter(
          dynamic /*DocumentSnapshot|List<dynamic>*/ snapshotOrVarArgs) =>
      new Query.fromJsObject(jsObject.startAfter(snapshotOrVarArgs));

  /// Creates a new [Query] where the results start at the provided document
  /// (inclusive). The starting position is relative to the order of the query.
  /// The document must contain all of the fields provided in the orderBy of
  /// the query.
  ///
  /// The [snapshotOrVarArgs] parameter is the [DocumentSnapshot] of the
  /// document you want the query to start at or the field values to start
  /// this query at, in order of the query's order by.
  ///
  /// Returns non-null created [Query].
  // TODO DocumentSnapshot convert
  Query startAt(dynamic /*DocumentSnapshot|List<dynamic>*/ snapshotOrVarArgs) =>
      new Query.fromJsObject(jsObject.startAt(snapshotOrVarArgs));

  /// Creates a new [Query] that returns only documents that include the
  /// specified fields and where the values satisfy the constraints provided.
  ///
  /// The [fieldPath] parameter is a String or [FieldPath] to compare.
  ///
  /// The [opStr] parameter is the operation string
  /// (e.g "<", "<=", "==", ">", ">=").
  ///
  /// The [value] parameter is the value for comparison.
  /// Returns non-null created [Query].
  // TODO parameters
  Query where(dynamic /*String|FieldPath*/ fieldPath,
          String /*'<'|'<='|'=='|'>='|'>'*/ opStr, dynamic value) =>
      new Query.fromJsObject(jsObject.where(fieldPath, opStr, value));
}

/// A [CollectionReference] class can be used for adding documents,
/// getting document references, and querying for documents
/// (using the methods inherited from [Query]).
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.firestore.CollectionReference>.
class CollectionReference<T extends firestore_interop.CollectionReferenceJsImpl>
    extends Query<T> {
  static final _expando = new Expando<CollectionReference>();

  /// The collection's identifier.
  String get id => jsObject.id;

  /// Nullable reference to the containing [DocumentReference] if this is
  /// a subcollection. If this isn't a subcollection, the reference is [:null:].
  DocumentReference get parent =>
      DocumentReference.getInstance(jsObject.parent);

  /// Creates a new CollectionReference from a [jsObject].
  static CollectionReference getInstance(
      firestore_interop.CollectionReferenceJsImpl jsObject) {
    if (jsObject == null) {
      return null;
    }
    return _expando[jsObject] ??=
        new CollectionReference._fromJsObject(jsObject);
  }

  /// Creates a new CollectionReference
  factory CollectionReference() => new CollectionReference._fromJsObject(
      new firestore_interop.CollectionReferenceJsImpl());

  CollectionReference._fromJsObject(
      firestore_interop.CollectionReferenceJsImpl jsObject)
      : super.fromJsObject(jsObject);

  /// Adds a new document to this collection with the specified [data],
  /// assigning it a document ID automatically.
  ///
  /// The [data] parameter must not be null.
  ///
  /// Returns [Future] that resolves with a [DocumentReference] pointing to the
  /// newly created document after it has been written to the backend.
  Future<DocumentReference> add(data) => handleThenableWithMapper(
      jsObject.add(jsify(data)), DocumentReference.getInstance);

  /// Gets a [DocumentReference] for the document within the collection
  /// at the specified path. If no path is specified, an automatically-generated
  /// unique ID will be used for the returned [DocumentReference].
  ///
  /// The optional [documentPath] parameter is a slash-separated path to
  /// a document.
  ///
  /// Returns non-null [DocumentReference].
  DocumentReference doc([String documentPath]) {
    var jsObjectDoc =
        (documentPath != null) ? jsObject.doc(documentPath) : jsObject.doc();
    return DocumentReference.getInstance(jsObjectDoc);
  }
}

/// A [DocumentChange] represents a change to the documents matching a query.
/// It contains the document affected and the type of change that occurred.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.firestore.DocumentChange>.
// TODO finish this class
class DocumentChange extends JsObjectWrapper<firestore_interop.DocumentChange> {
  static final _expando = new Expando<DocumentChange>();

  /// Creates a new DocumentChange from a [jsObject].
  static DocumentChange get(firestore_interop.DocumentChange jsObject) {
    if (jsObject == null) {
      return null;
    }
    return _expando[jsObject] ??= new DocumentChange._fromJsObject(jsObject);
  }

  DocumentChange._fromJsObject(firestore_interop.DocumentChange jsObject)
      : super.fromJsObject(jsObject);
}

/// A [DocumentSnapshot] contains data read from a document in your
/// Cloud Firestore database. The data can be extracted with [data()] or
/// [get(<field>)] to get a specific field.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.firestore.DocumentSnapshot>.
class DocumentSnapshot
    extends JsObjectWrapper<firestore_interop.DocumentSnapshotJsImpl> {
  static final _expando = new Expando<DocumentSnapshot>();

  /// Signals whether or not the data exists. [:true:] if the document exists.
  bool get exists => jsObject.exists;

  /// Provides the document's ID.
  String get id => jsObject.id;

  /// Non-null metadata about the [DocumentSnapshot], including information
  /// about its source and local modifications.
  firestore_interop.SnapshotMetadata get metadata => jsObject.metadata;

  /// Non-null [DocumentReference] for the document included
  /// in the [DocumentSnapshot].
  DocumentReference get ref => DocumentReference.getInstance(jsObject.ref);

  /// Creates a new DocumentSnapshot from a [jsObject].
  static DocumentSnapshot getInstance(
      firestore_interop.DocumentSnapshotJsImpl jsObject) {
    if (jsObject == null) {
      return null;
    }
    return _expando[jsObject] ??= new DocumentSnapshot._fromJsObject(jsObject);
  }

  DocumentSnapshot._fromJsObject(
      firestore_interop.DocumentSnapshotJsImpl jsObject)
      : super.fromJsObject(jsObject);

  /// Retrieves all fields in the document as an object.
  ///
  /// Returns non-null data containing all fields in the specified
  /// document.
  dynamic data() => dartify(jsObject.data());

  /// Retrieves the field specified by [fieldPath] parameter at the specified
  /// field location or [:null:] if no such field exists in the document.
  ///
  /// The [fieldPath] is the String or [FieldPath] - the path
  /// (e.g. 'foo' or 'foo.bar') to a specific field.
  // TODO fieldpath
  // TODO really returns null?
  dynamic get(dynamic /*String|FieldPath*/ fieldPath) =>
      jsObject.get(fieldPath);
}

/// A [QuerySnapshot] contains zero or more [DocumentSnapshot] objects
/// representing the results of a query. The documents can be accessed as
/// an array via the docs property or enumerated using the [forEach()] method.
/// The number of documents can be determined via the empty and size properties.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.firestore.QuerySnapshot>.
class QuerySnapshot
    extends JsObjectWrapper<firestore_interop.QuerySnapshotJsImpl> {
  static final _expando = new Expando<QuerySnapshot>();

  /// Non-null list of the documents that changed since the last snapshot.
  /// If this is the first snapshot, all documents will be in the list as
  /// added changes.
  List<DocumentChange> get docChanges =>
      jsObject.docChanges.map(DocumentChange.get).toList();

  /// Non-null list of all the documents.
  List<DocumentSnapshot> get docs =>
      jsObject.docs.map(DocumentSnapshot.getInstance).toList();

  /// [:true:] if there are no documents.
  bool get empty => jsObject.empty;

  /// Non-null metadata about this snapshot, concerning its source and if it
  /// has local modifications.
  firestore_interop.SnapshotMetadata get metadata => jsObject.metadata;

  /// The [Query] you called get or [onSnapshot].
  Query get query => new Query.fromJsObject(jsObject.query);

  /// The number of documents.
  num get size => jsObject.size;

  /// Creates a new QuerySnapshot from a [jsObject].
  static QuerySnapshot get(firestore_interop.QuerySnapshotJsImpl jsObject) {
    if (jsObject == null) {
      return null;
    }
    return _expando[jsObject] ??= new QuerySnapshot._fromJsObject(jsObject);
  }

  QuerySnapshot._fromJsObject(firestore_interop.QuerySnapshotJsImpl jsObject)
      : super.fromJsObject(jsObject);

  /// Enumerates all of the documents in the [QuerySnapshot].
  void forEach(callback(DocumentSnapshot snapshot)) {
    var callbackWrap =
        allowInterop((s) => callback(DocumentSnapshot.getInstance(s)));
    return jsObject.forEach(callbackWrap);
  }
}

/// A reference to a transaction.
/// The [Transaction] object passed to a transaction's [updateFunction()]
/// provides the methods to read and write data within the transaction context.
/// See: [Firestore.runTransaction()].
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.firestore.Transaction>.
class Transaction extends JsObjectWrapper<firestore_interop.TransactionJsImpl> {
  static final _expando = new Expando<Transaction>();

  /// Creates a new Transaction from a [jsObject].
  static Transaction getInstance(firestore_interop.TransactionJsImpl jsObject) {
    if (jsObject == null) {
      return null;
    }
    return _expando[jsObject] ??= new Transaction._fromJsObject(jsObject);
  }

  Transaction._fromJsObject(firestore_interop.TransactionJsImpl jsObject)
      : super.fromJsObject(jsObject);

  /// Deletes the document referred to by the provided [DocumentReference].
  ///
  /// The [DocumentReference] parameter is a reference to the document to be
  /// deleted. Value must not be null.
  ///
  /// Returns non-null [Transaction] used for chaining method calls.
  Transaction delete(DocumentReference documentRef) =>
      Transaction.getInstance(jsObject.delete(documentRef.jsObject));

  /// Reads the document referenced by the provided [DocumentReference].
  ///
  /// The [DocumentReference] parameter is a reference to the document to be
  /// retrieved. Value must not be null.
  ///
  /// Returns non-null [Future] of the read data in a [DocumentSnapshot].
  Future<DocumentSnapshot> get(DocumentReference documentRef) =>
      handleThenableWithMapper(
          jsObject.get(documentRef.jsObject), DocumentSnapshot.getInstance);

  /// Writes to the document referred to by the provided [DocumentReference].
  /// If the document does not exist yet, it will be created.
  /// If you pass options, the provided data can be merged into the existing
  /// document.
  ///
  /// The [DocumentReference] parameter is a reference to the document to be
  /// created. Value must not be null.
  ///
  /// The [data] paramater is object of the fields and values for
  /// the document. Value must not be null.
  ///
  /// The optional [SetOptions] is an object to configure the set behavior.
  /// Pass [: {merge: true} :] to only replace the values specified in the
  /// data argument. Fields omitted will remain untouched.
  /// Value must not be null.
  ///
  /// Returns non-null [Transaction] used for chaining method calls.
  // TODO finish the implementation probably convert data?
  Transaction set(DocumentReference documentRef, data,
      [firestore_interop.SetOptions options]) {
    var jsObjectSet = (options != null)
        ? jsObject.set(documentRef.jsObject, jsify(data), options)
        : jsObject.set(documentRef.jsObject, jsify(data));
    return Transaction.getInstance(jsObjectSet);
  }

  /// Updates fields in the document referred to by this [DocumentReference].
  /// The update will fail if applied to a document that does not exist.
  /// The value must not be null.
  ///
  /// Nested fields can be updated by providing dot-separated field path strings.
  ///
  /// The [data] param is the object containing all of the fields and values
  /// to update.
  ///
  /// Returns non-null [Transaction] instance used for chaining method calls.
  // TODO in future: varargs parameter
  Transaction update(
          DocumentReference documentRef, Map<String, dynamic> data) =>
      Transaction
          .getInstance(jsObject.update(documentRef.jsObject, jsify(data)));
}

/*

class Firestore extends JsObjectWrapper<FirestoreJsImpl> {
  static final _expando = new Expando<Firestore>();

  /// Creates a new Firestore from a [jsObject].
  static Firestore get(FirestoreJsImpl jsObject) {
    if (jsObject == null) {
      return null;
    }
    return _expando[jsObject] ??= new Firestore._fromJsObject(jsObject);
  }

  Firestore._fromJsObject(FirestoreJsImpl jsObject)
      : super.fromJsObject(jsObject);
}


* */
