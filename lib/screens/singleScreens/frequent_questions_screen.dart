
import 'package:flutter/material.dart';
import 'package:rosemary/screens/singleScreens/shopping_cart_screen.dart';

import '../../navigation_drawer_widget.dart';
import 'favorites_screen.dart';

class FrequentQuestionsScreen extends StatefulWidget {
  @override
  _FrequentQuestionsState createState() => _FrequentQuestionsState();
}

class _FrequentQuestionsState extends State<FrequentQuestionsScreen> {
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
        title: Text("Частые вопросы",
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
            _buildExpansionTile(
              title: "Где находятся ваши магазины?",
            description: "На данный момент Rosemary не оперирует физически, мы предоставляем онлайн доставку"),
            Divider(color: Color.fromRGBO(58, 67, 59, 1)),
            _buildExpansionTile(
              title: "Как мне измерить одежду под себя?",
            description: "Берете ленточку и мерите! Что тут сложного!"),
            Divider(color: Color.fromRGBO(58, 67, 59, 1)),
            _buildExpansionTile(
              title: "У вас бесплатная доставка по Алматы?",
            description: "Я разработчик, Я не знаю, спросите у Гуми с Эми"),
            Divider(color: Color.fromRGBO(58, 67, 59, 1)),
            _buildExpansionTile(
              title: "Вы предоставляете услугу стилиста?",
            description: "Вроде"),
            Divider(color: Color.fromRGBO(58, 67, 59, 1)),
           
          ]
            
          )));

    Widget _buildExpansionTile({required String title, required String description}) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
          tilePadding: EdgeInsets.all(0),
          onExpansionChanged: (expanded) {
            setState(() {
              if (expanded) {
                _expansionTileTextColor = Color.fromRGBO(58, 67, 59, 1);
              } else {
                _expansionTileTextColor = Color.fromRGBO(58, 67, 59, 1);
              }
            });
          },
          iconColor: _expansionTileTextColor,
          title: Text(
            title,
            style: TextStyle(
                color: _expansionTileTextColor,
                fontFamily: 'Merriweather-Bold',
                fontSize: 16),
          ),
          children: <Widget>[
            ListTile(
                title: Text(
              description,
              style: TextStyle(
                  color: _expansionTileTextColor,
                  fontFamily: 'Merriweather-Regular',
                  fontSize: 16),
            ))
          ]),
    );
  }
}
