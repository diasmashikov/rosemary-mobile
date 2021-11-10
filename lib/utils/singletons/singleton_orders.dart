import 'package:rosemary/data/models/ordersInProgress.dart';

class SingletonOrders {
  SingletonOrders._privateConstructor();

  static final SingletonOrders _instance =
      SingletonOrders._privateConstructor();
  static OrdersInProgress? orders;

  factory SingletonOrders() {
    return _instance;
  }
}
