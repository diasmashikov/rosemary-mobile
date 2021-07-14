import 'package:flutter/material.dart';
import 'package:rosemary/screens/women_product_screen.dart';
import '../navigation_drawer_widget.dart';

class WomenProductsScreen extends StatefulWidget {
  @override
  _WomenProductsState createState() => _WomenProductsState();
}

class _WomenProductsState extends State<WomenProductsScreen> {
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
              onPressed: () {},
            )
          ],
        ),
        body: GridView.count(
          padding: EdgeInsets.symmetric(vertical: 15),
          mainAxisSpacing: 120,
          crossAxisCount: 2,
          children: [
            _buildWomanProductContainer(
                width: productCellWidth,
                height: productCellHeight,
                imagePath: 'assets/goods_images/product1.jpg',
                clothProductName: 'Платье \"Love me\"',
                clothType: 'кожа',
                clothPrice: '10,000 T'),
            _buildWomanProductContainer(
                width: productCellWidth,
                height: productCellHeight,
                imagePath: 'assets/goods_images/product1.jpg',
                clothProductName: 'Платье \"Love me\"',
                clothType: 'кожа',
                clothPrice: '10,000 T')
          ],
        ),
      );

  Widget _buildWomanProductContainer({
    required double width,
    required double height,
    required String imagePath,
    required String clothProductName,
    required String clothType,
    required String clothPrice,
  }) {
    return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //alignment: WrapAlignment.center,
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  Card(
                    color: Colors.transparent,
                    elevation: 5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(imagePath,
                          width: 170, height: height, fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: IconButton(
                      alignment: Alignment.center,
                      icon: Icon(Icons.favorite,
                          size: 30, color: Color.fromRGBO(255, 255, 255, 1)),
                      onPressed: () => {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Сохранено'),
                          duration: const Duration(seconds: 2),
                        ))
                      },
                    ),
                  ),
                ],
              ),
            ),
            Text(clothProductName,
                style: TextStyle(
                  color: Color.fromRGBO(58, 67, 59, 1),
                  fontFamily: 'Merriweather-Regular',
                )),
            Text(clothType,
                style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 0.5),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 12)),
            OutlinedButton(
              child: Text(clothPrice,
                  style: TextStyle(
                      color: Color.fromRGBO(58, 67, 59, 1),
                      fontFamily: 'SolomonSans-SemiBold')),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => WomenProductScreen(),
              )),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                    width: 1.0, color: Color.fromRGBO(58, 67, 59, 1)),
              ),
            ),
          ],
        ));
  }
}
