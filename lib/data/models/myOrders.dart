import 'order.dart';

class MyOrders {
  List<Order> activeOrders;
  List<Order> historyOrders;

  

  MyOrders.fromJson(Map<String, dynamic> json)
      : activeOrders = json["activeOrders"]?.map<Order>((element) => Order.fromJson(element))
        .toList(),
      historyOrders = json["historyOrders"]?.map<Order>((element) => Order.fromJson(element))
        .toList();
       


}
