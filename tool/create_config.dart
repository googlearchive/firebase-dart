import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

final _assetPath = 'lib/src/assets/';

main() {
  // make sure the working dir is the root of the project
  if (!(new File('pubspec.yaml').existsSync())) {
    throw new StateError("Not in the root! - ${Directory.current}");
  }

  var samplePath = p.join(_assetPath, 'config.json.sample');
  if (!(new File(samplePath).existsSync())) {
    throw new StateError("'$samplePath should exist");
  }

  var configPath = p.join(_assetPath, 'config.json');
  var configFile = new File(configPath);

  if (configFile.existsSync()) {
    throw new StateError("Config exists. It should not. '$configPath'");
  }

  var vars = ["API_KEY", "AUTH_DOMAIN", "DATABASE_URL", "STORAGE_BUCKET"];

  var config = <String, String>{};
  for (var envVar in vars) {
    if (Platform.environment.containsKey(envVar)) {
      config[envVar] = Platform.environment[envVar];
    } else {
      throw new StateError('Missing needed environment variable $envVar');
    }
  }

  configFile
      .writeAsStringSync(new JsonEncoder.withIndent('  ').convert(config));
}
