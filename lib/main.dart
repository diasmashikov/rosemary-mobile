import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart';
import 'package:rosemary/cubit/main_cubit.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/network_serivce.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/main_domain.dart';
import 'package:rosemary/router.dart';
import 'package:rosemary/screens/main_screen.dart';
import 'package:rosemary/screens/no_internet_screen.dart';
import 'package:rosemary/utils/singletons/singleton_connection_status.dart';
import 'package:rosemary/utils/singletons/singleton_order_count.dart';
import 'package:rosemary/utils/singletons/singleton_orders.dart';
import 'package:rosemary/utils/singletons/singleton_shop_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'data/models/askedQuestion.dart';
import 'data/models/login.dart';
import 'data/models/order.dart';

import 'package:timezone/standalone.dart' as tz1;
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  String? _email;
  String? _password;
  String? _token = null;
  int? _orderItemsCount;
  User? _userData;
  bool? _adminAccess;

  print("Xyi");

  //shop data
  late List<AskedQuestion>? askedQuestions;

  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await FlutterConfig.loadEnvVariables();

  MainDomain _mainCubit = MainDomain(
    repository: Repository(
      networkService: NetworkService(),
    ),
  );

  Future<void> getLastSavedUserData() async {
    final prefs = await SharedPreferences.getInstance();

    String? email = "diashok@mail.com";
    String? password = "123456789";

    _email = (email != null) ? email : null;
    _password = (password != null) ? password : null;
  }

  Future<void> loadShopData() async {
    var orders;
    var statistics;

    _mainCubit
        .fetchEntryData(
            userId: _userData!.id,
            status: "Cart",
            isAdmin: _adminAccess.toString(),
            token: _token)
        .then((entryData) {
      var orderCart = entryData!.orderCart;
      var askedQuestions = entryData.askedQuestions;
      var contacts = entryData.contacts;
      var promotions = entryData.promotions;
      var myOrders = entryData.myOrders;
      var categories = entryData.categories;
      if (_userData!.isAdmin == true) {
        orders = entryData.orders;
        statistics = entryData.statistics;
      }

      if ((orderCart != null)) {
        print(orderCart);
        _orderItemsCount = orderCart.orderItems.length;
        SingletonOrderCount.orderCount = _orderItemsCount;
      } else {
        _orderItemsCount = 0;
        SingletonOrderCount.orderCount = 0;
      }

      SingletonShopData.askedQuestions = askedQuestions;
      SingletonShopData.contacts = contacts;
      SingletonShopData.promotions = promotions;
      SingletonShopData.myOrders = myOrders;
      SingletonShopData.categories = categories;
      if (_userData!.isAdmin == true) {
        SingletonShopData.orders = orders;
        SingletonShopData.statistics = statistics;
      }

      runApp(MyApp(
        router: AppRouter(),
        repository: Repository(
          networkService: NetworkService(),
        ),
        adminAccess: _adminAccess,
        userData: _userData,
        token: _token,
        hasConnection: ConnectionStatusSingleton.getInstance().hasConnection,
      ));
    });

/*
    futureGroup.future.then((shopListData) {
      
    });
    */

// that is where the app loads
  }

  Future<void>? login() async {
    print("LOGIN");
    print(_email);
    print(_password);
    await _mainCubit
        .postLogin(email: _email, password: _password)
        .then((loginData) {
      _token = loginData!.token;
      _userData = loginData.user;
      _adminAccess = _userData!.isAdmin;
      print(_token);
      //loading shopData
      loadShopData();
    });
  }

  void saveLoginDataForTheNextTime() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("loginEmail", _email!);
    await prefs.setString("loginPassword", _password!);
  }

  void runAppWithDataLoaded() async {
    await getLastSavedUserData();
    login();
    saveLoginDataForTheNextTime();
  }

  //Internet Connection System Checker starting
  WidgetsFlutterBinding.ensureInitialized();
  ConnectionStatusSingleton connectionStatus =
      ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();
  //bool hasConnection = await connectionStatus.checkConnection();
  //print(hasConnection);

  if (await connectionStatus.checkConnection() == true) {
    runAppWithDataLoaded();
  } else {
    runApp(MyApp(
        router: AppRouter(),
        repository: Repository(
          networkService: NetworkService(),
        ),
        adminAccess: _adminAccess,
        userData: _userData,
        token: _token,
        hasConnection: ConnectionStatusSingleton.getInstance().hasConnection));
  }
  print(ConnectionStatusSingleton.getInstance().hasConnection);
}

class MyApp extends StatelessWidget {
  final AppRouter router;
  final Repository repository;
  final bool? adminAccess;
  final User? userData;
  final String? token;
  final bool hasConnection;

  const MyApp(
      {Key? key,
      required this.router,
      required this.repository,
      required this.adminAccess,
      required this.userData,
      required this.token,
      required this.hasConnection})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: (hasConnection == true)
            ? MainScreen(
                repository: repository,
                adminAccess: adminAccess,
                token: token,
                userData: userData)
            : NoInternetScreen(restartTheApp: main),
        theme: ThemeData(
          primaryColor: Color.fromRGBO(237, 236, 232, 1),
        ),
      );
    });
  }
}
