import 'package:rosemary/data/models/product.dart';
import 'package:rosemary/data/models/user.dart';

class Favorite {
  List<Product> products;
  User? user;
  String id;

  Favorite(
      {required this.products,
      required this.user,
      
      required this.id});

  Favorite.fromJson(Map json)
      : products = json['products']
            .map<Product>((product) => Product.fromJson(product))
            .toList(),
         user = User.fromJson(json['user']),
        id = json["_id"];


}
