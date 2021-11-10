import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosemary/constants/colors.dart';
import 'package:rosemary/constants/gradients.dart';
import 'package:rosemary/constants/responsive_ui.dart';
import 'package:rosemary/cubit/info_cubit.dart';
import 'package:rosemary/cubit/user_cubit.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/screens/paymentScreens/billing_address_screen.dart';
import 'package:rosemary/screens/paymentScreens/info_screen.dart';
import 'package:rosemary/screens/paymentScreens/payment_method_screen.dart';
import 'package:rosemary/screens/paymentScreens/shipping_screen.dart';
import 'package:rosemary/screens/settingsScreens/settings_screen.dart';
import 'package:rosemary/screens/singleScreens/shopping_cart_screen.dart';
import 'package:rosemary/utils/widgets/custom_app_bar.dart';

import 'package:rosemary/utils/gradient_text.dart';
import 'package:rosemary/utils/singletons/singleton_callbacks.dart';
import 'package:rosemary/utils/singletons/singleton_order_count.dart';
import '../../navigation_drawer_widget.dart';
import 'favorites_screen.dart';

import 'package:sizer/sizer.dart';


class UserScreen extends StatefulWidget {
  final String? token;
  final User? userData;
  final Repository repository;

  final int? cartOrderItemsCount;

  const UserScreen({Key? key, required this.token, required this.userData, required this.repository, required this.cartOrderItemsCount})
      : super(key: key);

  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<UserScreen> {
  final name = 'Dias Mashikov';
  final status = 'Admin';
  final urlImage = 'https://images.unsplash.com/photo-1547721064-da6cfb341d50';

  // for ios
  double productCellWidth = 100;
  double productCellHeight = 100;

  // for android
  //double productCellWidth = 160;
  //double productCellHeight = 240;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserCubit>(context).fetchUserData(token: widget.token, userId: widget.userData!.id);
    
  }
  @override
  Widget build(BuildContext context) {
    SingletonCallbacks.refreshOrderCountCallBack = updateAfterReturn;
    
    
   return Scaffold(
      drawer: NavigationDrawerWidget(
          token: widget.token,
          userData: widget.userData,
          repository: widget.repository,
        cartOrderItemsCount: widget.cartOrderItemsCount
          ),
      appBar: CustomAppBar(
          title: "Кабинет",
          favoriteIcon: Icons.favorite_outline,
          shoppingCartIcon: Icons.shopping_cart_outlined,
          settingsIcon: Icons.settings_outlined,
          adminPanel: (widget.userData!.isAdmin != true) ?  null : Icons.admin_panel_settings_outlined,
          token: widget.token,
          userData: widget.userData,
          repository: widget.repository,
        cartOrderItemsCount: SingletonOrderCount.orderCount
          ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (!(state is UserLoaded)) {
            return Center(child: CircularProgressIndicator());
          }

          final userData = (state as UserLoaded).userData;

          return Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: ListView(children: [
                  _buildHeader(
                      urlImage: urlImage,
                      name: userData!.name,
                      status: (userData.isAdmin == true) ? "Aдмин" : "Клиент",
                      onClicked: () => {}),
                  SizedBox(
                    height: 2.h,
                  ),
                  Divider(color: Color.fromRGBO(58, 67, 59, 1)),
                  SizedBox(
                    height: 3.5.h,
                  ),
                  _buildSectionTitle(title: "Информация для покупок"),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: 7.w/3.h,
                    children: [
                      _buildMyInfoContainer(userData.name, userData.email, userData.phone),
                      
                      _buildShippingAddressContainer(userData.name, userData.street, userData.country, userData.city, userData.zip),
                      _buildPaymentMethodContainer()
                    ],
                  ),
                  /*
                  SizedBox(
                    height: 1.5.h,
                  ),
                  _buildSectionTitle(title: "Флажки бонусов"),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  
                  Column(
                    children: [
                      _buildInfoCompletedCheckBox(),
                      _buildSharedCheckBox(),
                      _buildBoughtProductsCheckBox()
                    ],
                  )
                  */
                ]));
        },
      )); }

  Widget _buildHeader(
      {required String urlImage,
      required String name,
      required String status,
      required VoidCallback onClicked}) {
    return InkWell(
        onTap: onClicked,
        child: Container(
            child: Row(
          children: [
            CircleAvatar(
              radius: 9.w,
              //backgroundImage: NetworkImage(urlImage),
            ),
            SizedBox(width: 4.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: Color.fromRGBO(58, 67, 59, 1),
                        fontFamily: 'Merriweather-Bold')),
                SizedBox(height: 0.5.h),
                GradientText(status, fontSize: 13.sp, gradient: GOLDEN_GRADIENT),
              ],
            )
          ],
        )));
  }

  Widget _buildSectionTitle({required String title}) {
    return Text(title,
        style: TextStyle(
            color: Color.fromRGBO(58, 67, 59, 0.5),
            fontFamily: 'Merriweather-Regular',
            fontSize: 11.5.sp));
  }

  Widget _buildMyInfoContainer(String name, String email, String phone) {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => (BlocProvider(
            create: (context) => InfoCubit(repository: widget.repository),
            child: InfoScreen(
                token: widget.token,
                userData: widget.userData,
                repository: widget.repository,
                cartOrderItemsCount: widget.cartOrderItemsCount),
          )),
        )),
      child: Card(
        child: Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.symmetric(horizontal: APP_SCREEN_CONTENT_PADDING_H_WIDTH, vertical: APP_SCREEN_CONTENT_PADDING_V_WIDTH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.person_outline_outlined,
                size: 5.w,
                color: Color.fromRGBO(58, 67, 59, 1),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(name,
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 9.sp,
                  )),
              SizedBox(
                height: 0.5.h,
              ),
              Text(email,
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 9.sp,
                  )),
              SizedBox(
                height: 0.5.h,
              ),
              Text(phone,
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                                        fontSize: 9.sp,

                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBillingAddressContainer() {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ((BillingAddressScreen(token: widget.token,
            userData: widget.userData,
            repository: widget.repository,
        cartOrderItemsCount: widget.cartOrderItemsCount
            ))),
      )),
      child: Card(
        child: Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.symmetric(horizontal: APP_SCREEN_CONTENT_PADDING_H_WIDTH, vertical: APP_SCREEN_CONTENT_PADDING_V_WIDTH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 5.w,
                color: Color.fromRGBO(58, 67, 59, 1),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text("Dias Mashikov",
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 8.sp,
                  )),
              SizedBox(
                height: 0.5.h,
              ),
              Text("Кабанбай Батыра 20",
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 8.sp,
                  )),
              SizedBox(
                height: 2,
              ),
              Text("Казахстан",
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 8.sp,
                  )),
              SizedBox(
                height: 2,
              ),
              Text("Алматинская область",
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 8.sp,
                  )),
              SizedBox(
                height: 2,
              ),
              Text("Алматы",
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 8.sp,
                  )),
              SizedBox(
                height: 0.5.h,
              ),
              Text("010000",
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 8.sp,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShippingAddressContainer(String name, String street, String country, String city, String zip) {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ((ShippingAddressScreen(token: widget.token,
            userData: widget.userData,
            repository: widget.repository,
        cartOrderItemsCount: widget.cartOrderItemsCount
            ))),
      )),
      child: Card(
        child: Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.symmetric(horizontal: APP_SCREEN_CONTENT_PADDING_H_WIDTH, vertical: APP_SCREEN_CONTENT_PADDING_V_WIDTH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                
                Icons.local_shipping_outlined,
                size: 5.w,
                color: Color.fromRGBO(58, 67, 59, 1),
              ),
              SizedBox(
                height: 1.h
              ),
              Text(name,
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 8.sp,
                  )),
              SizedBox(
                height: 0.5.h,
              ),
              Text(street,
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 8.sp,
                  )),
              SizedBox(
                height: 0.5.h
              ),
              Text(country,
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 8.sp,
                  )),
              SizedBox(
                height: 0.5.h,
              ),
              Text("Алматинская область",
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 8.sp,
                  )),
              SizedBox(
                height: 0.5.h,
              ),
              Text(city,
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 8.sp,
                  )),
              SizedBox(
                height: 0.5.h
              ),
              Text(zip,
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 8.sp,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodContainer() {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ((PaymentMethodScreen(token: widget.token,
            userData: widget.userData,
            repository: widget.repository,
        cartOrderItemsCount: widget.cartOrderItemsCount
            ))),
      )),
      child: Card(
        child: Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.credit_card_outlined,
                size: 5.w,
                color: Color.fromRGBO(58, 67, 59, 1),
              ),
              SizedBox(
                height: 10,
              ),
              Row(children: [
                Container(
                  alignment: Alignment.center,
                  height: 25,
                  width: 25,
                  child: Image.asset(
                    'assets/visa.png',
                    height: 50,
                    width: 50,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text("**** **** **** 4386",
                    style: TextStyle(
                      color: Color.fromRGBO(58, 67, 59, 1),
                      fontFamily: 'SolomonSans-SemiBold',
                      fontSize: 10,
                    ))
              ]),
              Row(children: [
                Container(
                  alignment: Alignment.center,
                  height: 25,
                  width: 25,
                  child: Image.asset(
                    'assets/kaspi.png',
                    height: 50,
                    width: 50,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text("+7774442011",
                    style: TextStyle(
                        color: Color.fromRGBO(58, 67, 59, 1),
                        fontFamily: 'SolomonSans-SemiBold',
                        fontSize: 10,
                        letterSpacing: 0.8))
              ])
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCompletedCheckBox() {
    return Container(
      child: Card(
        color: GOLD_COLOR,
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            width: double.infinity,
            height: 25,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.all_inbox, color: PRIMARY_DARK_COLOR),
                  SizedBox(
                    width: 10,
                  ),
                  Center(
                    child: Text("Заполните все данные для покупок",
                        style: TextStyle(
                          color: Color.fromRGBO(58, 67, 59, 1),
                          fontFamily: 'Merriweather-Regular',
                          fontSize: 12,
                        )),
                  ),
                  Spacer(),
                  Icon(Icons.check_box_outline_blank, color: PRIMARY_DARK_COLOR)
                ])),
      ),
    );
  }

  Widget _buildSharedCheckBox() {
    return Card(
      color: GOLD_COLOR,
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          width: double.infinity,
          height: 25,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.campaign_outlined, color: PRIMARY_DARK_COLOR),
                SizedBox(
                  width: 10,
                ),
                Center(
                  child: Text("Укажите нас в стори в инстаграм",
                      style: TextStyle(
                        color: Color.fromRGBO(58, 67, 59, 1),
                        fontFamily: 'Merriweather-Regular',
                        fontSize: 12,
                      )),
                ),
                Spacer(),
                Icon(Icons.check_box_outline_blank, color: PRIMARY_DARK_COLOR)
              ])),
    );
  }

  Widget _buildBoughtProductsCheckBox() {
    return Card(
      color: GOLD_COLOR,
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          width: double.infinity,
          height: 25,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.shopping_bag_outlined, color: PRIMARY_DARK_COLOR),
                SizedBox(
                  width: 10,
                ),
                Center(
                  child: Text("Приобретите товаров на сумму 10,000 Т",
                      style: TextStyle(
                        color: Color.fromRGBO(58, 67, 59, 1),
                        fontFamily: 'Merriweather-Regular',
                        fontSize: 12,
                      )),
                ),
                Spacer(),
                Icon(Icons.check_box_outline_blank, color: PRIMARY_DARK_COLOR)
              ])),
    );
    
  }
  void updateAfterReturn() {
    setState(() {});
  }
}
