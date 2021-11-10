import 'package:rosemary/data/models/contact.dart';
import 'package:rosemary/data/models/ordersInProgress.dart';
import 'package:rosemary/data/models/product.dart';
import 'package:rosemary/data/models/promotion.dart';
import 'package:rosemary/data/models/statistics/statistics.dart';
import 'package:rosemary/data/models/user.dart';

import 'askedQuestion.dart';
import 'category.dart';
import 'myOrders.dart';
import 'order.dart';

class EntryData {
  Order orderCart;
  List<AskedQuestion> askedQuestions;
  Contact contacts;
  List<Promotion> promotions;
  MyOrders myOrders;
  List<Category> categories;
  OrdersInProgress? orders;
  Statistics? statistics;

  EntryData({
    required this.orderCart,
    required this.askedQuestions,
    required this.contacts,
    required this.promotions,
    required this.myOrders,
    required this.categories,
    required this.orders,
    required this.statistics,
  });

  EntryData.fromJson(Map json): 
  orderCart =(json['orderCart'].isEmpty) ? Order(orderItems: [], shippingAddress: "nothing", city: "nothing", zip: "nothing", country: "nothing",phone: "nothing", status: "nothing", totalPrice: 0, user: null, id:"nothing",) : Order.fromJson(json['orderCart'][0]),
  askedQuestions = json['askedQuestion']?.map<AskedQuestion>((element) => AskedQuestion.fromJson(element))
        .toList(),
  contacts = Contact.fromJson(json['contacts'][0]),
  promotions = json['promotions']?.map<Promotion>((element) => Promotion.fromJson(element))
        .toList(),
  myOrders = MyOrders.fromJson((json["myOrders"])),
  categories = json['categories']?.map<Category>((element) => Category.fromJson(element))
        .toList(),
  orders =  (json['orders'].isEmpty) ? null : OrdersInProgress.fromJson(json['orders']),
  statistics = (json['statistics'].isEmpty) ? null : Statistics.fromJson(json['statistics']);


}
