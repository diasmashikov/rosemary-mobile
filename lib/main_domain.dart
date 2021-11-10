import 'package:rosemary/data/models/askedQuestion.dart';
import 'package:rosemary/data/models/contact.dart';
import 'package:rosemary/data/models/myOrders.dart';
import 'package:rosemary/data/models/ordersInProgress.dart';
import 'package:rosemary/data/models/statistics/statistics.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';
import 'package:timezone/src/date_time.dart';

import 'data/models/category.dart';
import 'data/models/entryData.dart';
import 'data/models/login.dart';
import 'data/models/order.dart';
import 'data/models/promotion.dart';

class MainDomain {
  final Repository repository;

  MainDomain({required this.repository});

  Future<EntryData?> fetchEntryData(
      {required String userId,
      required String status,
      required String isAdmin,
      required String? token}) async {
    EntryData? entryDataResponse = await repository.getEntryData(
        userId: userId, status: status, isAdmin: isAdmin, token: token);
   
    return entryDataResponse;
  }

  Future<List<Category>?> fetchCategories() async {
    List<Category>? categoriesResponse = await repository.getCategories();
    return categoriesResponse;
  }

  Future<Order?> fetchOrderCart(
      {required String status,
      required String token,
      required User user}) async {
    Order? orderResponse =
        await repository.getCartOrder(status: status, token: token, user: user);
    return orderResponse;
  }

  Future<Login?> postLogin(
      {required String? email, required String? password}) async {
    Login? loginResponse = await repository.postLogin(email, password);
    return loginResponse;
  }

  Future<Statistics?> fetchStatistics({String? token}) async {
    Statistics? statisticsResponse =
        await repository.getStatistics(token: token);
    return statisticsResponse;
  }

  Future<OrdersInProgress?> fetchOrders(
      {required String token, required TZDateTime dateAndTime}) async {
    OrdersInProgress? ordersResponse = await repository.getOrdersInProgress(
        token: token, dateAndTime: dateAndTime);
    return ordersResponse;
  }

  Future<List<AskedQuestion>?> fetchAskedQuestions() async {
    List<AskedQuestion>? askedQuestionsResponse =
        await repository.getAskedQuestions();
    return askedQuestionsResponse;
  }

  Future<Contact?> fetchContacts() async {
    Contact? contactsResponse = await repository.getContacts();
    return contactsResponse;
  }

  Future<List<Promotion>?> fetchPromotions() async {
    List<Promotion>? promotionsResponse = await repository.getPromotions();
    return promotionsResponse;
  }

  Future<MyOrders> fetchMyOrders({String? token, User? user}) async {
    MyOrders? myOrdersResponse =
        await repository.getMyOrders(token: token, userData: user);
    return myOrdersResponse;
  }
}
