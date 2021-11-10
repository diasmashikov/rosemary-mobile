import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosemary/cubit/shipping_address_cubit.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';

import 'package:rosemary/utils/widgets/custom_app_bar.dart';
import 'package:rosemary/utils/text_form_field.dart';
import 'package:rosemary/utils/text_form_field_post.dart';

import '../../navigation_drawer_widget.dart';

class ShippingAddressScreen extends StatefulWidget {
  final int? cartOrderItemsCount;

  const ShippingAddressScreen(
      {Key? key,
      required this.token,
      required this.userData,
      required this.repository,
      required this.cartOrderItemsCount})
      : super(key: key);

  @override
  _ShippingAddressState createState() => _ShippingAddressState();
  final String? token;
  final User? userData;
  final Repository repository;
}

class _ShippingAddressState extends State<ShippingAddressScreen> {
  var inputTextFirstName = "";
  var inputTextLastName = "";
  var inputTextCountry = "";
  var inputTextRegion = "";
  var inputTextCity = "";
  var inputTextZipCode = "";
  var inputTextAddress = "";
  var inputTextHomeNumber = "";

  var _controllerFirstName = TextEditingController();
  var _controllerLastName = TextEditingController();
  var _controllerCountry = TextEditingController();
  var _controllerRegion = TextEditingController();
  var _controllerCity = TextEditingController();
  var _controllerZipCode = TextEditingController();
  var _controllerAddress = TextEditingController();
  var _controllerHomeNumber = TextEditingController();

  late ShippingAddressCubit _shippingAddressCubit;

  @override
  void initState() {
    super.initState();
    _shippingAddressCubit = BlocProvider.of<ShippingAddressCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userData!.country == "temporary") {
      _controllerCountry.text = "";
    } else {
      _controllerCountry.text = widget.userData!.country;
    }

    if (widget.userData!.region == "temporary") {
      _controllerRegion.text = "";
    } else {
      _controllerRegion.text = widget.userData!.region;
    }
    if (widget.userData!.city == "temporary") {
      _controllerCity.text = "";
    } else {
      _controllerCity.text = widget.userData!.city;
    }
    if (widget.userData!.zip == "temporary") {
      _controllerZipCode.text = "";
    } else {
      _controllerZipCode.text = widget.userData!.zip;
    }
    if (widget.userData!.street == "temporary") {
      _controllerAddress.text = "";
    } else {
      _controllerAddress.text = widget.userData!.street;
    }
    if (widget.userData!.homeNumber == "temporary") {
      _controllerHomeNumber.text = "";
    } else {
      _controllerHomeNumber.text = widget.userData!.homeNumber;
    }

    return Scaffold(
        drawer: NavigationDrawerWidget(
            token: widget.token,
            userData: widget.userData,
            repository: widget.repository,
            cartOrderItemsCount: widget.cartOrderItemsCount),
        appBar: CustomAppBar(
            title: "Адрес доставки",
            favoriteIcon: Icons.favorite_outline,
            shoppingCartIcon: Icons.shopping_cart_outlined,
            cartOrderItemsCount: widget.cartOrderItemsCount,
            settingsIcon: null,
            adminPanel: (widget.userData!.isAdmin != true)
                ? null
                : Icons.admin_panel_settings_outlined,
            token: widget.token,
            userData: widget.userData,
            repository: widget.repository),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ListView(
            children: [
              // _buildEmailTextField(),
              AppTextFormFieldPost(
                  formName: "Страна",
                  controller: _controllerCountry,
                  minLin: 1,
                  maxLin: 5,
                  content: _controllerCountry.text,
                   hint:"Страна",
                          validator: () {},),
              AppTextFormFieldPost(
                  formName: "Область",
                  controller: _controllerRegion,
                  minLin: 1,
                  maxLin: 5,
                  content: _controllerRegion.text,
                   hint: "Область",
                          validator: () {},),
              AppTextFormFieldPost(
                  formName: "Город",
                  controller: _controllerCity,
                  minLin: 1,
                  maxLin: 5,
                  content: _controllerCity.text,
                   hint: "Город",
                          validator: () {},),
              AppTextFormFieldPost(
                  formName: "Код",
                  controller: _controllerZipCode,
                  minLin: 1,
                  maxLin: 5,
                  content: _controllerZipCode.text,
                   hint: "Код",
                          validator: () {},),
              AppTextFormFieldPost(
                  formName: "Адрес",
                  controller: _controllerAddress,
                  minLin: 1,
                  maxLin: 5,
                  content: _controllerAddress.text,
                   hint: "Адрес",
                          validator: () {},),
              AppTextFormFieldPost(
                  formName: "Номер дома/квартиры",
                  controller: _controllerHomeNumber,
                  minLin: 1,
                  maxLin: 5,
                  content: _controllerHomeNumber.text,
                   hint: "Номер дома/квартиры",
                          validator: () {},),

              _buildSaveBtn(),
            ],
          ),
        ));
  }

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
          onPressed: () {
            _shippingAddressCubit
                .postShippingAddress(
                    country: _controllerCountry.text,
                    region: _controllerRegion.text,
                    city: _controllerCity.text,
                    zip: _controllerZipCode.text,
                    address: _controllerAddress.text,
                    homeNumber: _controllerHomeNumber.text,
                    user: widget.userData,
                    token: widget.token)
                .then((_) {
              widget.userData!.country = _controllerCountry.text;
              widget.userData!.region = _controllerRegion.text;
              widget.userData!.city = _controllerCity.text;
              widget.userData!.zip = _controllerZipCode.text;
              widget.userData!.street = _controllerAddress.text;
              widget.userData!.homeNumber = _controllerHomeNumber.text;
              
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Адрес обновлен'),
                duration: const Duration(seconds: 2),
              ));
              
            });
          },
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
