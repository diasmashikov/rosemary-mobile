import 'package:flutter/material.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/utils/widgets/custom_app_bar.dart';

import '../../../navigation_drawer_widget.dart';

class NumberOfProductsScreen extends StatefulWidget {
  final String? token;
  final User? userData;
  final Repository repository;

  const NumberOfProductsScreen(
      {Key? key,
      required this.token,
      required this.userData,
      required this.repository})
      : super(key: key);
  @override
  _NumberOfProductsState createState() => _NumberOfProductsState();
}

class _NumberOfProductsState extends State<NumberOfProductsScreen> {
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
          title: "Кол-во товара",
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
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 3),
              children: [
                _buildTotalSalesTodayContainer(),
                _buildTotalOrdersTodayContainer(),
                _buildTheMostSellableProduct(),
                _buildTheMostBuyingStreet(),
                _buildCustomersCount(),
                _buildProductsValue(),
                _buildProductsTotalCount()
              ],
            ),
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Icon(
                    Icons.price_change_outlined,
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Продажи",
                      style: TextStyle(
                          color: Color.fromRGBO(58, 67, 59, 0.8),
                          fontFamily: 'Merriweather-Regular',
                          fontSize: 12))
                ],
              ),
              SizedBox(height: 12,),
              Text("5,000,423 T",
                        style: TextStyle(
                            color: Color.fromRGBO(0, 24, 51, 1),
                            fontFamily: 'SolomonSans-SemiBold',
                            fontSize: 24)),
              
              
              

              
            ],
            
            ),
          ),
        ));
  }

  Widget _buildTotalOrdersTodayContainer() {
    return InkWell(
      onTap: () {},
      child: Card(
        child: Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Icon(
                    Icons.price_change_outlined,
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Кол-во заказов",
                      style: TextStyle(
                          color: Color.fromRGBO(58, 67, 59, 0.8),
                          fontFamily: 'Merriweather-Regular',
                          fontSize: 12))
                ],
              ),
              SizedBox(height: 12,),
              Text("314 штук",
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

  Widget _buildTheMostSellableProduct() {
    return InkWell(
      onTap: () {},
      child: Card(
        child: Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Icon(
                    Icons.fireplace_outlined,
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Раскупающийся",
                      style: TextStyle(
                          color: Color.fromRGBO(58, 67, 59, 0.8),
                          fontFamily: 'Merriweather-Regular',
                          fontSize: 12))
                ],
              ),
              SizedBox(height: 12,),
              Text("Носки Гуми",
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

  Widget _buildTheMostBuyingStreet() {
    return InkWell(
      onTap: () {},
      child: Card(
        child: Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              SizedBox(height: 12,),
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

  Widget _buildCustomersCount() {
    return InkWell(
      onTap: () {},
      child: Card(
        child: Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Icon(
                    Icons.person_outlined,
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Пользователей",
                      style: TextStyle(
                          color: Color.fromRGBO(58, 67, 59, 0.8),
                          fontFamily: 'Merriweather-Regular',
                          fontSize: 12))
                ],
              ),
              SizedBox(height: 12,),
              Text("1024",
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

  Widget _buildProductsValue() {
    return InkWell(
      onTap: () {},
      child: Card(
        child: Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Icon(
                    Icons.museum_outlined,
                    color: Color.fromRGBO(58, 67, 59, 0.8),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Ценность товаров",
                      style: TextStyle(
                          color: Color.fromRGBO(58, 67, 59, 0.8),
                          fontFamily: 'Merriweather-Regular',
                          fontSize: 10))
                ],
              ),
              SizedBox(height: 12,),
              Text("124,000,000 Т",
                        style: TextStyle(
                            color: Color.fromRGBO(0, 24, 51, 1),
                            fontFamily: 'SolomonSans-SemiBold',
                            fontSize: 20)),
            ],
            
            ),
        ),
      ),
    );
  }

  Widget _buildProductsTotalCount() {
    return InkWell(
      onTap: () {},
      child: Card(
        child: Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              SizedBox(height: 12,),
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