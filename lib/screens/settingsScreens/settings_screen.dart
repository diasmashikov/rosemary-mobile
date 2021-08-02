import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rosemary/constants/colors.dart';
import 'package:rosemary/screens/singleScreens/shopping_cart_screen.dart';


import '../../navigation_drawer_widget.dart';
import '../singleScreens/favorites_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  

  // for ios
  double clothImageWidth = 400;
  double clothImageHeight = 380;
  double verticalMargin = 40;

  // for android
  //double productCellWidth = 160;
  //double productCellHeight = 240;
  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          centerTitle: false,
          title: Text("Настройки",
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
            _buildSecuritySection(),
            Divider(color: PRIMARY_DARK_COLOR),
            _buildLanguageSection(),
            Divider(color: PRIMARY_DARK_COLOR),


          ],),
        )
      );

  Widget _buildSecuritySection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Безопасность и приватность",
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Bold',
              fontSize: 20,
            )),
        SizedBox(
          height: 40,
        ),
        Text(
            "Поменять пароль",
            style: TextStyle(
              fontFamily: 'Merriweather-Regular',
              shadows: [
                Shadow(
                    color: PRIMARY_DARK_COLOR,
                    offset: Offset(0, -5))
              ],
              color: Colors.transparent,
              decoration:
              TextDecoration.underline,
              decorationColor: PRIMARY_DARK_COLOR,
              decorationThickness: 2,
              decorationStyle:
              TextDecorationStyle.solid,
            ),
          ),
       
      ]),
    );
  }

   Widget _buildLanguageSection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Язык",
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Bold',
              fontSize: 20,
            )),
        SizedBox(
          height: 40,
        ),
        Text(
            "Русский",
            style: TextStyle(
              fontFamily: 'Merriweather-Regular',
              shadows: [
                Shadow(
                    color: PRIMARY_DARK_COLOR,
                    offset: Offset(0, -5))
              ],
              color: Colors.transparent,
              decoration:
              TextDecoration.underline,
              decorationColor: PRIMARY_DARK_COLOR,
              decorationThickness: 2,
              decorationStyle:
              TextDecorationStyle.solid,
            ),
          ),
       
      ]),
    );
  }


}

