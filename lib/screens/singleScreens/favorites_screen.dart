import 'package:flutter/material.dart';
import 'package:rosemary/constants/colors.dart';
import 'package:rosemary/screens/singleScreens/shopping_cart_screen.dart';
import 'package:rosemary/screens/womenScreens/women_product_screen.dart';
import '../../navigation_drawer_widget.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<FavoritesScreen> {
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
          title: Text("Желаемые",
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
          ],
        ),
        body: GridView.count(
          shrinkWrap: true,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 1.5),
          padding: EdgeInsets.symmetric(vertical: 15),
          mainAxisSpacing: 20,
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
                imagePath: 'assets/goods_images/product2.jpg',
                clothProductName: 'Платье \"Justin\"',
                clothType: 'ткань',
                clothPrice: '17,000 T'),
            _buildWomanProductContainer(
                width: productCellWidth,
                height: productCellHeight,
                imagePath: 'assets/goods_images/product3.jpg',
                clothProductName: 'Платье \"Elmira\"',
                clothType: 'эластин',
                clothPrice: '13,000 T'),
            _buildWomanProductContainer(
                width: productCellWidth,
                height: productCellHeight,
                imagePath: 'assets/goods_images/product4.jpg',
                clothProductName: 'Платье \"Gulmira\"',
                clothType: 'ткань',
                clothPrice: '21,000 T'),
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
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => WomenProductScreen(),
      )),
      child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //alignment: WrapAlignment.center,
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      color: Colors.transparent,
                      child:
                          Image.asset(imagePath, width: 190, fit: BoxFit.cover),
                    ),
                    Positioned(
                      right: 5,
                      bottom: 5,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20,
                        child: IconButton(
                          alignment: Alignment.center,
                          icon: Icon(Icons.delete_outline,
                              size: 20, color: PRIMARY_DARK_COLOR),
                          onPressed: () => {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Сохранено'),
                              duration: const Duration(seconds: 2),
                            ))
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
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
          )),
    );
  }
}
