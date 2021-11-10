import 'order.dart';

class OrdersInProgress {
  List<Order> orderListPending;
  List<Order> orderListShipping;
  List<Order> orderListShipped;

  

  OrdersInProgress.fromJson(Map<String, dynamic> json)
      : orderListPending = json["orderListPending"]?.map<Order>((element) => Order.fromJson(element))
        .toList(),
      orderListShipping = json["orderListShipping"]?.map<Order>((element) => Order.fromJson(element))
        .toList(),
       orderListShipped = json["orderListShipped"]?.map<Order>((element) => Order.fromJson(element))
        .toList();


}
