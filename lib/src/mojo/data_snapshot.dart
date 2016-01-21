library firebase.js.snapshot;

import 'dart:convert';

import 'package:sky_services/firebase/firebase.mojom.dart' as mojo;

import '../data_snapshot.dart';

import '../firebase.dart';

/**
 * A DataSnapshot contains data from a Firebase location. Any time you read
 * Firebase data, you receive data as a DataSnapshot.
 *
 * DataSnapshots are passed to event handlers such as onValue or onceValue.
 * You can extract the contents of the snapshot by calling val(), or you
 * can traverse into the snapshot by calling child() to return child
 * snapshots (which you could in turn call val() on).
 */
class MojoDataSnapshot implements DataSnapshot {
  /**
   * Holds a reference to the Mojo 'DataSnapshot' object.
   */
  final mojo.DataSnapshot _ds;

  /**
   * Construct a new MojoDataSnapshot from a mojo DataSnapshot.
   */
  MojoDataSnapshot.fromMojoObject(mojo.DataSnapshot obj) : _ds = obj;

  bool get exists => true;

  dynamic val() => JSON.decode(_ds.jsonValue)['value'];

  DataSnapshot child(String path) => null;

  void forEach(cb(DataSnapshot snapshot)) { }

  bool hasChild(String path) => false;

  bool get hasChildren => false;

  String get key => _ds.key;

  int get numChildren => null;

  Firebase ref() => null;

  dynamic getPriority() => null;

  dynamic exportVal() => null;
}
