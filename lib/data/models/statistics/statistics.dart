import 'package:rosemary/data/models/statistics/productsValue.dart';
import 'package:rosemary/data/models/statistics/users.dart';

import 'financials.dart';
import 'orders.dart';

class Statistics {
  Financials financialsStatistics;
  Orders ordersStatistics;
  Users usersStatistics;
  ProductsValue productsValueStatistics;

  Statistics.fromJson(Map<String, dynamic> json)
      : financialsStatistics = Financials.fromJson(json["financialsStatistics"]),
        ordersStatistics = Orders.fromJson(json["ordersStatistics"]),
        usersStatistics = Users.fromJson(json["usersStatistics"]),
        productsValueStatistics = ProductsValue.fromJson(json['productsValueStatistics']);

  Map<String, dynamic> toJson() {
    return {
      "financialsStatistics": financialsStatistics,
      "ordersStatistics": ordersStatistics,
      "usersStatistics": usersStatistics,
      "productsValueStatistics": productsValueStatistics
    };
  }
}
