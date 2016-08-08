library firebase3.storage;

import 'dart:async';
import 'package:func/func.dart';
import 'package:js/js.dart';
import 'package:firebase3/src/js.dart';
import 'package:firebase3/src/utils.dart';
import 'package:firebase3/src/interop/storage_interop.dart' as storage_interop;
import 'package:firebase3/src/task_utils.dart';
import 'package:firebase3/app.dart';
import 'package:firebase3/firebase.dart';

/// A service for uploading and downloading large objects to/from
/// Google Cloud Storage.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.storage.Storage>
class Storage extends JsObjectWrapper {
  App _app;
  App get app {
    if (_app != null) {
      _app.jsObject = jsObject.app;
    } else {
      _app = new App.fromJsObject(jsObject.app);
    }
    return _app;
  }

  int get maxOperationRetryTime => jsObject.maxOperationRetryTime;

  int get maxUploadRetryTime => jsObject.maxUploadRetryTime;

  Storage.fromJsObject(jsObject) : super.fromJsObject(jsObject);

  StorageReference ref([String path]) =>
      new StorageReference.fromJsObject(jsObject.ref(path));

  StorageReference refFromURL(String url) =>
      new StorageReference.fromJsObject(jsObject.refFromURL(url));

  void setMaxOperationRetryTime(int time) =>
      jsObject.setMaxOperationRetryTime(time);

  void setMaxUploadRetryTime(int time) => jsObject.setMaxUploadRetryTime(time);
}

/// Represents a reference to a Google Cloud Storage object. Developers
/// can upload, download, and delete objects, as well as get/set object metadata.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.storage.Reference>
class StorageReference extends JsObjectWrapper {
  String get bucket => jsObject.bucket;

  String get fullPath => jsObject.fullPath;

  String get name => jsObject.name;

  StorageReference _parent;
  StorageReference get parent {
    if (jsObject.parent != null) {
      if (_parent != null) {
        _parent.jsObject = jsObject.parent;
      } else {
        _parent = new StorageReference.fromJsObject(jsObject.parent);
      }
    } else {
      _parent = null;
    }
    return _parent;
  }

  StorageReference _root;
  StorageReference get root {
    if (_root != null) {
      _root.jsObject = jsObject.root;
    } else {
      _root = new StorageReference.fromJsObject(jsObject.root);
    }
    return _root;
  }

  Storage _storage;
  Storage get storage {
    if (_storage != null) {
      _storage.jsObject = jsObject.storage;
    } else {
      _storage = new Storage.fromJsObject(jsObject.storage);
    }
    return _storage;
  }

  StorageReference.fromJsObject(jsObject) : super.fromJsObject(jsObject);

  StorageReference child(String path) =>
      new StorageReference.fromJsObject(jsObject.child(path));

  Future delete() {
    Completer c = new Completer();
    var jsPromise = jsObject.delete();
    jsPromise.then(resolveCallback(c), resolveError(c));
    return c.future;
  }

  Future<String> getDownloadURL() {
    Completer<String> c = new Completer<String>();
    var jsPromise = jsObject.getDownloadURL();
    jsPromise.then(resolveCallback(c), resolveError(c));
    return c.future;
  }

  Future<FullMetadata> getMetadata() {
    Completer<FullMetadata> c = new Completer<FullMetadata>();
    var jsPromise = jsObject.getMetadata();

    var resolveCallbackWrap =
        allowInterop((storage_interop.FullMetadataJsImpl m) {
      c.complete(new FullMetadata.fromJsObject(m));
    });

    jsPromise.then(resolveCallbackWrap, resolveError(c));
    return c.future;
  }

  UploadTask put(blob, [UploadMetadata metadata]) {
    if (metadata != null) {
      return new UploadTask.fromJsObject(jsObject.put(blob, metadata.jsObject));
    }
    return new UploadTask.fromJsObject(jsObject.put(blob));
  }

  String toString() => jsObject.toString();

  Future<FullMetadata> updateMetadata(SettableMetadata metadata) {
    Completer<FullMetadata> c = new Completer<FullMetadata>();
    var jsPromise = jsObject.updateMetadata(metadata.jsObject);

    var resolveCallbackWrap =
        allowInterop((storage_interop.FullMetadataJsImpl m) {
      c.complete(new FullMetadata.fromJsObject(m));
    });

    jsPromise.then(resolveCallbackWrap, resolveError(c));
    return c.future;
  }
}

/// The full set of object metadata, including read-only properties.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.storage.FullMetadata>
class FullMetadata extends UploadMetadata {
  String get bucket => jsObject.bucket;
  void set bucket(String s) {
    jsObject.bucket = s;
  }

  List<String> get downloadURLs => new List.from(jsObject.downloadURLs);
  void set downloadURLs(List<String> l) {
    jsObject.downloadURLs = l;
  }

  String get fullPath => jsObject.fullPath;
  void set fullPath(String s) {
    jsObject.fullPath = s;
  }

  String get generation => jsObject.generation;
  void set generation(String s) {
    jsObject.generation = s;
  }

  String get metageneration => jsObject.metageneration;
  void set metageneration(String s) {
    jsObject.metageneration = s;
  }

  String get name => jsObject.name;
  void set name(String s) {
    jsObject.name = s;
  }

  int get size => jsObject.size;
  void set size(int s) {
    jsObject.size = s;
  }

  String get timeCreated => jsObject.timeCreated;
  void set timeCreated(String s) {
    jsObject.timeCreated = s;
  }

  String get updated => jsObject.updated;
  void set updated(String s) {
    jsObject.updated = s;
  }

  factory FullMetadata(
          {String bucket,
          List<String> downloadURLs,
          String fullPath,
          String generation,
          String metageneration,
          String name,
          int size,
          String timeCreated,
          String updated,
          String md5Hash,
          String cacheControl,
          String contentDisposition,
          String contentEncoding,
          String contentLanguage,
          String contentType,
          CustomMetadata customMetadata}) =>
      new FullMetadata.fromJsObject(new storage_interop.FullMetadataJsImpl(
          bucket: bucket,
          downloadURLs: downloadURLs,
          fullPath: fullPath,
          generation: generation,
          metageneration: metageneration,
          name: name,
          size: size,
          timeCreated: timeCreated,
          updated: updated,
          md5Hash: md5Hash,
          cacheControl: cacheControl,
          contentDisposition: contentDisposition,
          contentEncoding: contentEncoding,
          contentLanguage: contentLanguage,
          contentType: contentType,
          customMetadata: (customMetadata != null) ? customMetadata.jsObject : null));

  FullMetadata.fromJsObject(jsObject) : super.fromJsObject(jsObject);
}

/// Object metadata that can be set at upload.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.storage.UploadMetadata>.
class UploadMetadata extends SettableMetadata {
  String get md5Hash => jsObject.md5Hash;
  void set md5Hash(String s) {
    jsObject.md5Hash = s;
  }

  factory UploadMetadata(
          {String md5Hash,
          String cacheControl,
          String contentDisposition,
          String contentEncoding,
          String contentLanguage,
          String contentType,
          CustomMetadata customMetadata}) =>
      new UploadMetadata.fromJsObject(new storage_interop.UploadMetadataJsImpl(
          md5Hash: md5Hash,
          cacheControl: cacheControl,
          contentDisposition: contentDisposition,
          contentEncoding: contentEncoding,
          contentLanguage: contentLanguage,
          contentType: contentType,
          customMetadata: (customMetadata != null) ? customMetadata.jsObject : null));

  UploadMetadata.fromJsObject(jsObject) : super.fromJsObject(jsObject);
}

/// Event propagated in Stream controllers when path changes.
class UploadTaskEvent {
  UploadTaskSnapshot snapshot;
  UploadTaskEvent(this.snapshot);
}

/// Represents the process of uploading an object. Allows you to monitor and manage the upload.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.storage.UploadTask>.
class UploadTask extends JsObjectWrapper
    implements Thenable<UploadTaskSnapshot> {
  UploadTaskSnapshot _snapshot;
  UploadTaskSnapshot get snapshot {
    if (_snapshot != null) {
      _snapshot.jsObject = jsObject.snapshot;
    } else {
      _snapshot = new UploadTaskSnapshot.fromJsObject(jsObject.snapshot);
    }
    return _snapshot;
  }

  UploadTask.fromJsObject(jsObject) : super.fromJsObject(jsObject);

  bool cancel() => jsObject.cancel();

  var _onStateChangedUnsubscribe;
  Stream<UploadTaskEvent> _onStateChanged;
  Stream<UploadTaskEvent> get onStateChanged {
    if (_onStateChanged == null) {
      StreamController<UploadTaskEvent> streamController;

      var callbackWrap =
          allowInterop((storage_interop.UploadTaskSnapshotJsImpl data) {
        streamController.add(
            new UploadTaskEvent(new UploadTaskSnapshot.fromJsObject(data)));
      });

      void startListen() {
        _onStateChangedUnsubscribe = jsObject.on("state_changed", callbackWrap);
      }

      void stopListen() {
        _onStateChangedUnsubscribe();
      }

      streamController = new StreamController<UploadTaskEvent>.broadcast(
          onListen: startListen, onCancel: stopListen, sync: true);
      _onStateChanged = streamController.stream;
    }
    return _onStateChanged;
  }

  bool pause() => jsObject.pause();

  bool resume() => jsObject.resume();

  Future<UploadTaskSnapshot> then(Func1<UploadTaskSnapshot, dynamic> onValue) {
    Completer<UploadTaskSnapshot> c = new Completer<UploadTaskSnapshot>();
    jsObject.then(allowInterop((val) {
      var uploadtaskSnapshot = new UploadTaskSnapshot.fromJsObject(val);
      onValue(uploadtaskSnapshot);
      c.complete(uploadtaskSnapshot);
    }), allowInterop((e) => c.completeError(e)));
    return c.future;
  }

  // Don't know why but I can't use the JS$catch method :-(
  Future catchError(Func1<Error, dynamic> onError) {
    Completer c = new Completer();
    jsObject.then(null, allowInterop((e) {
      onError(e);
      c.complete(e);
    }));
    return c.future;
  }
}

/// Holds data about the current state of the upload task.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.storage.UploadTaskSnapshot>.
class UploadTaskSnapshot extends JsObjectWrapper {
  int get bytesTransferred => jsObject.bytesTransferred;

  String get downloadURL => jsObject.downloadURL;

  FullMetadata _metadata;
  FullMetadata get metadata {
    if (jsObject.metadata != null) {
      if (_metadata != null) {
        _metadata.jsObject = jsObject.metadata;
      } else {
        _metadata = new FullMetadata.fromJsObject(jsObject.metadata);
      }
    } else {
      _metadata = null;
    }
    return _metadata;
  }

  StorageReference _ref;
  StorageReference get ref {
    if (_ref != null) {
      _ref.jsObject = jsObject.ref;
    } else {
      _ref = new StorageReference.fromJsObject(jsObject.ref);
    }
    return _ref;
  }

  TaskState get state {
    switch (jsObject.state) {
      case "running":
        return TaskState.RUNNING;
      case "paused":
        return TaskState.PAUSED;
      case "success":
        return TaskState.SUCCESS;
      case "canceled":
        return TaskState.CANCELED;
      case "error":
        return TaskState.ERROR;
      default:
        return null;
    }
  }

  UploadTask _task;
  UploadTask get task {
    if (_task != null) {
      _task.jsObject = jsObject.task;
    } else {
      _task = new UploadTask.fromJsObject(jsObject.task);
    }
    return _task;
  }

  int get totalBytes => jsObject.totalBytes;

  UploadTaskSnapshot.fromJsObject(jsObject) : super.fromJsObject(jsObject);
}

/// Object metadata that can be set at any time.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.storage.SettableMetadata>.
class SettableMetadata extends JsObjectWrapper {
  String get cacheControl => jsObject.cacheControl;
  void set cacheControl(String s) {
    jsObject.cacheControl = s;
  }

  String get contentDisposition => jsObject.contentDisposition;
  void set contentDisposition(String s) {
    jsObject.contentDisposition = s;
  }

  String get contentEncoding => jsObject.contentEncoding;
  void set contentEncoding(String s) {
    jsObject.contentEncoding = s;
  }

  String get contentLanguage => jsObject.contentLanguage;
  void set contentLanguage(String s) {
    jsObject.contentLanguage = s;
  }

  String get contentType => jsObject.contentType;
  void set contentType(String s) {
    jsObject.contentType = s;
  }

  CustomMetadata _customMetadata;
  CustomMetadata get customMetadata {
    if (jsObject.customMetadata != null) {
      if (_customMetadata != null) {
        _customMetadata.jsObject = jsObject.customMetadata;
      } else {
        _customMetadata =
            new CustomMetadata.fromJsObject(jsObject.customMetadata);
      }
    } else {
      _customMetadata = null;
    }
    return _customMetadata;
  }

  void set customMetadata(CustomMetadata s) {
    _customMetadata = s;
    jsObject.customMetadata = s.jsObject;
  }

  factory SettableMetadata(
          {String cacheControl,
          String contentDisposition,
          String contentEncoding,
          String contentLanguage,
          String contentType,
          CustomMetadata customMetadata}) =>
      new SettableMetadata.fromJsObject(
          new storage_interop.SettableMetadataJsImpl(
              cacheControl: cacheControl,
              contentDisposition: contentDisposition,
              contentEncoding: contentEncoding,
              contentLanguage: contentLanguage,
              contentType: contentType,
              customMetadata: (customMetadata != null) ? customMetadata.jsObject : null));

  SettableMetadata.fromJsObject(jsObject) : super.fromJsObject(jsObject);
}

/// A structure for custom metadata used in [SettableMetadata.customMetadata].
class CustomMetadata extends JsObjectWrapper {
  String get string => jsObject.string;
  void set string(String s) {
    jsObject.string = s;
  }

  factory CustomMetadata({String string}) => new CustomMetadata.fromJsObject(
      new storage_interop.CustomMetadataJsImpl(string: string));

  CustomMetadata.fromJsObject(jsObject) : super.fromJsObject(jsObject);
}
