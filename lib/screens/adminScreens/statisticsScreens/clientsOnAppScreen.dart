import 'package:flutter/material.dart';
import 'package:rosemary/constants/colors.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/utils/widgets/custom_app_bar.dart';

import '../../../navigation_drawer_widget.dart';

class ClientsOnAppScreen extends StatefulWidget {
  final String? token;
  final User? userData;
  final Repository repository;

  const ClientsOnAppScreen(
      {Key? key,
      required this.token,
      required this.userData,
      required this.repository})
      : super(key: key);
  @override
  _ClientsOnAppScreenState createState() => _ClientsOnAppScreenState();
}

class _ClientsOnAppScreenState extends State<ClientsOnAppScreen> {
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
        cartOrderItemsCount: 0,
          ),
      appBar: CustomAppBar(
          title: "Пользователи на приложении",
          favoriteIcon: null,
          shoppingCartIcon: null,
          settingsIcon: null,
          cartOrderItemsCount: 0,
          adminPanel: null,
          token: widget.token,
          userData: widget.userData,
          repository: widget.repository),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView(
          children: [
            _buildTotalUsersOnApp(),
            SizedBox(height: 24,),
            _buildTotalActiveUsers(),
            SizedBox(height: 24,),
            _buildWhereTheMostUsersAre(),
            SizedBox(height: 24,),
            _buildActiveUsersGrowthWeekly(),
            SizedBox(height: 24,),
            SizedBox(height: 24,),
          ],
        ),
      ));

 Widget _buildTotalUsersOnApp() {
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
                      Icons.person_outlined,
                      size: 28,
                      color: Color.fromRGBO(58, 67, 59, 0.8),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Общее кол-во юзеров на приложении",
                        style: TextStyle(
                            color: Color.fromRGBO(58, 67, 59, 0.8),
                            fontFamily: 'Merriweather-Regular',
                            fontSize: 12))
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                    "Данная секция представляет вам свежую информацию по всем клиентам на приложении. Текущее кол-во клиентов на приложении составляет 4340 штук",
                    style: TextStyle(
                        color: Color.fromRGBO(0, 24, 51, 1),
                        fontFamily: 'SolomonSans-SemiBold',
                        fontSize: 16)),
              ],
            ),
          ),
        ));
  }

  Widget _buildTotalActiveUsers() {
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
            Text("370 штук",
                style: TextStyle(
                    color: Color.fromRGBO(0, 24, 51, 1),
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 20)),
            Text("Кол-во активных клиентов",
                style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 12))
          ],
        )
      ],
    );
  }

  Widget _buildWhereTheMostUsersAre() {
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
            Text("Алматы",
                style: TextStyle(
                    color: Color.fromRGBO(0, 24, 51, 1),
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 20)),
            Text("Наибольшее кол-во клиентов от",
                style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 12))
          ],
        )
      ],
    );
  }

  Widget _buildActiveUsersGrowthWeekly() {
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
            Text("10%",
                style: TextStyle(
                    color: Color.fromRGBO(0, 24, 51, 1),
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 20)),
            Text("Рост активных клиентов неделя к неделе",
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