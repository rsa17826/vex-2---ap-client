const Any = new Proxy(function () {}, {
  get() {
    return Any
  },
  apply() {
    return Any
  },
  construct() {
    return Any
  },
  has() {
    return true
  },
  getOwnPropertyDescriptor(t, prop) {
    if (prop === "prototype")
      return Reflect.getOwnPropertyDescriptor(t, prop)
    return {
      value: Any,
      writable: true,
      enumerable: true,
      configurable: true,
    }
  },
  ownKeys(t) {
    return Reflect.ownKeys(t)
  },
  set() {
    return Any
  },
  deleteProperty() {
    return Any
  },
  getPrototypeOf() {
    return Any
  },
  isExtensible() {
    return Any
  },
  setPrototypeOf() {
    return Any
  },
})
