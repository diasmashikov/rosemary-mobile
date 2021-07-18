import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rosemary/screens/shopping_cart_screen.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../navigation_drawer_widget.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  Color _expansionTileTextColor = Color.fromRGBO(58, 67, 59, 1);

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
        title: Text("Контакты",
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
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ListView(
            children: [
              _buildGreetingTitle(),
              Divider(color: Color.fromRGBO(58, 67, 59, 1)),
              _buildPhoneContactSection(),
              Divider(color: Color.fromRGBO(58, 67, 59, 1)),
              _buildSocialMediaSection()
            ],
          )));

  Widget _buildGreetingTitle() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Text("Команда Rosemary всегда рада Вам!",
          style: TextStyle(
            color: Color.fromRGBO(58, 67, 59, 1),
            fontFamily: 'Merriweather-Bold',
            fontSize: 20,
          )),
    );
  }

  Widget _buildPhoneContactSection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text("Позвонить нам: ",
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Bold',
              fontSize: 20,
            )),
        SizedBox(
          height: 20,
        ),
        Text("+77755544433 - г.Алматы",
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Regular',
              fontSize: 16,
            )),
        SizedBox(
          height: 4,
        ),
        Text("+77744232134 - г.Нурсултан",
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Regular',
              fontSize: 16,
            )),
      ]),
    );
  }

  Widget _buildSocialMediaSection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text("Социальные сети: ",
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Bold',
              fontSize: 20,
            )),
        SizedBox(
          height: 20,
        ),
        Link(uri: Uri.parse("https://www.instagram.com/rosemarybrand_/"),
          builder: (context, followLink) {
                return RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Instagram',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontFamily: 'Merriweather-Bold',
                        fontSize: 21,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = followLink,
                    ),
                  ]),
                );}),
       
      
      ]),
    );
  }
}
