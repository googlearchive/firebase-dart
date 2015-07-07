library firebase.test.jwt;

import 'package:firebase/src/jwt.dart';
import 'package:test/test.dart';

void main() {
  // inputs from http://jwt.io/ with appreciation
  test('create a JWT token', () {
    const header = const {"alg": "HS256", "typ": "JWT"};

    const payload = const {
      "sub": "1234567890",
      "name": "John Doe",
      "admin": true
    };

    const secret = 'secret';

    var newToken = createJwtToken(header, payload, secret);

    const expectedSecret = 'TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ';

    const encodedSections = const <String>[
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9',
      'eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9',
      expectedSecret
    ];

    expect(newToken, encodedSections.join('.'));
  });
}
