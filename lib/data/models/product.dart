import 'package:rosemary/data/models/category.dart';
import 'package:rosemary/data/models/modelCharacteristics.dart';

class Product {
  String name;
  String image;
  List<String> images;
  int price;
  String color;
  String sizes;
  String description;
  String material;
  double discount;
  String fashionCollection;
  bool newArrival;
  bool recommended;
  String countryProducer;
  String style;
  ModelCharacteristics modelCharacteristics;
  Category category;
  int countInStock;
  bool isFeatured;
  String id;

  Product(
      {required this.name,
      required this.image,
      required this.images,
      required this.price,
      required this.color,
      required this.sizes,
      required this.description,
      required this.material,
      required this.countryProducer,
      required this.style,
      required this.discount,
  required this.fashionCollection,
  required this.newArrival,
  required this.recommended,
      required this.modelCharacteristics,
      required this.category,
      required this.countInStock,
      required this.id,
      required this.isFeatured});

  Product.fromJson(Map json)
      : name = json["name"],
        image = json["image"],
        images = json["images"].cast<String>(),
        price = json["price"],
        color = json['color'],
        sizes = json['sizes'],
        description = json['description'],
        material = json['material'],
        discount = (json['discount'] == 0) ? 0.0 : json['discount'],
        fashionCollection = json['fashionCollection'],
        newArrival = json['newArrival'],
        recommended = json['recommended'],
        countryProducer = json['countryProducer'],
        style = json['style'],
        modelCharacteristics =
            ModelCharacteristics.fromJson(json['modelCharacteristics']),
        category = Category.fromJson(json['category']),
        countInStock = json['countInStock'],
        isFeatured = json['isFeatured'],
        id = json["_id"];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'images': images,
      'price': price,
      'color': color,
      'sizes': sizes,
      'description': description,
      'material': material,
      'countryProducer': countryProducer,
      'style': style,
      'modelCharacteristics': modelCharacteristics.toJson(),
      'category': category.toJson(),
      'countInStock': countInStock,
      'id': id
    };
  }
}
