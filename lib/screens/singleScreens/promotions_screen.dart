
import 'package:flutter/material.dart';
import 'package:rosemary/screens/singleScreens/shopping_cart_screen.dart';


import '../../navigation_drawer_widget.dart';
import 'favorites_screen.dart';

class PromotionsScreen extends StatefulWidget {
  @override
  _PromotionsScreenState createState() => _PromotionsScreenState();
}

class _PromotionsScreenState extends State<PromotionsScreen> {
  

  // for ios
  double clothImageWidth = 400;
  double clothImageHeight = 380;

  // for android
  //double productCellWidth = 160;
  //double productCellHeight = 240;
  @override
  Widget build(BuildContext context) => Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        centerTitle: false,
        title: Text("Акции",
            style: TextStyle(
                color: Color.fromRGBO(58, 67, 59, 1),
                fontFamily: 'Merriweather-Regular')),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_outline,
                color: Color.fromRGBO(58, 67, 59, 1)),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FavoritesScreen(),
              )),
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined,
                color: Color.fromRGBO(58, 67, 59, 1)),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ShoppingCartScreen(),
            )),
          )
        ],
      ),
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ListView(children: [
            _buildPromotionContainer(
                width: double.infinity,
                height: 150,
                firstLine: "коллекция",
                secondLine: "ВЕСНА",
                thirdLine: "скидка до 15%",
                imagePath: "assets/header.jpg",
                activePeriod: "12 августа по 22 августа",
                promotionSlogan: "Встречайте весну уверенно"),
            SizedBox(
              height: 12,
            ),
            _buildPromotionContainer(
                firstLine: "рассрочка с",
                secondLine: "KASPI BANK",
                thirdLine: "на все товары до 3 месяцев",
                width: double.infinity,
                height: 150,
                imagePath: "assets/goods_images/product6.jpg",
                activePeriod: "13 августа по 1 сентября",
                promotionSlogan: "Малое это нечто большее"),
            SizedBox(
              height: 12,
            ),
            _buildPromotionContainer(
                firstLine: "получи бонус в размере",
                secondLine: "10%",
                thirdLine: "при покупке платьев",
                width: double.infinity,
                height: 150,
                imagePath: "assets/goods_images/product4.jpg",
                activePeriod: "13 августа по 1 сентября",
                promotionSlogan: "Женственность - прекрасна")
          ])));

  Widget _buildPromotionContainer({
    required double width,
    required double height,
    required String imagePath,
    required String activePeriod,
    required String promotionSlogan,
    required String firstLine,
    required String secondLine,
    required String thirdLine,
  }) {
    return Container(
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
                            fontSize: 16))),
                Center(
                    child: Text(secondLine,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Merriweather-Bold',
                            fontSize: 36))),
                Center(
                    child: Text(thirdLine,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Merriweather-Regular',
                            fontSize: 14))),
              ])
            ]),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(activePeriod,
                      style: TextStyle(
                          color: Color.fromRGBO(58, 67, 59, 0.5),
                          fontFamily: 'Merriweather-Regular',
                          fontSize: 12)),
                  SizedBox(
                    height: 4,
                  ),
                  Text(promotionSlogan,
                      style: TextStyle(
                          color: Color.fromRGBO(58, 67, 59, 1),
                          fontFamily: 'Merriweather-Regular',
                          fontSize: 18)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
