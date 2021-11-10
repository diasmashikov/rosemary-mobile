class SingletonOrderCount {
  SingletonOrderCount._privateConstructor();

  static final SingletonOrderCount _instance = SingletonOrderCount._privateConstructor();
  static int? orderCount = 0;

  factory SingletonOrderCount() {
    return _instance;
  }

 
}
