import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosemary/constants/colors.dart';
import 'package:rosemary/constants/responsive_ui.dart';
import 'package:rosemary/cubit/login_cubit.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/screens/singleScreens/login_screen.dart';
import 'package:rosemary/screens/singleScreens/shopping_cart_screen.dart';
import 'package:rosemary/utils/widgets/custom_app_bar.dart';


import '../../navigation_drawer_widget.dart';
import '../singleScreens/favorites_screen.dart';

import 'package:sizer/sizer.dart';


class SettingsScreen extends StatefulWidget {
  final String? token;
  final User? userData;
  final Repository repository;

  final int? cartOrderItemsCount;

  const SettingsScreen({Key? key, required this.token, required this.userData, required this.repository, required this.cartOrderItemsCount}) : super(key: key);
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  

  // for ios
  double clothImageWidth = 400;
  double clothImageHeight = 380;
  double verticalMargin = 40;

  // for android
  //double productCellWidth = 160;
  //double productCellHeight = 240;
  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: NavigationDrawerWidget(token: widget.token,
         userData: widget.userData,
          repository: widget.repository, 
        cartOrderItemsCount: widget.cartOrderItemsCount
          ),
        appBar: CustomAppBar(
          title: "Настройки",
          favoriteIcon: Icons.favorite_outline,
          shoppingCartIcon: Icons.shopping_cart_outlined,
          settingsIcon: null,
          adminPanel: (widget.userData!.isAdmin != true) ?  null : Icons.admin_panel_settings_outlined,

          token: widget.token,
           userData: widget.userData,
            repository: widget.repository,
        cartOrderItemsCount: widget.cartOrderItemsCount

        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: APP_SCREEN_CONTENT_PADDING_H_WIDTH, vertical: APP_SCREEN_CONTENT_PADDING_V_WIDTH),
          child: ListView(children: [
            _buildSecuritySection(),
            Divider(color: PRIMARY_DARK_COLOR),
            _buildLanguageSection(),
            Divider(color: PRIMARY_DARK_COLOR),


          ],),
        )
      );

  Widget _buildSecuritySection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: APP_SCREEN_CONTENT_PADDING_V_WIDTH),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Безопасность и приватность",
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Bold',
              fontSize: 14.sp,
            )),
        SizedBox(
          height: 4.h,
        ),
        Text(
            "Поменять пароль",
            style: TextStyle(
              fontFamily: 'Merriweather-Regular',
              fontSize: 11.5.sp,
              shadows: [
                Shadow(
                    color: PRIMARY_DARK_COLOR,
                    offset: Offset(0, -5))
              ],
              color: Colors.transparent,
              decoration:
              TextDecoration.underline,
              decorationColor: PRIMARY_DARK_COLOR,
              decorationThickness: 0.5.w,
              decorationStyle:
              TextDecorationStyle.solid,
            ),
          ),
          SizedBox(height: 2.h,),
          InkWell(
            onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => LoginCubit(repository: widget.repository),
            child: LoginScreen(repository: widget.repository),
          ),
        ));
      },
            child: Text(
              "Выйти из аккаунта",
              style: TextStyle(
                fontFamily: 'Merriweather-Regular',
                fontSize: 11.5.sp,
                shadows: [
                  Shadow(
                      color: PRIMARY_DARK_COLOR,
                      offset: Offset(0, -5))
                ],
                color: Colors.transparent,
                decoration:
                TextDecoration.underline,
                decorationColor: PRIMARY_DARK_COLOR,
                decorationThickness: 0.5.w,
                decorationStyle:
                TextDecorationStyle.solid,
              ),
            ),
          ),
       
      ]),
    );
  }

   Widget _buildLanguageSection() {
    return Container(
         margin: EdgeInsets.symmetric(vertical: APP_SCREEN_CONTENT_PADDING_V_WIDTH),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Язык",
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Bold',
              fontSize: 14.sp,
            )),
        SizedBox(
          height: 4.h,
        ),
        Text(
            "Русский",
            
            style: TextStyle(
              fontSize: 11.5.sp,

              fontFamily: 'Merriweather-Regular',
              shadows: [
                Shadow(
                    color: PRIMARY_DARK_COLOR,
                    offset: Offset(0, -5))
              ],
              color: Colors.transparent,
              decoration:
              TextDecoration.underline,
              decorationColor: PRIMARY_DARK_COLOR,
              decorationThickness: 0.5.w,
              decorationStyle:
              TextDecorationStyle.solid,
            ),
          ),
       
      ]),
    );
  }


}

