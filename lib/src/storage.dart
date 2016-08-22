import 'dart:async';

import 'package:js/js.dart';

import 'app.dart';
import 'interop/storage_interop.dart' as storage_interop;
import 'js.dart';
import 'utils.dart';

export 'interop/storage_interop.dart' show StringFormat;

/// Represents the current state of a running upload.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.storage#.TaskState>.
enum TaskState { RUNNING, PAUSED, SUCCESS, CANCELED, ERROR }

/// A service for uploading and downloading large objects to/from
/// Google Cloud Storage.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.storage.Storage>
class Storage extends JsObjectWrapper<storage_interop.StorageJsImpl> {
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

  Storage.fromJsObject(storage_interop.StorageJsImpl jsObject)
      : super.fromJsObject(jsObject);

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
class StorageReference
    extends JsObjectWrapper<storage_interop.ReferenceJsImpl> {
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

  StorageReference.fromJsObject(storage_interop.ReferenceJsImpl jsObject)
      : super.fromJsObject(jsObject);

  StorageReference child(String path) =>
      new StorageReference.fromJsObject(jsObject.child(path));

  Future delete() => handleThenable(jsObject.delete());

  Future<Uri> getDownloadURL() async {
    var uriString = await handleThenable(jsObject.getDownloadURL());
    return Uri.parse(uriString);
  }

  Future<FullMetadata> getMetadata() => handleThenableWithMapper(
      jsObject.getMetadata(), (m) => new FullMetadata.fromJsObject(m));

  UploadTask put(blob, [UploadMetadata metadata]) {
    storage_interop.UploadTaskJsImpl taskImpl;
    if (metadata != null) {
      taskImpl = jsObject.put(blob, metadata.jsObject);
    } else {
      taskImpl = jsObject.put(blob);
    }
    return new UploadTask.fromJsObject(taskImpl);
  }

  UploadTask putString(String data, [String format, UploadMetadata metadata]) {
    storage_interop.UploadTaskJsImpl taskImpl;
    if (metadata != null) {
      taskImpl = jsObject.putString(data, format, metadata.jsObject);
    } else if (format != null) {
      taskImpl = jsObject.putString(data, format);
    } else {
      taskImpl = jsObject.putString(data);
    }
    return new UploadTask.fromJsObject(taskImpl);
  }

  String toString() => jsObject.toString();

  Future<FullMetadata> updateMetadata(SettableMetadata metadata) =>
      handleThenableWithMapper(jsObject.updateMetadata(metadata.jsObject),
          (m) => new FullMetadata.fromJsObject(m));
}

/// The full set of object metadata, including read-only properties.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.storage.FullMetadata>
class FullMetadata
    extends _UploadMetadataBase<storage_interop.FullMetadataJsImpl> {
  String get bucket => jsObject.bucket;

  List<Uri> get downloadURLs => jsObject.downloadURLs.map(Uri.parse).toList();

  String get fullPath => jsObject.fullPath;

  String get generation => jsObject.generation;

  String get metageneration => jsObject.metageneration;

  String get name => jsObject.name;

  int get size => jsObject.size;

  DateTime get timeCreated => DateTime.parse(jsObject.timeCreated);

  DateTime get updated => DateTime.parse(jsObject.updated);

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
          Map customMetadata}) =>
      new FullMetadata.fromJsObject(new storage_interop.FullMetadataJsImpl(
          md5Hash: md5Hash,
          cacheControl: cacheControl,
          contentDisposition: contentDisposition,
          contentEncoding: contentEncoding,
          contentLanguage: contentLanguage,
          contentType: contentType,
          customMetadata:
              (customMetadata != null) ? jsify(customMetadata) : null));

  FullMetadata.fromJsObject(jsObject) : super.fromJsObject(jsObject);
}

/// Object metadata that can be set at upload.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.storage.UploadMetadata>.
class UploadMetadata
    extends _UploadMetadataBase<storage_interop.UploadMetadataJsImpl> {
  factory UploadMetadata(
          {String md5Hash,
          String cacheControl,
          String contentDisposition,
          String contentEncoding,
          String contentLanguage,
          String contentType,
          Map<String, String> customMetadata}) =>
      new UploadMetadata.fromJsObject(new storage_interop.UploadMetadataJsImpl(
          md5Hash: md5Hash,
          cacheControl: cacheControl,
          contentDisposition: contentDisposition,
          contentEncoding: contentEncoding,
          contentLanguage: contentLanguage,
          contentType: contentType,
          customMetadata:
              (customMetadata != null) ? jsify(customMetadata) : null));

  UploadMetadata.fromJsObject(storage_interop.UploadMetadataJsImpl jsObject)
      : super.fromJsObject(jsObject);
}

abstract class _UploadMetadataBase<
        T extends storage_interop.UploadMetadataJsImpl>
    extends _SettableMetadataBase<T> {
  String get md5Hash => jsObject.md5Hash;
  void set md5Hash(String s) {
    jsObject.md5Hash = s;
  }

  _UploadMetadataBase.fromJsObject(T jsObject) : super.fromJsObject(jsObject);
}

/// Represents the process of uploading an object. Allows you to monitor and manage the upload.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.storage.UploadTask>.
class UploadTask extends JsObjectWrapper<storage_interop.UploadTaskJsImpl> {
  Future<UploadTaskSnapshot> _future;

  Future<UploadTaskSnapshot> get future {
    if (_future == null) {
      _future = handleThenableWithMapper(
          jsObject, (val) => new UploadTaskSnapshot.fromJsObject(val));
    }
    return _future;
  }

  UploadTaskSnapshot _snapshot;
  UploadTaskSnapshot get snapshot {
    if (_snapshot != null) {
      _snapshot.jsObject = jsObject.snapshot;
    } else {
      _snapshot = new UploadTaskSnapshot.fromJsObject(jsObject.snapshot);
    }
    return _snapshot;
  }

  UploadTask.fromJsObject(storage_interop.UploadTaskJsImpl jsObject)
      : super.fromJsObject(jsObject);

  bool cancel() => jsObject.cancel();

  var _onStateChangedUnsubscribe;
  StreamController<UploadTaskSnapshot> _changeController;
  Stream<UploadTaskSnapshot> get onStateChanged {
    if (_changeController == null) {
      var nextWrapper =
          allowInterop((storage_interop.UploadTaskSnapshotJsImpl data) {
        _changeController.add(new UploadTaskSnapshot.fromJsObject(data));
      });

      var errorWrapper = allowInterop((e) => _changeController.addError(e));
      var onCompletion = allowInterop(() => _changeController.close());

      void startListen() {
        _onStateChangedUnsubscribe = jsObject.on(
            storage_interop.TaskEvent.STATE_CHANGED,
            nextWrapper,
            errorWrapper,
            onCompletion);
      }

      void stopListen() {
        _onStateChangedUnsubscribe();
      }

      _changeController = new StreamController<UploadTaskSnapshot>.broadcast(
          onListen: startListen, onCancel: stopListen, sync: true);
    }
    return _changeController.stream;
  }

  bool pause() => jsObject.pause();

  bool resume() => jsObject.resume();
}

/// Holds data about the current state of the upload task.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.storage.UploadTaskSnapshot>.
class UploadTaskSnapshot
    extends JsObjectWrapper<storage_interop.UploadTaskSnapshotJsImpl> {
  int get bytesTransferred => jsObject.bytesTransferred;

  Uri get downloadURL => Uri.parse(jsObject.downloadURL);

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
        throw 'Unknown state "${jsObject.state}" please file a bug.';
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

  UploadTaskSnapshot.fromJsObject(
      storage_interop.UploadTaskSnapshotJsImpl jsObject)
      : super.fromJsObject(jsObject);
}

/// Object metadata that can be set at any time.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.storage.SettableMetadata>.
class SettableMetadata
    extends _SettableMetadataBase<storage_interop.SettableMetadataJsImpl> {
  factory SettableMetadata(
          {String cacheControl,
          String contentDisposition,
          String contentEncoding,
          String contentLanguage,
          String contentType,
          Map customMetadata}) =>
      new SettableMetadata.fromJsObject(
          new storage_interop.SettableMetadataJsImpl(
              cacheControl: cacheControl,
              contentDisposition: contentDisposition,
              contentEncoding: contentEncoding,
              contentLanguage: contentLanguage,
              contentType: contentType,
              customMetadata:
                  (customMetadata != null) ? jsify(customMetadata) : null));

  SettableMetadata.fromJsObject(storage_interop.SettableMetadataJsImpl jsObject)
      : super.fromJsObject(jsObject);
}

abstract class _SettableMetadataBase<
        T extends storage_interop.SettableMetadataJsImpl>
    extends JsObjectWrapper<T> {
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

  Map<String, String> get customMetadata =>
      dartify(jsObject.customMetadata) as Map<String, String>;
  void set customMetadata(Map<String, String> m) {
    jsObject.customMetadata = jsify(m);
  }

  _SettableMetadataBase.fromJsObject(T jsObject) : super.fromJsObject(jsObject);
}
