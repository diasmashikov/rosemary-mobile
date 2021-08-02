import 'package:flutter/material.dart';
import 'package:rosemary/screens/singleScreens/shopping_cart_screen.dart';
import '../navigation_drawer_widget.dart';
import 'singleScreens/favorites_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          centerTitle: false,
          title: Text("Rosemary",
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
        body: ListView(children: <Widget>[
          const SizedBox(
            height: 24,
          ),
          _buildBannerContainer(width: double.infinity, height: 150.0)
        ]),
      );

  Widget _buildBannerContainer({
    required double width,
    required double height,
  }) {
    return Stack(children: <Widget>[
      Container(
        alignment: Alignment.center,
        height: height,
        width: width,
        child: Image.asset(
          'assets/header.jpg',
          height: height,
          width: width,
          fit: BoxFit.cover,
        ),
      ),
      Column(children: <Widget>[
        SizedBox(
          height: height/4,
        ),
        Center(
            child: Text("коллекция",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 16))),
        Center(
            child: Text("ВЕСНА",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Merriweather-Bold',
                    fontSize: 36))),
        Center(
            child: Text("скидки до 15%",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 14))),
                    

      ])
    ]);
  }
}
