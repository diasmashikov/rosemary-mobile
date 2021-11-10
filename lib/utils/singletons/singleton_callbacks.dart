class SingletonCallbacks {
  SingletonCallbacks._privateConstructor();

  static final SingletonCallbacks _instance =
      SingletonCallbacks._privateConstructor();
  static Function refreshOrderCountCallBack = () {};

  factory SingletonCallbacks() {
    return _instance;
  }
}
