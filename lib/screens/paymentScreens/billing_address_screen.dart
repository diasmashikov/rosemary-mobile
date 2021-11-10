
import 'package:flutter/material.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';

import 'package:rosemary/utils/widgets/custom_app_bar.dart';
import 'package:rosemary/utils/text_form_field.dart';

import '../../navigation_drawer_widget.dart';

class BillingAddressScreen extends StatefulWidget {
  final String? token;
  final User? userData;
  final Repository repository;

  final int? cartOrderItemsCount;

  const BillingAddressScreen({Key? key, required this.token, required this.userData, required this.repository, required this.cartOrderItemsCount}) : super(key: key);
  @override
  _BillingAddressState createState() => _BillingAddressState();
}

class _BillingAddressState extends State<BillingAddressScreen> {
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
      drawer: NavigationDrawerWidget(token: widget.token,
            userData: widget.userData,
            repository: widget.repository,
        cartOrderItemsCount: widget.cartOrderItemsCount
            ),
      appBar: CustomAppBar(
        title: "Платежный адрес",
        favoriteIcon: Icons.favorite_outline,
        shoppingCartIcon: Icons.shopping_cart_outlined,
        cartOrderItemsCount: widget.cartOrderItemsCount,

        settingsIcon: null,
          adminPanel: (widget.userData!.isAdmin != true) ?  null : Icons.admin_panel_settings_outlined,

        token: widget.token,
            userData: widget.userData,
            repository: widget.repository
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
