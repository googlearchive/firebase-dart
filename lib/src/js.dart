library firebase3.js;

/// Class which is a wrapper for jsObject.
abstract class JsObjectWrapper {
  var _jsObject;
  get jsObject => this._jsObject;
  void set jsObject(o) {
    this._jsObject = o;
  }

  JsObjectWrapper.fromJsObject(this._jsObject);
}
