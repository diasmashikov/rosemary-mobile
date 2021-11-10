import 'dart:async';
import 'dart:convert';
import 'package:rosemary/constants/responsive_ui.dart';
import 'package:sizer/sizer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
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

class MainScreen extends StatefulWidget {
  final Repository repository;
  final bool? adminAccess;
  final User? userData;
  final String? token;

  const MainScreen(
      {Key? key,
      required this.repository,
      required this.adminAccess,
      required this.userData,
      required this.token})
      : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState(this.repository);
}

class _MainScreenState extends State<MainScreen> {
  final Repository repository;
  late String _email;
  late String _password;
  String? _token = null;
  User? _userData;
  int? _orderItemsCount;
  bool? _adminAccess;

  bool isOffline = false;

  _MainScreenState(this.repository);

  @override
  void initState() {
    //setLastSavedUserData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _token = widget.token;
    _userData = widget.userData;
    _adminAccess = widget.adminAccess;
    print(_token.toString() + "ЭТО МЭЙН");
    print(_adminAccess.toString() + "ЭТО МЭЙН");
    print(SingletonOrderCount.orderCount);
    return Scaffold(
      drawer: Container(
        child: NavigationDrawerWidget(
          token: _token,
          userData: _userData,
          repository: repository,
          cartOrderItemsCount: SingletonOrderCount.orderCount,
        ),
      ),
      appBar: CustomAppBar(
          title: "Rosemary",
          favoriteIcon: Icons.favorite_outline,
          shoppingCartIcon: Icons.shopping_cart_outlined,
          settingsIcon: null,
          adminPanel: (_adminAccess == true)
              ? Icons.admin_panel_settings_outlined
              : null,
          cartOrderItemsCount: SingletonOrderCount.orderCount,
          token: _token,
          userData: _userData,
          repository: repository),
      body: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: APP_SCREEN_CONTENT_PADDING_H_WIDTH,
              vertical: APP_SCREEN_CONTENT_PADDING_V_WIDTH),
          children: <Widget>[
            Row(
              
            
            children: [Expanded(child: _buildNewbuysBanner()), SizedBox(width: 2.w,), Expanded(child: _buildDiscountBuysBanner())],),
            
            SizedBox(
              height: 1.h,
            ),
            _buildRecommendedCollection(),
            SizedBox(
              height: 2.h,
            ),
            _buildOrderDetailsSection(),
          ]),
    );
  }

  //based on a filter
  Widget _buildRecommendedCollection() {
    return InkWell(
        onTap: () {},
        child: Stack(alignment: Alignment.center, children: <Widget>[
          Container(
            child: Image.asset(
              'assets/goods_images/product6.jpg',
              height: 40.h,
              width: double.maxFinite,
              fit: BoxFit.cover,
              color: Color.fromRGBO(0, 0, 0, 0.5),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Positioned(
            bottom: 16.h,
            child: Column(
              children: [
                Text(
                  "Женская одежда",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'SolomonSans-SemiBold',
                      fontSize: 16.sp),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  "Попробуйте наш стиль",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'SolomonSans-SemiBold',
                      fontSize: 12.sp),
                )
              ],
            ),
          )
        ]));
  }

  Widget _buildNewbuysBanner() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => LoginCubit(repository: widget.repository),
            child: LoginScreen(repository: widget.repository),
          ),
        ));
      },
      child: Stack(alignment: Alignment.center, children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Image.asset(
            'assets/goods_images/product2.jpg',
            height: 20.h,
            width: double.maxFinite,
            fit: BoxFit.cover,
            color: Color.fromRGBO(0, 0, 0, 0.4),
            colorBlendMode: BlendMode.darken,
          ),
        ),
        Positioned(
          top: 7.h,
          child: Column(children: <Widget>[
            Text("",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 11.sp)),
            Text("Новые поступления",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 12.sp)),
            Text("",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 10.5.sp)),
          ]),
        )
      ]),
    );
  }

  Widget _buildDiscountBuysBanner() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => LoginCubit(repository: widget.repository),
            child: LoginScreen(repository: widget.repository),
          ),
        ));
      },
      child: Stack(alignment: Alignment.center, children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Image.asset(
            'assets/goods_images/product1.jpg',
            height: 20.h,
           width: double.maxFinite,
            fit: BoxFit.cover,
            color: Color.fromRGBO(0, 0, 0, 0.4),
            colorBlendMode: BlendMode.darken,
          ),
        ),
        Positioned(
          top: 7.h,
          child: Column(children: <Widget>[
            Text("",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 11.sp)),
            Text("Скидочные товары",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 12.sp)),
            Text("",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 10.5.sp)),
          ]),
        )
      ]),
    );

  }

  Widget _buildOrderDetailsSection() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 2.h),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Возможно вам понравится",
              style: TextStyle(
                color: Color.fromRGBO(58, 67, 59, 1),
                fontFamily: 'SolomonSans-SemiBold',
                fontSize: 12.sp,
              )),
          SizedBox(
            height: 1.5.h,
          ),
          Container(
            
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
               
                
                children: [
                  Wrap(
                    direction: Axis.horizontal,
                      alignment: WrapAlignment.start,
                      spacing: 16.0, // gap between adjacent chips
              
                      children: [1, 2, 3, 4, 5]
                          .map((element) => _buildOrderDetail())
                          .toList())
                ],
              ),
            ),
          )
        ]));
  }

  Widget _buildOrderDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
     
      Container(
        alignment: Alignment.center,
        height: 20.h,
        width: 35.w,
        child: Image.asset(
          'assets/goods_images/product4.jpg',
          height: 20.h,
          width: double.maxFinite,
          fit: BoxFit.cover,
          color: Color.fromRGBO(0, 0, 0, 0.4),
          colorBlendMode: BlendMode.darken,
        ),),
        SizedBox(height: 1.h,),
        Text("Платье \"Гуми\"",
              
                               style: TextStyle(
                    
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                  )),
              SizedBox(height: 1.h),
              Text("200" + " KZT",
              
                               style: TextStyle(
                    
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'SolomonSans-SemiBold',
                  )),

        /*
          CachedNetworkImage(
            cacheManager: CacheManager(
                Config('customCacheKey', stalePeriod: Duration(days: 7))),
            key: UniqueKey(),
            imageUrl: orderItem.product.image,
            fit: BoxFit.cover,
            height: 100,
            width: 100,
            placeholder: (context, url) => Container(color: Colors.grey),
            memCacheHeight: 250,
          )),
          */
      
    ]);
  }
}
