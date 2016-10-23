## 0.3.0

- Update to Firebase 3.5.0.
- Support for custom OAuth parameters with `GoogleAuthProvider.setCustomParameters()`, `FacebookAuthProvider.setCustomParameters()`, `GithubAuthProvider.setCustomParameters()` and `TwitterAuthProvider.setCustomParameters()` methods.
- `AuthCredential` now has the `accessToken` and `secret` (Twitter only) properties.

## 0.2.2

- Update to Firebase 3.4.0.
- Added `isEqual()` method for `Query` class.
- Strong mode fixes.
- More docs.

## 0.2.1

- Input params validation for methods which work with JS types.
- Fixes in the lib.
- More documentation and tests.
- Readme update with information on how to run tests and examples.

## 0.2.0

- *BREAKING* Exposing only one top-level library: `firebase.dart`.
- *BREAKING* `ThenableReference` and `UploadTask` are having `future` property to handle `then()` and `catchError()`.
- *BREAKING* `CustomMetadata` is now a Map.
- *BREAKING* Storage APIs now expose `Uri` and `DateTime` instead of `String` where appropriate.
- *BREAKING* Storage `onStateChanged` returns `Stream<UploadTaskSnapshot>`.
- Updates and fixes in examples
- Fixes in the lib

## 0.1.0

- Initial version of library
