/// Class which is a wrapper for jsObject.
abstract class JsObjectWrapper<T> {
  T jsObject;

  JsObjectWrapper.fromJsObject(this.jsObject);
}
