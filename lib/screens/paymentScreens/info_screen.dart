import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosemary/cubit/info_cubit.dart';
import 'package:rosemary/cubit/registration_screen_cubit.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/utils/validators/info_forms_validator.dart';

import 'package:rosemary/utils/widgets/custom_app_bar.dart';
import 'package:rosemary/utils/text_form_field.dart';
import 'package:rosemary/utils/text_form_field_post.dart';
import 'package:rosemary/utils/text_form_phone_field.dart';
import 'package:rosemary/utils/widgets/custom_text_field_form.dart';
import '../../navigation_drawer_widget.dart';

import 'package:sizer/sizer.dart';


class InfoScreen extends StatefulWidget {
  final String? token;
  final User? userData;
  final Repository repository;

  final int? cartOrderItemsCount;

  const InfoScreen(
      {Key? key,
      required this.token,
      required this.userData,
      required this.repository,
      required this.cartOrderItemsCount})
      : super(key: key);
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  var inputTextEmail = "";
  var inputTextFirstName = "";
  var inputTextLastName = "";
  var inputTextPhoneNumberPrefix = "";
  var inputTextPhoneNumber = "";

  var _controllerEmail = TextEditingController();
  var _controllerFirstName = TextEditingController();
  var _controllerLastName = TextEditingController();
  var _controllerPhoneNumberPrefix = TextEditingController();
  var _controllerPhoneNumber = TextEditingController();

  final GlobalKey<FormState> _infoFormKey = GlobalKey<FormState>();

  late InfoCubit _infoScreenCubit;

  @override
  void initState() {
    super.initState();
    _infoScreenCubit = BlocProvider.of<InfoCubit>(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      drawer: NavigationDrawerWidget(
          token: widget.token,
          userData: widget.userData,
          repository: widget.repository,
          cartOrderItemsCount: widget.cartOrderItemsCount),
      appBar: CustomAppBar(
          title: "Информация",
          favoriteIcon: null,
          shoppingCartIcon: null,
          cartOrderItemsCount: null,
          settingsIcon: null,
          adminPanel: null,
          token: widget.token,
          userData: widget.userData,
          repository: widget.repository),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView(
          shrinkWrap: true,
          children: [
            // _buildEmailTextField(),
            Form(
                key: _infoFormKey,
                child: Column(children: [
                  CustomTextFieldForm().buildTextFormField(
                      formName: "Email",
                      hint: "Email",
                      controller: _controllerEmail,
                      validator:
                          InfoFormsValidator().validateFieldForEmptySpace,
                      savedContent: widget.userData!.email),
                  CustomTextFieldForm().buildTextFormField(
                      formName: "Имя",
                      hint: "Имя",
                      controller: _controllerFirstName,
                      validator:
                          InfoFormsValidator().validateFieldForEmptySpace,
                      savedContent: widget.userData!.name.split(" ")[0]),
                  CustomTextFieldForm().buildTextFormField(
                      formName: "Фамилия",
                      hint: "Фамилия",
                      controller: _controllerLastName,
                      validator:
                          InfoFormsValidator().validateFieldForEmptySpace,
                      savedContent: widget.userData!.name.split(" ")[1]),
                  CustomTextFieldForm().buildTextFormField(
                      formName: "Телефон",
                      hint: "Телефон",
                      controller: _controllerPhoneNumber,
                      validator:
                          InfoFormsValidator().validateFieldForEmptySpace,
                      savedContent: widget.userData!.phone),
                ])),

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
          onPressed: () {
            if (_infoFormKey.currentState!.validate()) {
              _infoScreenCubit.putInfo(
                  email: _controllerEmail.text,
                  firstName: _controllerFirstName.text,
                  lastName: _controllerLastName.text,
                  phone: _controllerPhoneNumber.text,
                  user: widget.userData,
                  token: widget.token);
            }
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
