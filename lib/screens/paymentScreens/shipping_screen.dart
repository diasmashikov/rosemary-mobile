
import 'package:flutter/material.dart';

import 'package:rosemary/utils/custom_app_bar.dart';
import 'package:rosemary/utils/text_form_field.dart';

import '../../navigation_drawer_widget.dart';

class ShippingAddressScreen extends StatefulWidget {
  @override
  _ShippingAddressState createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddressScreen> {
  var inputTextFirstName = "";
  var inputTextLastName = "";
  var inputTextCountry = "";
  var inputTextRegion = "";
  var inputTextCity = "";
  var inputTextZipCode = "";
  var inputTextAddress = "";




  
  var _controllerFirstName = TextEditingController();
  var _controllerLastName = TextEditingController();
  var _controllerCountry  = TextEditingController();
  var _controllerRegion = TextEditingController();
  var _controllerCity = TextEditingController();
  var _controllerZipCode = TextEditingController();
  var _controllerAddress = TextEditingController();


  @override
  Widget build(BuildContext context) => Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: CustomAppBar(
        title: "Адрес доставки",
        favoriteIcon: Icons.favorite_outline,
        shoppingCartIcon: Icons.shopping_cart_outlined,
        settingsIcon: null,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView(
          children: [
            // _buildEmailTextField(),
            AppTextFormField(
                formName: "Имя",
                hintName: "Имя",
                controller: _controllerFirstName,
                inputText: inputTextFirstName),
            AppTextFormField(
                formName: "Фамилия",
                hintName: "Фамилия",
                controller: _controllerLastName,
                inputText: inputTextLastName),
            AppTextFormField(
              formName: "Страна",
              hintName: "Страна",
              controller: _controllerCountry,
              inputText: inputTextCountry
            ),
            AppTextFormField(
              formName: "Область",
              hintName: "Область",
              controller: _controllerRegion,
              inputText: inputTextRegion
            ),
            AppTextFormField(
              formName: "Город",
              hintName: "Город",
              controller: _controllerCity,
              inputText: inputTextCity
            ),
            AppTextFormField(
              formName: "Код",
              hintName: "Код",
              controller: _controllerZipCode,
              inputText: inputTextZipCode
            ),
            AppTextFormField(
              formName: "Адрес",
              hintName: "Адрес",
              controller: _controllerAddress,
              inputText: inputTextAddress
            ),
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
