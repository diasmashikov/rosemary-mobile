import 'package:flutter/material.dart';
import 'package:rosemary/constants/colors.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/utils/widgets/custom_app_bar.dart';

import '../../../navigation_drawer_widget.dart';

class MoneyVolumeScreen extends StatefulWidget {
  final String? token;
  final User? userData;
  final Repository repository;

  const MoneyVolumeScreen(
      {Key? key,
      required this.token,
      required this.userData,
      required this.repository})
      : super(key: key);
  @override
  _MoneyVolumeState createState() => _MoneyVolumeState();
}

class _MoneyVolumeState extends State<MoneyVolumeScreen> {
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
          token: widget.token,
          userData: widget.userData,
          repository: widget.repository,
          cartOrderItemsCount: 0,),
      appBar: CustomAppBar(
          title: "Продажи",
          favoriteIcon: null,
          cartOrderItemsCount: 0,
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
            _buildTotalSalesTodayContainer(),
            SizedBox(height: 24,),
            _buildMonthlyRevenue(),
            SizedBox(height: 24,),
            _buildWeeklyRevenue(),
            SizedBox(height: 24,),
            _buildDailyRevenue(),
            SizedBox(height: 24,),
            _buildMostSellingMonth(),
            SizedBox(height: 24,),

            _buildNetIncome(),
            SizedBox(height: 24,),
            _buildMarginPercentage(),
            SizedBox(height: 24,),
            _buildYearToYearRevenueGrowth(),
            SizedBox(height: 24,),
            _buildMonthToMonthRevenueGrowth()
          ],
        ),
      ));

  Widget _buildTotalSalesTodayContainer() {
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
                      Icons.price_change_outlined,
                      size: 28,
                      color: Color.fromRGBO(58, 67, 59, 0.8),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Годовой оборот",
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
                    "Данная секция представляет вам свежую информацию по денежному обороту в компании. Текущая смета за год составляет 136,420,424 KZT",
                    style: TextStyle(
                        color: Color.fromRGBO(0, 24, 51, 1),
                        fontFamily: 'SolomonSans-SemiBold',
                        fontSize: 16)),
              ],
            ),
          ),
        ));
  }


  Widget _buildMonthlyRevenue() {
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
            Text("14,000,000 KZT",
                style: TextStyle(
                    color: PRIMARY_DARK_COLOR,
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 20)),
            Text("Продажи за месяц",
                style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 12))
          ],
        )
      ],
    );
  }

  Widget _buildWeeklyRevenue() {
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
            Text("36,000,000 KZT",
                style: TextStyle(
                    color: PRIMARY_DARK_COLOR,
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 20)),
            Text("Продажи за неделю",
                style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 12))
          ],
        )
      ],
    );
  }

  Widget _buildDailyRevenue() {
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
            Text("5,000,039 KZT",
                style: TextStyle(
                    color: PRIMARY_DARK_COLOR,
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 20)),
            Text("Продажи за день",
                style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 12))
          ],
        )
      ],
    );
  }

  Widget _buildMostSellingMonth() {
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
            Text("19,000,000 KZT - Декабрь",
                style: TextStyle(
                    color: PRIMARY_DARK_COLOR,
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 20)),
            Text("Самый продающийся месяц",
                style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 12))
          ],
        )
      ],
    );
  }

  Widget _buildNetIncome() {
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
            Text("7,435,000 KZT",
                style: TextStyle(
                    color: PRIMARY_DARK_COLOR,
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 20)),
            Text("Чистая месячная выручка",
                style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 12))
          ],
        )
      ],
    );
  }

  Widget _buildMarginPercentage() {
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
            Text("49%",
                style: TextStyle(
                    color: PRIMARY_DARK_COLOR,
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 20)),
            Text("Маржинальность",
                style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 12))
          ],
        )
      ],
    );
  }

  Widget _buildYearToYearRevenueGrowth() {
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
            Text("294%",
                style: TextStyle(
                    color: PRIMARY_DARK_COLOR,
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 20)),
            Text("Рост выручки год к году",
                style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 12))
          ],
        )
      ],
    );
  }

  Widget _buildMonthToMonthRevenueGrowth() {
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
            Text("39%",
                style: TextStyle(
                    color: PRIMARY_DARK_COLOR,
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 20)),
            Text("Рост выручки месяц к месяцу",
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
