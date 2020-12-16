import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

const _assetPath = 'lib';

const _mapping = {
  'SERVICE_ACCOUNT_JSON': 'service_account.json',
  'CONFIG_DATA': 'config.json',
};

void main(List<String> args) {
  // make sure the working dir is the root of the project
  if (!File('pubspec.yaml').existsSync()) {
    throw StateError('Not in the root! - ${Directory.current}');
  }

  var samplePath = p.join(_assetPath, 'config.json.sample');
  if (!File(samplePath).existsSync()) {
    throw StateError("'$samplePath should exist");
  }

  if (args.contains('--dump')) {
    for (var entry in _mapping.entries) {
      final path = p.join(_assetPath, entry.value);
      final file = File(path);
      if (!file.existsSync()) {
        throw StateError('File should exist at $path');
      }

      final content = base64.encode(file.readAsBytesSync());
      print(entry.key);
      print(content);
    }
    return;
  }

  for (var entry in _mapping.entries) {
    if (!Platform.environment.containsKey(entry.key)) {
      throw StateError('Missing needed environment variable ${entry.key}');
    }

    final path = p.join(_assetPath, entry.value);
    final file = File(path);
    if (file.existsSync()) {
      throw StateError('No file should exist at $path');
    }

    final content = utf8.decode(base64.decode(Platform.environment[entry.key]));
    file.writeAsStringSync(content);
  }
}
