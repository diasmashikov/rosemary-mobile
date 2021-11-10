import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as dio;

import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rosemary/data/models/order.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/models/product.dart';
import 'package:timezone/src/date_time.dart';

import 'models/category.dart';
import 'models/modelCharacteristics.dart';
import 'models/orderItem.dart';
import 'models/statistics/statistics.dart';

class NetworkService {
  var errorHandling;
  final baseUrl = "https://rosemary-server.herokuapp.com/api/v1";
  Future<List<dynamic>?> getCategories() async {
    try {
      final response = await get(Uri.parse(baseUrl + "/categories"));
      return jsonDecode(response.body) as List;
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> getFavorites({String? token, User? user}) async {
    try {
      final response = await get(
        Uri.parse(baseUrl + "/favorites" + "/" + user!.id),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> getEntryData(
      {required String userId,
      required String status,
      required String isAdmin,
      required String? token}) async {
    try {
      final response = await get(
        Uri.parse(baseUrl +
            "/users/getAllEntryData" +
            "/" +
            userId +
            "/" +
            status +
            "/" +
            isAdmin),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print("API CAAAAALL");
      log(response.body);
      return jsonDecode(response.body);
      
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> getStatistics({String? token}) async {
    try {
      final response = await get(
        Uri.parse(baseUrl + "/statistics"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      return null;
    }
  }

  Future<List<dynamic>?> getProducts(categoryId) async {
    try {
      final response =
          await get(Uri.parse(baseUrl + "/products" + "/" + categoryId));
      print(baseUrl + "/products" + categoryId);
      return jsonDecode(response.body) as List;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>?> getPromotions() async {
    try {
      final response = await get(Uri.parse(baseUrl + "/promotions"));
      print(baseUrl + "/promotions");
      return jsonDecode(response.body) as List;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>?> getAskedQuestions() async {
    try {
      final response = await get(Uri.parse(baseUrl + "/askedQuestions"));
      print(baseUrl + "/askedQuestions");
      return jsonDecode(response.body) as List;
    } catch (e) {
      return [];
    }
  }

  Future<dynamic>? getOrdersInProgress(
      String? token, TZDateTime dateAndTime) async {
    try {
      final response = await get(
        Uri.parse(baseUrl +
            "/orders" +
            "/getInProgressOrders" +
            "/" +
            dateAndTime.year.toString() +
            "/" +
            dateAndTime.month.toString() +
            "/" +
            dateAndTime.day.toString()),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print(baseUrl + "/orders" + "/getInProgressOrders");
      print(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      return [];
    }
  }

  Future<dynamic>? getMyOrders(String? token, User? userData) async {
    try {
      final response = await get(
        Uri.parse(baseUrl + "/orders" + "/get/MyOrders" + "/" + userData!.id),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print(baseUrl + "/orders" + "/getMyOrders");
      print(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getShoppingCartItems(token, userId) async {
    try {
      final response = await get(
        Uri.parse(baseUrl + "/orders" + "/" + userId + "/" + "Cart"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print("NS");
      print(baseUrl + "/orders");
      print(response.body);

      return jsonDecode(response.body) as List;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getCartOrder(
      {required String status, String? token, User? user}) async {
    try {
      final response = await get(
        Uri.parse(baseUrl + "/orders" + "/" + user!.id + "/" + status),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      return jsonDecode(response.body) as List;
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> getUserData(token, userId) async {
    print(token);
    try {
      final response = await get(
        Uri.parse(baseUrl + "/users" + "/" + userId),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print("NS");
      print(baseUrl + "/users");
      print(response.body);

      return jsonDecode(response.body);
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> getContacts() async {
    try {
      final response = await get(
        Uri.parse(baseUrl + "/contacts"),
      );
      print("NS");
      print(baseUrl + "/contacts");
      print(response.body);
      print("dalbaeb");

      return jsonDecode(response.body);
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> postLogin(email, password) async {
    try {
      Map loginData = {'email': email, 'password': password};
      var body = json.encode(loginData);
      final response = await post(Uri.parse(baseUrl + "/users/login"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body);

      print(baseUrl + "/users/login");
      log("network service " + response.body);

      errorHandling = response.body;

      return jsonDecode(response.body);
    } catch (e) {
      return errorHandling;
    }
  }

  Future<void> postAskedQuestion(title, description, token) async {
    try {
      Map askedQuestionData = {'title': title, 'description': description};
      var body = json.encode(askedQuestionData);
      final response = await post(Uri.parse(baseUrl + "/askedQuestions"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: body);
    } catch (e) {}
  }

  Future<void> postFavorite(
      {String? token, User? user, required List<String> products}) async {
    try {
      Map favoriteData = {'products': products, 'user': user!.id};
      var body = json.encode(favoriteData);
      final response = await post(Uri.parse(baseUrl + "/favorites"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: body);
    } catch (e) {}
  }

  Future<void> postOrderCart(
      {required Product product,
      String? token,
      User? user,
      required int quantity,
      required String? pickedSize}) async {
    try {
      print("did u even get here?");
      Map orderCartData = {
        'orderItems': [
          {
            "product": product.id,
            "quantity": quantity,
            "pickedSize": pickedSize
          }
        ],
        "shippingAddress1": user!.street + ", " + user.homeNumber,
        "region": user.region,
        "city": user.city,
        "zip": user.zip,
        'country': user.country,
        'phone': user.phone,
        'user': user.id
      };
      var body = json.encode(orderCartData);
      final response = await post(Uri.parse(baseUrl + "/orders"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: body);
      print("POST MADE");
    } catch (e) {}
  }

  Future<void> postCategory(
      {String? token, required String categoryName, File? image}) async {
    try {
      print("NS POST CATEGORY STARTED");
      var dioInstance = dio.Dio();
      var formData = dio.FormData.fromMap({
        'name': categoryName,
        'image': await dio.MultipartFile.fromFile(image!.path,
            filename: image.path.split('/').last,
            contentType: MediaType("image", "jpg"))
      });
      dioInstance.options.contentType = 'application/json';
      dioInstance.options.headers['authorization'] = "Bearer $token";

      var response = await dioInstance.post(
        baseUrl + "/categories",
        data: formData,
      );
    } catch (e) {}
  }

  Future<void>? postUser(
      {required String email,
      required String firstName,
      required String lastName,
      required String phoneNumberPrefix,
      required String phoneNumber,
      required String password}) async {
    try {
      print("did u even get here? REGISTRATION");
      print(password);
      Map userData = {
        'name': firstName + " " + lastName,
        "email": email,
        "phone": phoneNumberPrefix + phoneNumber,
        "password": password,
        "street": "temporary",
        "apartment": "temporary",
        "zip": "temporary",
        "city": "temporary",
        "region": "temporary",
        "homeNumber": "temporary",
        "country": "temporary",
      };
      var body = json.encode(userData);
      final response = await post(Uri.parse(baseUrl + "/users/register"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body);
      print("POST MADE REGISTRATION");
    } catch (e) {}
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
      required List<File> images, required String fashionCollection, required bool recommended, required bool newArrival, required double discount}) async {
    print(modelCharacteristics);
    print(modelCharacteristics.modelHeight);
    print(modelCharacteristics.modelWeight);
    print(modelCharacteristics.modelSize);

    try {
      print("NS POST PRODUCT STARTED");
      var dioInstance = dio.Dio();

      var formData = dio.FormData.fromMap({
        'category': categoryId,
        'name': name,
        'price': int.parse(price),
        'color': color,
        'sizes': sizes,
        'description': description,
        'material': material,
        'countryProducer': countryProducer,
        "style": style,
        "discount" : discount,
        "fashionCollection" : fashionCollection,
        "newArrival" : newArrival,
        "recommended" : recommended,
        "countInStock": countInStock,
        "modelCharacteristics[modelHeight]":
            modelCharacteristics.modelHeight.toInt(),
        "modelCharacteristics[modelWeight]":
            modelCharacteristics.modelWeight.toInt(),
        "modelCharacteristics[modelSize]": modelCharacteristics.modelSize,
        'image': await dio.MultipartFile.fromFile(image!.path,
            filename: image.path.split('/').last,
            contentType: MediaType("image", "jpg")),
      });

      for (var imagee in images) {
        formData.files.addAll([
          MapEntry(
              'images',
              await dio.MultipartFile.fromFile(imagee.path,
                  filename: imagee.path.split('/').last,
                  contentType: MediaType("image", "jpg")))
        ]);
      }

      dioInstance.options.contentType = 'application/json';
      dioInstance.options.headers['authorization'] = "Bearer $token";

      var response = await dioInstance.post(
        baseUrl + "/products",
        data: formData,
      );
    } on dio.DioError catch (e) {
      print(e.message);
    } catch (e) {}
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
    try {
      print("NS");
      print(firstLine);
      print(imageFile!.path.split('/').last);
      print(imageFile.path);

      var dioInstance = dio.Dio();
      var formData = dio.FormData.fromMap({
        'firstLine': firstLine,
        'secondLine': secondLine,
        'thirdLine': thirdLine,
        'description': description,
        'activePeriod': activePeriod,
        'slogan': slogan,
        'image': await dio.MultipartFile.fromFile(imageFile.path,
            filename: imageFile.path.split('/').last,
            contentType: MediaType("image", "jpg"))
      });
      dioInstance.options.contentType = 'application/json';
      dioInstance.options.headers['authorization'] = "Bearer $token";

      var response = await dioInstance.post(
        baseUrl + "/promotions",
        data: formData,
      );
    } on dio.DioError catch (e) {
      print(e.message);
    }
  }

  deletePromotion(String id, String? token) async {
    try {
      await delete(
        Uri.parse(baseUrl + "/promotions" + "/" + id),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      throw (e);
    }
  }

  Future<void> deleteAskedQuestion(id, token) async {
    try {
      await delete(
        Uri.parse(baseUrl + "/askedQuestions" + "/" + id),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      throw (e);
    }
  }

  Future<void> deleteCategory(String id, String token) async {
    try {
      await delete(
        Uri.parse(baseUrl + "/categories" + "/" + id),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      throw (e);
    }
  }

  Future<void> deleteFavorite(String? token, User? user, String favoritedId,
      String itemToDelete) async {
    try {
      await delete(
        Uri.parse(baseUrl +
            "/favorites" +
            "/" +
            favoritedId +
            "/" +
            user!.id +
            "/" +
            itemToDelete),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      throw (e);
    }
  }

  Future<void> deleteProduct(String id, String token) async {
    try {
      await delete(
        Uri.parse(baseUrl + "/products" + "/" + id),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      throw (e);
    }
  }

  Future<void> deleteShoppingCartItem(
      String? token,
      String userId,
      Order shoppingCartOrder,
      int index,
      String orderItemId,
      int changedTotalPrice) async {
    try {
      shoppingCartOrder.orderItems.removeAt(index);
      if (shoppingCartOrder.orderItems.isEmpty) {
        await delete(
          Uri.parse(baseUrl + "/orders" + "/" + shoppingCartOrder.id),
          headers: <String, String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
      } else {
        Map cartOrderData = {
          "orderItems": shoppingCartOrder.orderItems,
          "totalPrice": changedTotalPrice
        };
        var body = json.encode(cartOrderData);
        await put(
            Uri.parse(baseUrl +
                "/orders" +
                "/orderItems" +
                "/" +
                shoppingCartOrder.id +
                "/" +
                orderItemId),
            headers: <String, String>{
              'Accept': 'application/json',
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
            body: body);
      }
    } catch (e) {}
  }

  Future<void> putContacts(
      String id,
      List<String> phoneNumbersArr,
      List<String> socialMediasArr,
      String workingSchedule,
      String? token) async {
    try {
      Map contactsData = {
        'phoneNumbers': phoneNumbersArr,
        'socialMedias': socialMediasArr,
        'workingSchedule': workingSchedule
      };
      var body = json.encode(contactsData);
      await put(Uri.parse(baseUrl + "/contacts" + "/" + id),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: body);
    } catch (e) {
      throw (e);
    }
  }

  Future<void> putAskedQuestion(
      String id, String? token, String title, String description) async {
    try {
      Map askedQuestionData = {'title': title, 'description': description};

      var body = json.encode(askedQuestionData);
      await put(Uri.parse(baseUrl + "/askedQuestions" + "/" + id),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: body);
    } catch (e) {
      throw (e);
    }
  }

  Future<void> putInfo(
      {required String email,
      required String firstName,
      required String lastName,
      required String phone,
      User? user,
      token}) async {
    try {
      Map userInfoData = {
        'country': user!.country,
        'region': user.region,
        'city': user.city,
        'zip': user.zip,
        'street': user.street,
        'homeNumber': user.homeNumber,
        'name': firstName + " " + lastName,
        'email': email,
        'phone': phone,
        'isAdmin': user.isAdmin,
      };

      var body = json.encode(userInfoData);
      await put(Uri.parse(baseUrl + "/users" + "/" + user.id),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: body);
    } catch (e) {
      throw (e);
    }
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
    try {
      Map shippingAddressData = {
        'country': country,
        'region': region,
        'city': city,
        'zip': zip,
        'street': address,
        'homeNumber': homeNumber,
        'name': user!.name,
        'email': user.email,
        'phone': user.phone,
        'isAdmin': user.isAdmin,
        'apartment': ""
      };

      var body = json.encode(shippingAddressData);
      await put(Uri.parse(baseUrl + "/users" + "/" + user.id),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: body);
    } catch (e) {
      throw (e);
    }
  }

  Future<void> putCategory(
      String id, String token, String categoryName, File? image) async {
    print("NS PUT CATEGORY STARTED");
    try {
      if (image != null) {
        var dioInstance = dio.Dio();
        var formData = dio.FormData.fromMap({
          'name': categoryName,
          'image': await dio.MultipartFile.fromFile(image.path,
              filename: image.path.split('/').last,
              contentType: MediaType("image", "jpg"))
        });
        dioInstance.options.contentType = 'application/json';
        dioInstance.options.headers['authorization'] = "Bearer $token";
        var response = await dioInstance.put(
          baseUrl + "/categories" + "/" + id,
          data: formData,
        );
        print(response.data);
      } else {
        Map askedQuestionData = {'name': categoryName};

        var body = json.encode(askedQuestionData);
        await put(Uri.parse(baseUrl + "/categories" + "/" + id),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
            body: body);
      }
    } catch (e) {}
  }

  Future<void> putOrderPending(
      {String? token,
      User? userData,
      required String status,
      required Order cartOrder}) async {
    try {
      Map pendingOrderData = {'status': 'Pending'};
      var body = json.encode(pendingOrderData);
      await put(
          Uri.parse(baseUrl + "/orders" + "/" + cartOrder.id + "/" + status),
          headers: <String, String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: body);
      print(status + " STATUS JUST");
    } catch (e) {}
  }

  Future<void> putOrderStatus(
      String token, String orderId, String chosenStatus) async {
    try {
      print(chosenStatus + " BLYAT VOT ONO");
      if (chosenStatus == "Подготавливается") {
        chosenStatus = "Pending";
      } else if (chosenStatus == "Доставляется") {
        chosenStatus = "Shipping";
      } else if (chosenStatus == "Доставлен") {
        chosenStatus = "Shipped";
      }
      Map pendingOrderData = {'status': chosenStatus};
      var body = json.encode(pendingOrderData);
      await put(
          Uri.parse(baseUrl + "/orders" + "/" + orderId + "/" + chosenStatus),
          headers: <String, String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: body);
    } catch (e) {}
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
    print("NS PUT PRODUCT STARTED");
    try {
      if (image != null) {
        var dioInstance = dio.Dio();
        var formData = dio.FormData.fromMap({
          'category': categoryId,
          'name': name,
          'price': int.parse(price),
          'color': color,
          'sizes': sizes,
          'description': description,
          'material': material,
          'countryProducer': countryProducer,
          "style": style,
          "isFeatured": false,
          "countInStock": int.parse(countInStock),
          "modelCharacteristics[modelHeight]":
              modelCharacteristics.modelHeight.toInt(),
          "modelCharacteristics[modelWeight]":
              modelCharacteristics.modelWeight.toInt(),
          "modelCharacteristics[modelSize]": modelCharacteristics.modelSize,
          'image': await dio.MultipartFile.fromFile(image.path,
              filename: image.path.split('/').last,
              contentType: MediaType("image", "jpg"))
        });
        dioInstance.options.contentType = 'application/json';
        dioInstance.options.headers['authorization'] = "Bearer $token";

        var response = await dioInstance.put(
          baseUrl + "/products" + "/" + id,
          data: formData,
        );
      } else {
        modelCharacteristics.modelHeight =
            modelCharacteristics.modelHeight.toInt();
        modelCharacteristics.modelWeight =
            modelCharacteristics.modelWeight.toInt();
        Map productData = {
          'category': categoryId,
          'name': name,
          'price': int.parse(price),
          'color': color,
          'sizes': sizes,
          'description': description,
          'material': material,
          'countryProducer': countryProducer,
          "style": style,
          "isFeatured": false,
          "countInStock": int.parse(countInStock),
          "modelCharacteristics": modelCharacteristics
        };

        print(modelCharacteristics.modelHeight);
        print(modelCharacteristics.modelWeight);
        print(modelCharacteristics.modelSize);

        var body = json.encode(productData);
        await put(Uri.parse(baseUrl + "/products" + "/" + id),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
            body: body);
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<void> putOrderCart(
      {String? token,
      required Order cartOrder,
      User? user,
      required Product product,
      required String quantity,
      required String? size}) async {
    List<OrderItem> orderItems = cartOrder.orderItems;

    List<Map<String, dynamic>> orderItemsJSON = [];

    orderItemsJSON.add(OrderItem(
            quantity: int.parse(quantity),
            product: product,
            pickedSize: size,
            id: '')
        .toJson());

    try {
      Map cartOrderData = {'orderItems': orderItemsJSON, 'status': 'Cart'};

      print(orderItemsJSON);
      print(cartOrder.id);

      var body = json.encode(cartOrderData);
      await put(
          Uri.parse(baseUrl +
              "/orders" +
              "/" +
              cartOrder.id +
              "/" +
              cartOrder.status),
          headers: <String, String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: body);
    } catch (e) {
      throw (e);
    }
  }
}
