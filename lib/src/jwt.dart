library firebase.jwt;

import 'dart:convert';

import 'package:crypto/crypto.dart';

/// See http://jwt.io/ for details
String createJwtToken(
    Map<String, dynamic> header, Map<String, dynamic> payload, String secret) {
  var encoder = new JsonUtf8Encoder();

  var headerBytes = encoder.convert(header);
  var headerBas64 = _base64url(headerBytes);

  var payloadBytes = encoder.convert(payload);
  var payloadBase64 = _base64url(payloadBytes);

  var sha256 = new SHA256();

  var secretBytes = ASCII.encode(secret);

  var hmac = new HMAC(sha256, secretBytes);

  var hashSourceBytes = ASCII.encode('$headerBas64.$payloadBase64');

  hmac.add(hashSourceBytes);

  var allTheBytes = hmac.close();

  var secretBase64 = _base64url(allTheBytes);

  return '$headerBas64.$payloadBase64.$secretBase64';
}

String _base64url(List<int> bytes) => CryptoUtils
    .bytesToBase64(bytes)
    .replaceAll('+', '-')
    .replaceAll('/', '_')
    .replaceAll('=', '');
