/// Class which is a wrapper for jsObject.
abstract class JsObjectWrapper<T> {
  T _jsObject;
  T get jsObject => this._jsObject;
  void set jsObject(T o) {
    this._jsObject = o;
  }

  JsObjectWrapper.fromJsObject(this._jsObject);
}
