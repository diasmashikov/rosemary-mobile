import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:rosemary/constants/responsive_ui.dart';
import 'package:rosemary/cubit/registration_screen_cubit.dart';
import 'package:rosemary/cubit/login_cubit.dart';
import 'package:rosemary/cubit/shopping_cart_cubit.dart';
import 'package:rosemary/data/models/order.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/network_serivce.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/screens/paymentScreens/info_screen.dart';
import 'package:rosemary/screens/singleScreens/registration_screen.dart';

import 'package:rosemary/screens/singleScreens/shopping_cart_screen.dart';
import 'package:rosemary/utils/validators/login_forms_validator.dart';

import 'package:rosemary/utils/widgets/custom_app_bar.dart';
import 'package:rosemary/utils/singletons/singleton_order_count.dart';
import 'package:rosemary/utils/text_form_field.dart';
import 'package:rosemary/utils/text_form_field_password.dart';
import 'package:rosemary/utils/widgets/custom_text_field_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../navigation_drawer_widget.dart';

import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  final Repository repository;

  const LoginScreen({Key? key, required this.repository}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginCubit _loginCubit;
  var inputTextEmail = "";
  var inputPassword = "";
  var _controllerEmail = TextEditingController();
  var _controllerPassword = TextEditingController();

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loginCubit = BlocProvider.of<LoginCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavigationDrawerWidget(
          token: "",
          userData: null,
          repository: widget.repository,
          cartOrderItemsCount: null,
        ),
        appBar: CustomAppBar(
            title: "Логин",
            favoriteIcon: null,
            shoppingCartIcon: null,
            settingsIcon: null,
            adminPanel: null,
            cartOrderItemsCount: null,
            token: "",
            userData: null,
            repository: widget.repository),
        body: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(
              horizontal: APP_SCREEN_CONTENT_PADDING_H_WIDTH,
              vertical: APP_SCREEN_CONTENT_PADDING_V_WIDTH),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Form(
                    key: _loginFormKey,
                    child: Column(children: [
                      CustomTextFieldForm().buildTextFormField(
                          formName: "Email",
                          hint: "dias@mail.com",
                          controller: _controllerEmail,
                          validator:
                              LoginFormsValidator().validateFieldForEmptySpace),
                      CustomTextFieldForm().buildTextFormField(
                          formName: "Пароль",
                          hint: "Пароль",
                          obscure: true,
                          controller: _controllerPassword,
                          validator:
                              LoginFormsValidator().validateFieldForEmptySpace),
                    ])),
                // _buildEmailTextField(),

                _buildLoginBtn(),
                Divider(color: Color.fromRGBO(58, 67, 59, 1)),
                _buildRegisterBtn()
              ],
            ),
          ),
        ));
  }

  Widget _buildLoginBtn() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 3.h),
        width: double.infinity,
        height: 5.5.h,
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return OutlinedButton(
              child: Text('Войти',
                  style: TextStyle(
                      fontSize: 11.5.sp,
                      color: Color.fromRGBO(58, 67, 59, 1),
                      fontFamily: 'SolomonSans-SemiBold')),
              onPressed: () {
                if (_loginFormKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Авторизируем Вас...'),
                    duration: const Duration(seconds: 1),
                  ));
                  _loginCubit
                      .postLogin(
                          _controllerEmail.text, _controllerPassword.text)
                      .then((loginResponse) async {
                    print(loginResponse!.token + " LOGIN");
                    if (loginResponse.token == "The user not found") {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Неправильный email'),
                        duration: const Duration(seconds: 1),
                      ));
                    } else if (loginResponse.token == "password is wrong!") {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Неправильный пароль'),
                        duration: const Duration(seconds: 1),
                      ));
                    } else {
                      final prefs = await SharedPreferences.getInstance();
                      //await prefs.setString("loginToken", state.loginResponse!.token);
                      //await prefs.setString("loginUserId", state.loginResponse!.userId);
                      await prefs.setString(
                          "loginEmail", _controllerEmail.text);
                      await prefs.setString(
                          "loginPassword", _controllerPassword.text);
                      var orderCartCountResponse = await getOrderCart(
                          loginResponse.user, loginResponse.token);
                      if (!(orderCartCountResponse.isEmpty)) {
                        print(orderCartCountResponse);
                        var _orderItemsCount =
                            Order.fromJson(orderCartCountResponse[0])
                                .orderItems
                                .length;
                        SingletonOrderCount.orderCount = _orderItemsCount;
                      } else {
                        SingletonOrderCount.orderCount = 0;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Авторизация успешна'),
                        duration: const Duration(seconds: 1),
                      ));
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => ShoppingCartCubit(
                              repository:
                                  Repository(networkService: NetworkService())),
                          child: ShoppingCartScreen(
                            token: loginResponse.token,
                            userData: loginResponse.user,
                            repository: widget.repository,
                            cartOrderItemsCount: null,
                          ),
                        ),
                      ));
                    }
                  });
                }
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                    width: 0.2.w, color: Color.fromRGBO(58, 67, 59, 1)),
              ),
            );
          },
        ));
  }

  Future<List<dynamic>> getOrderCart(User? user, String token) async {
    try {
      final baseUrl = "https://rosemary-server.herokuapp.com/api/v1";
      final response = await get(
        Uri.parse(baseUrl + "/orders" + "/" + user!.id + "/" + "Cart"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      return jsonDecode(response.body) as List;
    } catch (e) {
      return [];
    }
  }

  Widget _buildRegisterBtn() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 3.h),
        width: double.infinity,
        height: 5.5.h,
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return OutlinedButton(
              child: Text('Создать аккаунт',
                  style: TextStyle(
                      fontSize: 11.5.sp,
                      color: Color.fromRGBO(58, 67, 59, 1),
                      fontFamily: 'SolomonSans-SemiBold')),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) =>
                        RegistrationScreenCubit(repository: widget.repository),
                    child: RegistrationScreen(
                      repository: widget.repository,
                      cartOrderItemsCount: null,
                      token: '',
                      userData: null,
                    ),
                  ),
                ));
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                    width: 0.2.w, color: Color.fromRGBO(58, 67, 59, 1)),
              ),
            );
          },
        ));
  }

  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );
}
