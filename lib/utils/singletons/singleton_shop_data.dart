import 'package:rosemary/data/models/askedQuestion.dart';
import 'package:rosemary/data/models/category.dart';
import 'package:rosemary/data/models/contact.dart';
import 'package:rosemary/data/models/myOrders.dart';
import 'package:rosemary/data/models/ordersInProgress.dart';
import 'package:rosemary/data/models/product.dart';

import 'package:rosemary/data/models/promotion.dart';
import 'package:rosemary/data/models/statistics/statistics.dart';

class SingletonShopData {
  SingletonShopData._privateConstructor();

  static final SingletonShopData _instance =
      SingletonShopData._privateConstructor();
  static List<AskedQuestion>? askedQuestions;
  static Contact? contacts;
  static List<Promotion>? promotions;
  static MyOrders? myOrders;
  static List<Category>? categories;
  static Statistics? statistics;
  static OrdersInProgress? orders;

  factory SingletonShopData() {
    return _instance;
  }
}
