import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

class FirebaseClient {
  final String credential;
  final BaseClient _client;

  FirebaseClient(this.credential, {BaseClient client})
      : _client = client ?? new IOClient();

  FirebaseClient.anonymous({BaseClient client})
      : credential = null,
        _client = client ?? new IOClient();

  Future<dynamic> get(uri) => send('GET', uri);

  Future<dynamic> put(uri, json) => send('PUT', uri, json: json);

  Future<dynamic> post(uri, json) => send('POST', uri, json: json);

  Future<dynamic> delete(uri) => send('DELETE', uri);

  /// [url] can be either a `String` or `Uri`.
  Future<dynamic> send(String method, url, {json}) async {
    Uri uri = url is String ? Uri.parse(url) : url;

    var request = new Request(method, uri);
    if (credential != null) {
      request.headers['Authorization'] = "Bearer: $credential";
    }

    if (json != null) {
      request.headers['Content-Type'] = 'application/json';
      request.body = JSON.encode(json);
    }

    var streamedResponse = await _client.send(request);
    var response = await Response.fromStream(streamedResponse);

    var bodyJson;
    try {
      bodyJson = JSON.decode(response.body);
    } on FormatException {
      var contentType = response.headers['content-type'];
      if (contentType != null && !contentType.contains('application/json')) {
        throw new Exception(
            'Returned value was not JSON. Did the uri end with ".json"?');
      }
      rethrow;
    }

    if (response.statusCode != 200) {
      if (bodyJson is Map) {
        var error = bodyJson['error'];
        if (error != null) {
          // TODO: wrap this in something helpful?
          throw error;
        }
      }
      throw bodyJson;
    }

    return bodyJson;
  }

  void close() => _client.close();
}
