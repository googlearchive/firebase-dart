library firebase.mojo.auth_response;

import 'package:sky_services/firebase/firebase.mojom.dart' as mojo;

/**
 * Converts authData response from a Mojo object to native Dart object.
 */
Map<String, dynamic> decodeAuthData(mojo.AuthData authData) {
  // TODO(jackson): I'd rather return a class here but I'm using
  // untyped data for consistency with the existing firebase Dart package.
  Map<String, dynamic> result = <String, dynamic>{};
  result["uid"] = authData.uid;
  result["provider"] = authData.provider;
  result["token"] = authData.token;
  return result;
}
