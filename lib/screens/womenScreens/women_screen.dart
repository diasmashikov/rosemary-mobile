import 'package:flutter/material.dart';
import 'package:rosemary/screens/shopping_cart_screen.dart';
import 'package:rosemary/screens/womenScreens/women_products_screen.dart';

import '../../navigation_drawer_widget.dart';

class WomenScreen extends StatelessWidget {
  // for ios
  double productCellWidth = 190;
  double productCellHeight = 240;

  // for android
  //double productCellWidth = 160;
  //double productCellHeight = 240;
  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
            centerTitle: false,
            title: Text("Женщины",
                style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular')),
            actions: [
              IconButton(
                icon: Icon(Icons.favorite_outline,
                    color: Color.fromRGBO(58, 67, 59, 1)),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.shopping_cart_outlined,
                    color: Color.fromRGBO(58, 67, 59, 1)),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ShoppingCartScreen(),
              )),
              )
            ]),
        body: GridView.count(
          padding: EdgeInsets.symmetric(vertical: 15),
          mainAxisSpacing: 20,
          crossAxisCount: 2,
          children: [
            _buildWomanClothTypeContainer(
                width: productCellWidth,
                height: productCellHeight,
                imagePath: 'assets/goods_images/product1.jpg',
                clothTypeTitle: 'Платья',
                context: context),
            _buildWomanClothTypeContainer(
                width: productCellWidth,
                height: productCellHeight,
                imagePath: 'assets/goods_images/product2.jpg',
                clothTypeTitle: 'Топики',
                context: context),
            _buildWomanClothTypeContainer(
                width: productCellWidth,
                height: productCellHeight,
                imagePath: 'assets/goods_images/product3.jpg',
                clothTypeTitle: 'Футболки',
                context: context),
            _buildWomanClothTypeContainer(
                width: productCellWidth,
                height: productCellHeight,
                imagePath: 'assets/goods_images/product4.jpg',
                clothTypeTitle: 'Шорты',
                context: context),
            _buildWomanClothTypeContainer(
                width: productCellWidth,
                height: productCellHeight,
                imagePath: 'assets/goods_images/product5.jpg',
                clothTypeTitle: 'Штаны',
                context: context),
            _buildWomanClothTypeContainer(
                width: productCellWidth,
                height: productCellHeight,
                imagePath: 'assets/goods_images/product6.jpg',
                clothTypeTitle: 'Сумки',
                context: context),
            _buildWomanClothTypeContainer(
                width: productCellWidth,
                height: productCellHeight,
                imagePath: 'assets/goods_images/product7.jpg',
                clothTypeTitle: 'Бижутерия',
                context: context),
            _buildWomanClothTypeContainer(
                width: productCellWidth,
                height: productCellHeight,
                imagePath: 'assets/goods_images/product8.jpg',
                clothTypeTitle: 'Шляпы',
                context: context)
          ],
        ),
      );

  Widget _buildWomanClothTypeContainer({
    required double width,
    required double height,
    required String imagePath,
    required String clothTypeTitle,
    required BuildContext context
  }) {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => WomenProductsScreen(),
        )),
      child: Stack(
        alignment: Alignment.center,
        children: [
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
          Center(
              child: Text(clothTypeTitle,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Merriweather-Bold',
                      letterSpacing: 3.0,
                      fontSize: 20))),
        ],
      ),
    );
  }
}
