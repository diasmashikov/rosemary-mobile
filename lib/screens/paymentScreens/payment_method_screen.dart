
import 'package:flutter/material.dart';

import 'package:rosemary/utils/custom_app_bar.dart';

import '../../navigation_drawer_widget.dart';

class PaymentMethodScreen extends StatefulWidget {
  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  


  var _controllerEmail = TextEditingController();
  

  @override
  Widget build(BuildContext context) => Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: CustomAppBar(
        title: "Выбор метода оплаты",
        favoriteIcon: Icons.favorite_outline,
        shoppingCartIcon: Icons.shopping_cart_outlined,
        settingsIcon: null,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView(
          children: [
            // _buildEmailTextField(),
            
            _buildSaveBtn(),
          ],
        ),
      ));

  Widget _buildSaveBtn() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 40),
        width: double.infinity,
        height: 50,
        child: OutlinedButton(
          child: Text('Сохранить',
              style: TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(58, 67, 59, 1),
                  fontFamily: 'SolomonSans-SemiBold')),
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            side: BorderSide(width: 1.0, color: Color.fromRGBO(58, 67, 59, 1)),
          ),
        ));
  }

  Widget? hidingIcone(String inputText) {
    if (inputText.length > 0) {
      return Icon(Icons.check, color: Colors.green);
    } else {
      return null;
    }
  }
}
