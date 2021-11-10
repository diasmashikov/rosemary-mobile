import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosemary/constants/colors.dart';
import 'package:rosemary/constants/responsive_ui.dart';
import 'package:rosemary/cubit/statistics_cubit.dart';
import 'package:rosemary/data/models/statistics/financials.dart';
import 'package:rosemary/data/models/statistics/orders.dart';
import 'package:rosemary/data/models/statistics/productsValue.dart';
import 'package:rosemary/data/models/statistics/statistics.dart';
import 'package:rosemary/data/models/statistics/users.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/screens/adminScreens/statisticsScreens/clientsOnAppScreen.dart';

import 'package:rosemary/screens/adminScreens/statisticsScreens/moneyVolumeScreen.dart';
import 'package:rosemary/screens/adminScreens/statisticsScreens/mostBuyingProductsScreen.dart';
import 'package:rosemary/screens/adminScreens/statisticsScreens/mostBuyingStreetsScreen.dart';
import 'package:rosemary/screens/adminScreens/statisticsScreens/numberOfProductsScreen.dart';
import 'package:rosemary/screens/adminScreens/statisticsScreens/ordersVolumeScreen.dart';
import 'package:rosemary/screens/adminScreens/statisticsScreens/productsValueScreen.dart';
import 'package:rosemary/screens/singleScreens/shopping_cart_screen.dart';
import 'package:rosemary/utils/widgets/custom_app_bar.dart';
import 'package:rosemary/utils/singletons/singleton_shop_data.dart';

import '../../navigation_drawer_widget.dart';
import '../singleScreens/favorites_screen.dart';
import 'crudScreens/crudScreen.dart';

import 'package:sizer/sizer.dart';

class AdminPanelScreen extends StatefulWidget {
  final String? token;
  final User? userData;
  final Repository repository;

  final int? cartOrderItemsCount;

  const AdminPanelScreen(
      {Key? key,
      required this.token,
      required this.userData,
      required this.repository,
      required this.cartOrderItemsCount})
      : super(key: key);
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanelScreen> {
  // for ios
  double clothImageWidth = 400;
  double clothImageHeight = 380;
  double verticalMargin = 40;

  late StatisticsCubit _statisticsCubit;
  late Statistics? statistics;

  // for android
  //double productCellWidth = 160;
  //double productCellHeight = 240;

  @override
  void initState() {
    super.initState();
    _statisticsCubit = BlocProvider.of<StatisticsCubit>(context);

    //_statisticsCubit.fetchStatistics(token: widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavigationDrawerWidget(
            cartOrderItemsCount: 0,
            token: widget.token,
            userData: widget.userData,
            repository: widget.repository),
        appBar: CustomAppBar(
            title: "Админ панель",
            favoriteIcon: null,
            shoppingCartIcon: null,
            settingsIcon: null,
            adminPanel: null,
            cartOrderItemsCount: 0,
            token: widget.token,
            userData: widget.userData,
            repository: widget.repository),
        body: BlocBuilder<StatisticsCubit, StatisticsState>(
          builder: (context, state) {
            /*
            if (!(state is StatisticsLoaded)) {
              return Center(child: CircularProgressIndicator());
            }
            */

            statistics = SingletonShopData.statistics;
            //(state as StatisticsLoaded).statistics;

            return Container(
              margin: EdgeInsets.symmetric(
                  horizontal: APP_SCREEN_CONTENT_PADDING_H_WIDTH,
                  vertical: APP_SCREEN_CONTENT_PADDING_V_WIDTH),
              child: ListView(
                children: [
                  _buildCRUDContainer(
                      firstLine: "Добавляй, изменияй, удаляй",
                      secondLine: "В ДАННОЙ",
                      thirdLine: "секции с Rosemary Mobile",
                      width: double.maxFinite,
                      height: 20.h,
                      imagePath: "assets/goods_images/product4.jpg",
                      activePeriod: "13 августа по 1 сентября",
                      promotionSlogan: "Женственность - прекрасна"),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: 14.w / 4.h,
                    children: [
                      _buildTotalSalesTodayContainer(statistics!.financialsStatistics),
                      _buildTotalOrdersTodayContainer(statistics!.ordersStatistics),
                      //_buildTheMostSellableProduct(),
                      //_buildTheMostBuyingStreet(),
                      _buildCustomersCount(statistics!.usersStatistics),
                      _buildProductsValue(statistics!.productsValueStatistics),
                      //_buildProductsTotalCount()
                    ],
                  ),
                ],
              ),
            );
          },
        ));
  }

  Widget _buildCRUDContainer({
    required double width,
    required double height,
    required String imagePath,
    required String activePeriod,
    required String promotionSlogan,
    required String firstLine,
    required String secondLine,
    required String thirdLine,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CRUDScreen(
                token: widget.token,
                userData: widget.userData,
                repository: widget.repository,
                cartOrderItemsCount: widget.cartOrderItemsCount)));
      },
      child: Container(
        width: width,
        child: Card(
          child: Column(
            children: [
              Stack(children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  height: height,
                  width: width,
                  child: Image.asset(
                    imagePath,
                    height: height,
                    width: width,
                    fit: BoxFit.cover,
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                    colorBlendMode: BlendMode.darken,
                  ),
                ),
                Column(children: <Widget>[
                  SizedBox(
                    height: height / 4,
                  ),
                  Center(
                      child: Text(firstLine,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Merriweather-Regular',
                              fontSize: 11.5.sp))),
                  Center(
                      child: Text(secondLine,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Merriweather-Bold',
                              fontSize: 24.sp))),
                  Center(
                      child: Text(thirdLine,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Merriweather-Regular',
                              fontSize: 11.sp))),
                ])
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalSalesTodayContainer(Financials financials) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MoneyVolumeScreen(
                  token: widget.token,
                  userData: widget.userData,
                  repository: widget.repository)));
        },
        child: Card(
          child: Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.symmetric(
                horizontal: APP_SCREEN_CONTENT_PADDING_H_WIDTH,
                vertical: 1.25.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.price_change_outlined,
                      color: Color.fromRGBO(58, 67, 59, 0.8),
                    ),
                    SizedBox(
                      width: 1.5.w,
                    ),
                    Text("Продажи",
                        style: TextStyle(
                            color: Color.fromRGBO(58, 67, 59, 0.8),
                            fontFamily: 'Merriweather-Regular',
                            fontSize: 8.sp))
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(financials.totalSales.toString() + " KZT",
                    style: TextStyle(
                        color: Color.fromRGBO(0, 24, 51, 1),
                        fontFamily: 'SolomonSans-SemiBold',
                        fontSize: 13.sp)),
              ],
            ),
          ),
        ));
  }

  Widget _buildTotalOrdersTodayContainer(Orders orders) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => OrderVolumeScreen(
                token: widget.token,
                userData: widget.userData,
                repository: widget.repository)));
      },
      child: Card(
        child: Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.symmetric(
              horizontal: APP_SCREEN_CONTENT_PADDING_H_WIDTH, vertical: 1.25.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                  ),
                  SizedBox(
                    width: 1.5.w,
                  ),
                  Text("Кол-во заказов",
                      style: TextStyle(
                          color: Color.fromRGBO(58, 67, 59, 0.8),
                          fontFamily: 'Merriweather-Regular',
                          fontSize: 8.sp))
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(orders.totalOrders.toString(),
                  style: TextStyle(
                      color: Color.fromRGBO(0, 24, 51, 1),
                      fontFamily: 'SolomonSans-SemiBold',
                      fontSize: 13.sp)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTheMostSellableProduct() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MostBuyingProductsScreen(
                token: widget.token,
                userData: widget.userData,
                repository: widget.repository)));
      },
      child: Card(
        child: Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.symmetric(
              horizontal: APP_SCREEN_CONTENT_PADDING_H_WIDTH, vertical: 1.25.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.fireplace_outlined,
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                  ),
                  SizedBox(
                    width: 1.5.w,
                  ),
                  Text("Раскупающийся",
                      style: TextStyle(
                          color: Color.fromRGBO(58, 67, 59, 0.8),
                          fontFamily: 'Merriweather-Regular',
                          fontSize: 8.sp))
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Text("Носки Гуми",
                  style: TextStyle(
                      color: Color.fromRGBO(0, 24, 51, 1),
                      fontFamily: 'SolomonSans-SemiBold',
                      fontSize: 13.sp)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTheMostBuyingStreet() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MostBuyingStreetsScreen(
                token: widget.token,
                userData: widget.userData,
                repository: widget.repository)));
      },
      child: Card(
        child: Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.home_outlined,
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Заказывающий",
                      style: TextStyle(
                          color: Color.fromRGBO(58, 67, 59, 0.8),
                          fontFamily: 'Merriweather-Regular',
                          fontSize: 12))
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Text("Орбита 1",
                  style: TextStyle(
                      color: Color.fromRGBO(0, 24, 51, 1),
                      fontFamily: 'SolomonSans-SemiBold',
                      fontSize: 24)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomersCount(Users users) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ClientsOnAppScreen(
                token: widget.token,
                userData: widget.userData,
                repository: widget.repository)));
      },
      child: Card(
        child: Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.symmetric(
              horizontal: APP_SCREEN_CONTENT_PADDING_H_WIDTH, vertical: 1.25.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person_outlined,
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                  ),
                  SizedBox(
                    width: 1.5.w,
                  ),
                  Text("Пользователей",
                      style: TextStyle(
                          color: Color.fromRGBO(58, 67, 59, 0.8),
                          fontFamily: 'Merriweather-Regular',
                          fontSize: 8.sp))
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(users.totalUsers.toString(),
                  style: TextStyle(
                      color: Color.fromRGBO(0, 24, 51, 1),
                      fontFamily: 'SolomonSans-SemiBold',
                      fontSize: 13.sp)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductsValue(ProductsValue productsValue) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductsValueScreen(
                token: widget.token,
                userData: widget.userData,
                repository: widget.repository)));
      },
      child: Card(
        child: Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.symmetric(
              horizontal: APP_SCREEN_CONTENT_PADDING_H_WIDTH, vertical: 1.25.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.museum_outlined,
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                  ),
                  SizedBox(
                    width: 1.5.w,
                  ),
                  Text("Ценность товаров",
                      style: TextStyle(
                          color: Color.fromRGBO(58, 67, 59, 0.8),
                          fontFamily: 'Merriweather-Regular',
                          fontSize: 8.sp))
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(productsValue.totalProductsValue.toString() + " KZT",
                  style: TextStyle(
                      color: Color.fromRGBO(0, 24, 51, 1),
                      fontFamily: 'SolomonSans-SemiBold',
                      fontSize: 13.sp)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductsTotalCount() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NumberOfProductsScreen(
                token: widget.token,
                userData: widget.userData,
                repository: widget.repository)));
      },
      child: Card(
        child: Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.gite_outlined,
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Кол-во товаров",
                      style: TextStyle(
                          color: Color.fromRGBO(58, 67, 59, 0.8),
                          fontFamily: 'Merriweather-Regular',
                          fontSize: 10))
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Text("14314",
                  style: TextStyle(
                      color: Color.fromRGBO(0, 24, 51, 1),
                      fontFamily: 'SolomonSans-SemiBold',
                      fontSize: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
