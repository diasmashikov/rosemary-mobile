import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:rosemary/constants/colors.dart';
import 'package:rosemary/cubit/login_cubit.dart';
import 'package:rosemary/cubit/shopping_cart_cubit.dart';
import 'package:rosemary/data/models/login.dart';
import 'package:rosemary/data/models/order.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/screens/singleScreens/login_screen.dart';
import 'package:rosemary/screens/singleScreens/shopping_cart_screen.dart';
import 'package:rosemary/utils/widgets/custom_app_bar.dart';
import 'package:rosemary/utils/singletons/singleton_connection_status.dart';
import 'package:rosemary/utils/singletons/singleton_order_count.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../navigation_drawer_widget.dart';
import 'singleScreens/favorites_screen.dart';

class NoInternetScreen extends StatefulWidget {
  final Function restartTheApp;
  const NoInternetScreen({
    Key? key,
    required this.restartTheApp,
  }) : super(key: key);
  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  late StreamSubscription _connectionChangeStream;

  _NoInternetScreenState();

  @override
  void initState() {
    ConnectionStatusSingleton connectionStatus =
        ConnectionStatusSingleton.getInstance();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);

    super.initState();
  }

  void connectionChanged(dynamic hasConnection) {
    widget.restartTheApp();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Мы подключаемся обратно :)'),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Stack(children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: new DecorationImage(
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                  Colors.white.withOpacity(0.09), BlendMode.dstATop),
              image: AssetImage(
                'assets/goods_images/product3.jpg',
              ),
            ),
          ),
        ),
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Отсутствует интернет соединение",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: PRIMARY_DARK_COLOR,
                      fontFamily: 'Merriweather-Bold',
                      fontSize: 24)),
              SizedBox(
                height: 12,
              ),
              Text("Мы будем ожидать Вашего скорейшего подключения :)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: PRIMARY_DARK_COLOR,
                      fontFamily: 'Merriweather-Regular',
                      fontSize: 16))
            ]),
      ]),
    ));
  }
}
