import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

Map<String, dynamic> _configVal;

String get apiKey => _getConfig('API_KEY');

String get authDomain => _getConfig(
      'AUTH_DOMAIN',
      alt: '$projectId.firebaseapp.com',
    );

String get databaseUrl => _getConfig(
      'DATABASE_URL',
      alt: 'https://$projectId.firebaseio.com',
    );

String get storageBucket => _getConfig(
      'STORAGE_BUCKET',
      alt: '$projectId.appspot.com',
    );

String get projectId => _getConfig('PROJECT_ID');

String get messagingSenderId => _getConfig('MESSAGING_SENDER_ID');

String get appId => _getConfig('APP_ID');

String get serverKey => _getConfig('SERVER_KEY');

String get vapidKey => _getConfig('VAPID_KEY');

String _getConfig(String key, {String alt}) {
  if (_configVal == null) {
    throw StateError('You must call config() first');
  }

  var value = _configVal[key];

  if (value == null) {
    if (alt == null) {
      throw ArgumentError('`$key` is not configured in `config.json`.');
    }
    return alt;
  }

  return value;
}

Future<void> config() async {
  if (_configVal != null) {
    return;
  }

  _configVal = await _readAssetJson('config.json');
}

Future<dynamic> readServiceAccountJson() =>
    _readAssetJson('service_account.json');

Future<dynamic> _readAssetJson(String assetFile) async {
  try {
    var response = await get('packages/_shared_assets/$assetFile');
    if (response.statusCode > 399) {
      throw StateError(
        'Problem with server: ${response.statusCode} ${response.body}',
      );
    }

    return jsonDecode(await response.body);
  } catch (e, stack) {
    print('Error getting `$assetFile`. Make sure it exists.');
    print(e);
    print(stack);
    rethrow;
  }
}
