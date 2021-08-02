import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rosemary/screens/singleScreens/shopping_cart_screen.dart';
import 'package:url_launcher/link.dart';

import '../../navigation_drawer_widget.dart';
import 'favorites_screen.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  

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
        title: Text("Контакты",
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
          margin: EdgeInsets.only(right: 20, left: 20, bottom: verticalMargin, top: 20),
          child: ListView(
            children: [
              _buildGreetingTitle(),
              Divider(color: Color.fromRGBO(58, 67, 59, 1)),
              _buildPhoneContactSection(),
              Divider(color: Color.fromRGBO(58, 67, 59, 1)),
              _buildSocialMediaSection(),
              Divider(color: Color.fromRGBO(58, 67, 59, 1)),
              _buildOpeninsHours(),
            ],
          )));

  Widget _buildGreetingTitle() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: verticalMargin),
      child: Text("Команда Rosemary всегда рада Вам!",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromRGBO(58, 67, 59, 1),
            fontFamily: 'Merriweather-Bold',
            fontSize: 30,
          )),
    );
  }

  Widget _buildPhoneContactSection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: verticalMargin),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text("Позвонить нам: ",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Bold',
              fontSize: 20,
            )),
        SizedBox(
          height: 20,
        ),
        Text("+77755544433 - г.Алматы",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'SolomonSans-SemiBold',
              fontSize: 16,
            )),
        SizedBox(
          height: 4,
        ),
        Text("+77744232134 - г.Нурсултан",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'SolomonSans-SemiBold',
              fontSize: 16,
            )),
      ]),
    );
  }

  Widget _buildSocialMediaSection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: verticalMargin),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text("Социальные сети: ",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Bold',
              fontSize: 20,
            )),
        SizedBox(
          height: 20,
        ),
        Link(
            uri: Uri.parse("https://www.instagram.com/rosemarybrand_/"),
            builder: (context, followLink) {
              return RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Instagram',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontFamily: 'Merriweather-Bold',
                      fontSize: 21,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = followLink,
                  ),
                ]),
              );
            }),
      ]),
    );
  }

  Widget _buildOpeninsHours() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: verticalMargin),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text("Часы работы: ",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(58, 67, 59, 1),
                fontFamily: 'Merriweather-Bold',
                fontSize: 20,
              )),
          SizedBox(
            height: 20,
          ),
          Text(
              "Вы можете обратиться к нам по социальным сетям или телефонным связям 24/7",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(58, 67, 59, 1),
                fontFamily: 'Merriweather-Regular',
                fontSize: 16,
              )),
        ]));
  }
}
