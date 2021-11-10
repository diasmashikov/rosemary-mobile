import 'package:flutter/material.dart';
import 'package:rosemary/constants/colors.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/utils/widgets/custom_app_bar.dart';

import '../../../navigation_drawer_widget.dart';

class ProductsValueScreen extends StatefulWidget {
  final String? token;
  final User? userData;
  final Repository repository;

  const ProductsValueScreen(
      {Key? key,
      required this.token,
      required this.userData,
      required this.repository})
      : super(key: key);
  @override
  _ProductsValueState createState() => _ProductsValueState();
}

class _ProductsValueState extends State<ProductsValueScreen> {
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
          title: "Ценность товаров",
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
            _buildTotalProductsValue(),
            SizedBox(height: 24,),
            _buildTheMostValueProduct("Платье Чарламэйн", "Платье", "1", "57,000,000 KZT", "39,000 единиц"),
            SizedBox(height: 24,),
            _buildTheMostValueProduct("Штаны Дебрасио", "Штаны", "2", "37,000,000 KZT", "18,000 единиц"),
            SizedBox(height: 24,),
            _buildTheMostValueProduct("Платье Балбало", "Платье", "3", "49,000,000 KZT", "7,000 единиц"),
            SizedBox(height: 24,),
            _buildTheMostValueProduct("Шапо", "Шляпы", "4", "23,000,000 KZT", "1,000 единиц"),
            SizedBox(height: 24,),
            _buildTheMostValueProduct("Платье Чарламэйн", "Платье", "5", "12,000,000 KZT", "400 единиц")
          ],
        ),
      ));

  Widget _buildTotalProductsValue() {
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
                    Text("Ценность всего товара",
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
                    "Данная секция представляет вам свежую информацию по валовой стоимости товаров. Текущая ценность всего товара составляет 124,000,000 KZT",
                    style: TextStyle(
                        color: Color.fromRGBO(0, 24, 51, 1),
                        fontFamily: 'SolomonSans-SemiBold',
                        fontSize: 16)),
              ],
            ),
          ),
        ));
  }


  Widget _buildTheMostValueProduct(name, category, place, totalValue, quantity) {
    return Row(
      children: [
        CircleAvatar(
                        backgroundColor: PRIMARY_DARK_COLOR,
                        radius: 20,
                        child: Text(place,
                style: TextStyle(
                    color: WHITE_COLOR,
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 20)),
                      ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style: TextStyle(
                    color: Color.fromRGBO(0, 24, 51, 1),
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 20)),
            Text(category,
                style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 12))
          ],
        ),
        Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(totalValue,
                style: TextStyle(
                    color: Color.fromRGBO(0, 24, 51, 1),
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 14)),
            Text(quantity,
            textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 12))
          ]),
      ],
    );
  }

  
}
