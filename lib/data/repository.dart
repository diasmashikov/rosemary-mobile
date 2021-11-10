import 'dart:io';

import 'package:flutter/src/widgets/icon_data.dart';
import 'package:rosemary/data/models/askedQuestion.dart';
import 'package:rosemary/data/models/category.dart';
import 'package:rosemary/data/models/login.dart';
import 'package:rosemary/data/models/order.dart';
import 'package:rosemary/data/models/ordersInProgress.dart';
import 'package:rosemary/data/models/product.dart';
import 'package:rosemary/data/network_serivce.dart';
import 'package:timezone/src/date_time.dart';

import 'models/contact.dart';
import 'models/entryData.dart';
import 'models/favorite.dart';
import 'models/modelCharacteristics.dart';
import 'models/myOrders.dart';
import 'models/promotion.dart';
import 'models/statistics/statistics.dart';
import 'models/user.dart';

class Repository {
  final NetworkService networkService;

  Repository({required this.networkService});

  Future<List<Category>?> getCategories() async {
    final categoriesRaw = await networkService.getCategories();
    return categoriesRaw?.map((element) => Category.fromJson(element)).toList();
  }

  Future<EntryData?> getEntryData(
      {required String userId,
      required String status,
      required String isAdmin,
      required String? token}) async {
    final entryDataRaw = await networkService.getEntryData(
        userId: userId, status: status, isAdmin: isAdmin, token: token);
    return EntryData.fromJson(entryDataRaw);
  }

  Future<Favorite?> getFavorites({String? token, User? user}) async {
    final favoritesRaw =
        await networkService.getFavorites(token: token, user: user);
    print(favoritesRaw.toString() + " RAAW");
    if (favoritesRaw.toString() == [].toString()) {
      return Favorite(id: "error", products: [], user: null);
    }
    return Favorite.fromJson(favoritesRaw[0]);
  }

  Future<Statistics?> getStatistics({String? token}) async {
    final statisticsRaw = await networkService.getStatistics(token: token);
    return Statistics.fromJson(statisticsRaw);
  }

  Future<List<Product>?> getProducts(categoryId) async {
    final productsRaw = await networkService.getProducts(categoryId);
    return productsRaw?.map((element) => Product.fromJson(element)).toList();
  }

  Future<List<Promotion>?> getPromotions() async {
    final promotionsRaw = await networkService.getPromotions();
    return promotionsRaw
        ?.map((element) => Promotion.fromJson(element))
        .toList();
  }

  Future<List<AskedQuestion>?> getAskedQuestions() async {
    final askedQuestionsRaw = await networkService.getAskedQuestions();
    return askedQuestionsRaw
        ?.map((element) => AskedQuestion.fromJson(element))
        .toList();
  }

  Future<Order?> getShoppingCartItems(token, userId) async {
    final shoppingCartItemsRaw =
        await networkService.getShoppingCartItems(token, userId);
    if (shoppingCartItemsRaw.isEmpty) {
      return null;
    } else {
      return Order.fromJson(shoppingCartItemsRaw[0]);
    }
  }

  Future<User?> getUserData(token, userId) async {
    final userDataRaw = await networkService.getUserData(token, userId);
    return User.fromJson(userDataRaw);
  }

  Future<OrdersInProgress> getOrdersInProgress(
      {String? token, required TZDateTime dateAndTime}) async {
    final ordersInProgressRaw =
        await networkService.getOrdersInProgress(token, dateAndTime);

    return OrdersInProgress.fromJson(ordersInProgressRaw);
  }

  Future<MyOrders> getMyOrders({String? token, User? userData}) async {
    final myOrdersRaw = await networkService.getMyOrders(token, userData);

    return MyOrders.fromJson(myOrdersRaw);
  }

  Future<Contact?> getContacts() async {
    final contactsRaw = await networkService.getContacts();
    return Contact.fromJson(contactsRaw[0]);
  }

  Future<Order?> getCartOrder(
      {required String status, String? token, User? user}) async {
    final cartOrderRaw = await networkService.getCartOrder(
        status: status, token: token, user: user);
    if (cartOrderRaw.isEmpty) {
      return null;
    } else {
      return Order.fromJson(cartOrderRaw[0]);
    }
  }

  Future<Login?> postLogin(email, password) async {
    final loginResponseRaw = await networkService.postLogin(email, password);
    if (!(loginResponseRaw is Map<String, dynamic>)) {
      print(loginResponseRaw);
      return Login(token: loginResponseRaw, user: null);
    }
    return Login.fromJson(loginResponseRaw);
  }

  Future<void> postPromotion(
      String firstLine,
      String secondLine,
      String thirdLine,
      String description,
      String activePeriod,
      String slogan,
      File? imageFile,
      String? token) async {
    print(firstLine);
    print("REPOSITORY");
    await networkService.postPromotion(firstLine, secondLine, thirdLine,
        description, activePeriod, slogan, imageFile, token);
  }

  Future<void> postAskedQuestion(
      String title, String description, String? token) async {
    final postAskedQuestionsResponse =
        await networkService.postAskedQuestion(title, description, token);
    return postAskedQuestionsResponse;
  }

  Future<void> postFavorite(
      {String? token, User? user, required List<String> products}) async {
    await networkService.postFavorite(
        token: token, user: user, products: products);
  }

  Future<void> postProduct(
      {String? token,
      required String categoryId,
      required String name,
      required String price,
      required String color,
      required String sizes,
      required String description,
      required String material,
      required String countryProducer,
      required String style,
      required String countInStock,
      required ModelCharacteristics modelCharacteristics,
      File? image,
      required List<File> images, required double discount, required bool recommended, required bool newArrival, required String fashionCollection}) async {
    final postProductResponse = await networkService.postProduct(
        token: token,
        categoryId: categoryId,
        name: name,
        image: image,
        images: images,
        price: price,
        color: color,
        sizes: sizes,
        description: description,
        material: material,

         discount: discount,
                            recommended:recommended,
                            newArrival: newArrival,
                            fashionCollection:fashionCollection,

        countryProducer: countryProducer,
        style: style,
        modelCharacteristics: modelCharacteristics,
        countInStock: countInStock);
    return postProductResponse;
  }

  Future<void> postCategory(
      {String? token, required String categoryName, File? image}) async {
    final postCategoryResponse = await networkService.postCategory(
        token: token, categoryName: categoryName, image: image);
    return postCategoryResponse;
  }

  Future<void>? postUser(
      {required String email,
      required String firstName,
      required String lastName,
      required String phoneNumberPrefix,
      required String phoneNumber,
      required String password}) async {
    await networkService.postUser(
        email: email,
        firstName: firstName,
        lastName: lastName,
        phoneNumberPrefix: phoneNumberPrefix,
        phoneNumber: phoneNumber,
        password: password);
  }

  Future<void> postOrderCart(
      {required Product product,
      String? token,
      User? user,
      required int quantity,
      required String? pickedSize}) async {
    final postOrderCartResponse = await networkService.postOrderCart(
        product: product,
        token: token,
        user: user,
        quantity: quantity,
        pickedSize: pickedSize);

    return postOrderCartResponse;
  }

  Future<void> putContacts(
      String id,
      List<String> phoneNumbersArr,
      List<String> socialMediasArr,
      String workingSchedule,
      String? token) async {
    await networkService.putContacts(
        id, phoneNumbersArr, socialMediasArr, workingSchedule, token);
  }

  Future<void> putOrderCart(
      {String? token,
      required Order cartOrder,
      User? user,
      required Product product,
      required String quantity,
      required String? size}) async {
    final putOrderCartResponse = await networkService.putOrderCart(
        token: token,
        cartOrder: cartOrder,
        user: user,
        product: product,
        quantity: quantity,
        size: size);

    return putOrderCartResponse;
  }

  Future<void> putOrderPending(
      {String? token,
      User? userData,
      required String status,
      required Order cartOrder}) async {
    final putOrderPendingResponse = await networkService.putOrderPending(
        token: token, userData: userData, status: status, cartOrder: cartOrder);
    return putOrderPendingResponse;
  }

  Future<void> putAskedQuestion(
      String id, String? token, String title, String description) async {
    final putAskedQuestionResponse =
        await networkService.putAskedQuestion(id, token, title, description);
    return putAskedQuestionResponse;
  }

  Future<void> putOrderStatus(
      String token, String orderId, String chosenStatus) async {
    await networkService.putOrderStatus(token, orderId, chosenStatus);
  }

  void putCategory(
      String id, String token, String categoryName, File? imageFile) async {
    final putCategoryResponse =
        await networkService.putCategory(id, token, categoryName, imageFile);
    return putCategoryResponse;
  }

  Future<void> putShippingAddress(
      {required String country,
      required String region,
      required String city,
      required String zip,
      required String address,
      required String homeNumber,
      User? user,
      String? token}) async {
    await networkService.putShippingAddress(
        country: country,
        region: region,
        city: city,
        zip: zip,
        address: address,
        homeNumber: homeNumber,
        user: user,
        token: token);
  }

  Future<void> putInfo(
      {required String email,
      required String firstName,
      required String lastName,
      required String phone,
      token,
      User? user}) async {
    await networkService.putInfo(
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        user: user,
        token: token);
  }

  Future<void> putProduct(
      {String? token,
      required String categoryId,
      required String name,
      File? image,
      required String price,
      required String color,
      required String sizes,
      required String description,
      required String material,
      required String countryProducer,
      required String style,
      required ModelCharacteristics modelCharacteristics,
      required String countInStock,
      required String id}) async {
    final putProductResponse = await networkService.putProduct(
        token: token,
        categoryId: categoryId,
        name: name,
        image: image,
        price: price,
        color: color,
        sizes: sizes,
        description: description,
        material: material,
        countryProducer: countryProducer,
        style: style,
        modelCharacteristics: modelCharacteristics,
        countInStock: countInStock,
        id: id);
    return putProductResponse;
  }

  void deletePromotion(String id, String? token) async {
    await networkService.deletePromotion(id, token);
  }

  Future<void> deleteAskedQuestion(id, token) async {
    final deleteAskedQuestionResponse =
        await networkService.deleteAskedQuestion(id, token);
    return deleteAskedQuestionResponse;
  }

  Future<void> deleteFavorite(
      {String? token,
      User? user,
      required String favoritedId,
      required String itemToDelete}) async {
    await networkService.deleteFavorite(token, user, favoritedId, itemToDelete);
  }

  Future<void> deleteCategory(String id, String token) async {
    final deleteCategoryResponse =
        await networkService.deleteCategory(id, token);
    return deleteCategoryResponse;
  }

  Future<void> deleteProduct(String id, String token) async {
    final deleteProductResponse = await networkService.deleteProduct(id, token);
    return deleteProductResponse;
  }

  void deleteShoppingCartItem(String? token, String userId, shoppingCartOrder,
      index, orderItemId, int changedTotalPrice) async {
    await networkService.deleteShoppingCartItem(token, userId,
        shoppingCartOrder, index, orderItemId, changedTotalPrice);
  }
}
