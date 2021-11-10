import 'package:rosemary/data/models/product.dart';

class OrderItem {
  int quantity;
  Product product;
  String? pickedSize;
  String id;

  OrderItem(
      {required this.quantity,
      required this.product,
      required this.pickedSize,
      required this.id});

  OrderItem.fromJson(Map json)
      : quantity = json['quantity'],
        pickedSize = json['pickedSize'],
        product = Product.fromJson(json['product']),
        id = json["_id"];

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'product': product.toJson(),
      'pickedSize': pickedSize,
      '_id': id
    };
  }
}
