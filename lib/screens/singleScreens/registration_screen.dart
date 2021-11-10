import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosemary/constants/responsive_ui.dart';
import 'package:rosemary/cubit/login_cubit.dart';
import 'package:rosemary/cubit/registration_screen_cubit.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/utils/validators/registration_forms_validator.dart';

import 'package:rosemary/utils/widgets/custom_app_bar.dart';
import 'package:rosemary/utils/text_form_field.dart';
import 'package:rosemary/utils/text_form_field_password.dart';
import 'package:rosemary/utils/text_form_phone_field.dart';
import 'package:rosemary/utils/widgets/custom_text_field_form.dart';
import '../../navigation_drawer_widget.dart';
import 'login_screen.dart';
import 'package:sizer/sizer.dart';

class RegistrationScreen extends StatefulWidget {
  final String? token;
  final User? userData;
  final Repository repository;

  final int? cartOrderItemsCount;

  const RegistrationScreen(
      {Key? key,
      required this.token,
      required this.userData,
      required this.repository,
      required this.cartOrderItemsCount})
      : super(key: key);
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  var inputTextEmail = "";
  var inputTextFirstName = "";
  var inputTextLastName = "";
  var inputTextPhoneNumberPrefix = "";
  var inputTextPhoneNumber = "";
  var inputTextPassword = "";

  var _controllerEmail = TextEditingController();
  var _controllerFirstName = TextEditingController();
  var _controllerLastName = TextEditingController();
  var _controllerPhoneNumberPrefix = TextEditingController();
  var _controllerPhoneNumber = TextEditingController();
  var _controllerPassword = TextEditingController();

  final GlobalKey<FormState> _registrationFormKey = GlobalKey<FormState>();

  late RegistrationScreenCubit _registrationScreenCubit;

  @override
  void initState() {
    super.initState();
    _registrationScreenCubit =
        BlocProvider.of<RegistrationScreenCubit>(context);
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
        margin: EdgeInsets.symmetric(
            horizontal: APP_SCREEN_CONTENT_PADDING_H_WIDTH,
            vertical: APP_SCREEN_CONTENT_PADDING_V_WIDTH),
        child: ListView(
          shrinkWrap: true,
          children: [
            Form(
                key: _registrationFormKey,
                child: Column(children: [
                  CustomTextFieldForm().buildTextFormField(
                      formName: "Email",
                      hint: "dias@mail.com",
                      controller: _controllerEmail,
                      validator: RegistrationFormsValidator().validateEmail),
                  CustomTextFieldForm().buildTextFormField(
                      formName: "Имя",
                      hint: "Имя",
                      controller: _controllerFirstName,
                      validator: RegistrationFormsValidator()
                          .validateFieldForEmptySpace),
                  CustomTextFieldForm().buildTextFormField(
                      formName: "Фамилия",
                      hint: "Фамилия",
                      controller: _controllerLastName,
                      validator: RegistrationFormsValidator()
                          .validateFieldForEmptySpace),
                  CustomTextFieldForm().buildPhoneTextFormField(
                      formName: "Телефон",
                  
                      hint: "+77744433335",
                     
                      controllerBody: _controllerPhoneNumber,
                      controllerPrefix: _controllerPhoneNumberPrefix,
                      validator: RegistrationFormsValidator()
                          .validateFieldForEmptySpace),
                  CustomTextFieldForm().buildTextFormField(
                      formName: "Пароль",
                      hint: "Пароль",
                      obscure: true,
                      controller: _controllerPassword,
                      validator: RegistrationFormsValidator().validatePassword),
                ])),
            _buildSaveBtn(),
          ],
        ),
      ));

  Widget _buildSaveBtn() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 3.h),
        width: double.infinity,
        height: 7.h,
        child: OutlinedButton(
          child: Text('Зарегистрироваться',
              style: TextStyle(
                  fontSize: 11.5.sp,
                  color: Color.fromRGBO(58, 67, 59, 1),
                  fontFamily: 'SolomonSans-SemiBold')),
          onPressed: () {
            if (_registrationFormKey.currentState!.validate()) {
              _registrationScreenCubit
                  .registerUser(
                      email: _controllerEmail.text,
                      firstName: _controllerFirstName.text,
                      lastName: _controllerLastName.text,
                      phoneNumberPrefix: _controllerPhoneNumberPrefix.text,
                      phoneNumber: _controllerPhoneNumber.text,
                      password: _controllerPassword.text)
                  .then((_) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Теперь вы часть Rosemary!'),
                  duration: const Duration(seconds: 1),
                ));
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) =>
                        LoginCubit(repository: widget.repository),
                    child: LoginScreen(repository: widget.repository),
                  ),
                ));
              });
            }
          },
          style: OutlinedButton.styleFrom(
            side:
                BorderSide(width: 0.2.w, color: Color.fromRGBO(58, 67, 59, 1)),
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
