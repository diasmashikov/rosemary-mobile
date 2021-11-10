import 'package:flutter/material.dart';
import 'package:rosemary/constants/colors.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/utils/widgets/custom_app_bar.dart';

import '../../../navigation_drawer_widget.dart';

class OrderVolumeScreen extends StatefulWidget {
  final String? token;
  final User? userData;
  final Repository repository;

  const OrderVolumeScreen(
      {Key? key,
      required this.token,
      required this.userData,
      required this.repository})
      : super(key: key);
  @override
  _OrderVolumeState createState() => _OrderVolumeState();
}

class _OrderVolumeState extends State<OrderVolumeScreen> {
  // for ios
  double clothImageWidth = 400;
  double clothImageHeight = 380;
  double verticalMargin = 40;

  // for android
  //double productCellWidth = 160;
  //double productCellHeight = 240;
  @override
  Widget build(BuildContext context) => Scaffold(
      drawer: NavigationDrawerWidget(
        cartOrderItemsCount: 0,
          token: widget.token,
          userData: widget.userData,
          repository: widget.repository),
      appBar: CustomAppBar(
        cartOrderItemsCount: 0,
          title: "Заказы",
          favoriteIcon: null,
          shoppingCartIcon: null,
          settingsIcon: null,
          adminPanel: null,
          token: widget.token,
          userData: widget.userData,
          repository: widget.repository),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView(
          children: [
            _buildTotalOrdersContainer(),
            SizedBox(height: 24,),
            _buildTotalOrdersDaily(),
            SizedBox(height: 24,),
            _buildOpenOrdersDaily(),
            SizedBox(height: 24,),
            _buildSuccessfulOrdersDaily(),
            SizedBox(height: 24,),
            _buildOrdersMonthly(),
            SizedBox(height: 24,),
            _buildOrdersYearly(),
            SizedBox(height: 24,),
            _buildTheAverageCheck(),
            SizedBox(height: 24,),
            _buildTheMostExpensiveCheck()


           
          ],
        ),
      ));

 Widget _buildTotalOrdersContainer() {
    return InkWell(
        onTap: () {},
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
                      Icons.shopping_bag_outlined,
                      size: 28,
                      color: Color.fromRGBO(58, 67, 59, 0.8),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Текущие заказы",
                        style: TextStyle(
                            color: Color.fromRGBO(58, 67, 59, 0.8),
                            fontFamily: 'Merriweather-Regular',
                            fontSize: 16))
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                    "Данная секция представляет вам свежую информацию по всем заказам в компании. Текущее кол-во открытых заказов составляет 314 штук",
                    style: TextStyle(
                        color: Color.fromRGBO(0, 24, 51, 1),
                        fontFamily: 'SolomonSans-SemiBold',
                        fontSize: 16)),
              ],
            ),
          ),
        ));
  }

  Widget _buildTotalOrdersDaily() {
    return Row(
      children: [
        CircleAvatar(
                        backgroundColor: PRIMARY_DARK_COLOR,
                        radius: 20,
                        child: IconButton(
                          alignment: Alignment.center,
                          icon: Icon(Icons.favorite_outline,
                              size: 20, color: WHITE_COLOR),
                          onPressed: () => {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Сохранено'),
                              duration: const Duration(seconds: 2),
                            ))
                          },
                        ),
                      ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("438 штук",
                style: TextStyle(
                    color: Color.fromRGBO(0, 24, 51, 1),
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 20)),
            Text("Общее кол-во заказов за день",
                style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 12))
          ],
        )
      ],
    );
  }

  Widget _buildOpenOrdersDaily() {
    return Row(
      children: [
        CircleAvatar(
                        backgroundColor: PRIMARY_DARK_COLOR,
                        radius: 20,
                        child: IconButton(
                          alignment: Alignment.center,
                          icon: Icon(Icons.favorite_outline,
                              size: 20, color: WHITE_COLOR),
                          onPressed: () => {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Сохранено'),
                              duration: const Duration(seconds: 2),
                            ))
                          },
                        ),
                      ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("314 штук",
                style: TextStyle(
                    color: Color.fromRGBO(0, 24, 51, 1),
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 20)),
            Text("Открытые заказы за день",
                style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 12))
          ],
        )
      ],
    );
  }

  Widget _buildSuccessfulOrdersDaily() {
    return Row(
      children: [
        CircleAvatar(
                        backgroundColor: PRIMARY_DARK_COLOR,
                        radius: 20,
                        child: IconButton(
                          alignment: Alignment.center,
                          icon: Icon(Icons.favorite_outline,
                              size: 20, color: WHITE_COLOR),
                          onPressed: () => {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Сохранено'),
                              duration: const Duration(seconds: 2),
                            ))
                          },
                        ),
                      ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("124 штук",
                style: TextStyle(
                    color: PRIMARY_DARK_COLOR,
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 20)),
            Text("Успешных заказов за день",
                style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 12))
          ],
        )
      ],
    );
  }

  Widget _buildOrdersYearly() {
    return Row(
      children: [
        CircleAvatar(
                        backgroundColor: PRIMARY_DARK_COLOR,
                        radius: 20,
                        child: IconButton(
                          alignment: Alignment.center,
                          icon: Icon(Icons.favorite_outline,
                              size: 20, color: WHITE_COLOR),
                          onPressed: () => {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Сохранено'),
                              duration: const Duration(seconds: 2),
                            ))
                          },
                        ),
                      ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("31520 штук",
                style: TextStyle(
                    color: PRIMARY_DARK_COLOR,
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 20)),
            Text("Успешных заказов за месяц",
                style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 12))
          ],
        )
      ],
    );
  }

  Widget _buildOrdersMonthly() {
    return Row(
      children: [
        CircleAvatar(
                        backgroundColor: PRIMARY_DARK_COLOR,
                        radius: 20,
                        child: IconButton(
                          alignment: Alignment.center,
                          icon: Icon(Icons.favorite_outline,
                              size: 20, color: WHITE_COLOR),
                          onPressed: () => {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Сохранено'),
                              duration: const Duration(seconds: 2),
                            ))
                          },
                        ),
                      ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("2954 штук",
                style: TextStyle(
                    color: PRIMARY_DARK_COLOR,
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 20)),
            Text("Успешных заказов за месяц",
                style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 12))
          ],
        )
      ],
    );
  }

  Widget _buildTheAverageCheck() {
    return Row(
      children: [
        CircleAvatar(
                        backgroundColor: PRIMARY_DARK_COLOR,
                        radius: 20,
                        child: IconButton(
                          alignment: Alignment.center,
                          icon: Icon(Icons.favorite_outline,
                              size: 20, color: WHITE_COLOR),
                          onPressed: () => {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Сохранено'),
                              duration: const Duration(seconds: 2),
                            ))
                          },
                        ),
                      ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("11,344 KZT",
                style: TextStyle(
                    color: PRIMARY_DARK_COLOR,
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 20)),
            Text("Средний чек за заказ",
                style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 12))
          ],
        )
      ],
    );
  }

  Widget _buildTheMostExpensiveCheck() {
    return Row(
      children: [
        CircleAvatar(
                        backgroundColor: PRIMARY_DARK_COLOR,
                        radius: 20,
                        child: IconButton(
                          alignment: Alignment.center,
                          icon: Icon(Icons.favorite_outline,
                              size: 20, color: WHITE_COLOR),
                          onPressed: () => {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Сохранено'),
                              duration: const Duration(seconds: 2),
                            ))
                          },
                        ),
                      ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("94,320 KZT",
                style: TextStyle(
                    color: PRIMARY_DARK_COLOR,
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 20)),
            Text("Самый дорогой чек",
                style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 12))
          ],
        )
      ],
    );
  }
  
}