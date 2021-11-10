import 'orderItem.dart';
import 'user.dart';

class Order {
  List<OrderItem> orderItems;
  String shippingAddress;
  String city;
  String zip;
  String country;
  String phone;
  String status;
  int totalPrice;
  User? user;
  String id;

  Order(
      {required this.orderItems,
      required this.shippingAddress,
      required this.city,
      required this.zip,
      required this.country,
      required this.phone,
      required this.status,
      required this.totalPrice,
      required this.user,
      required this.id});

  Order.fromJson(Map<String, dynamic> json)
      : orderItems = json['orderItems']
            .map<OrderItem>((orderItem) => OrderItem.fromJson(orderItem))
            .toList(),
        shippingAddress = json['shippingAddress1'],
        city = json['city'],
        zip = json['zip'],
        country = json['country'],
        phone = json['phone'],
        status = json['status'],
        totalPrice = json['totalPrice'],
        id = json['id'],
        user = User.fromJson(json['user']);
}
