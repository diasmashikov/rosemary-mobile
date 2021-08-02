import 'package:flutter/material.dart';
import 'package:rosemary/constants/colors.dart';
import 'package:rosemary/constants/gradients.dart';
import 'package:rosemary/screens/paymentScreens/billing_address_screen.dart';
import 'package:rosemary/screens/paymentScreens/info_screen.dart';
import 'package:rosemary/screens/paymentScreens/payment_method_screen.dart';
import 'package:rosemary/screens/paymentScreens/shipping_screen.dart';
import 'package:rosemary/screens/settingsScreens/settings_screen.dart';
import 'package:rosemary/screens/singleScreens/shopping_cart_screen.dart';

import 'package:rosemary/utils/gradient_text.dart';
import '../../navigation_drawer_widget.dart';
import 'favorites_screen.dart';

class UserScreen extends StatefulWidget {
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
  Widget build(BuildContext context) => Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        centerTitle: false,
        title: Text("Личный кабинет",
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
          ),
          IconButton(
            icon: Icon(Icons.settings_outlined,
                color: Color.fromRGBO(58, 67, 59, 1)),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SettingsScreen(),
            )),
          )
        ],
      ),
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ListView(children: [
            _buildHeader(
                urlImage: urlImage,
                name: name,
                status: status,
                onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UserScreen(),
                    ))),
            SizedBox(
              height: 16,
            ),
            Divider(color: Color.fromRGBO(58, 67, 59, 1)),
            SizedBox(
              height: 32,
            ),
            _buildSectionTitle(title: "Информация для покупок"),
            SizedBox(
              height: 12,
            ),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 2.5),
              children: [
                _buildMyInfoContainer(),
                _buildBillingAddressContainer(),
                _buildShippingAddressContainer(),
                _buildPaymentMethodContainer()
              ],
            ),
            SizedBox(
              height: 12,
            ),
            _buildSectionTitle(title: "Флажки бонусов"),
            SizedBox(
              height: 12,
            ),
            Column(
              children: [
                _buildInfoCompletedCheckBox(),
                _buildSharedCheckBox(),
                _buildBoughtProductsCheckBox()
              ],
            )
          ])));

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
              radius: 36,
              //backgroundImage: NetworkImage(urlImage),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                        fontSize: 20,
                        color: Color.fromRGBO(58, 67, 59, 1),
                        fontFamily: 'Merriweather-Bold')),
                const SizedBox(height: 4),
                GradientText(status,
                fontSize: 18,
                    gradient: GOLDEN_GRADIENT
                ),
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
            fontSize: 16));
  }

  Widget _buildMyInfoContainer() {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => (InfoScreen()),
      )),
          child: Card(
        child: Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.person_outline_outlined,
                color: Color.fromRGBO(58, 67, 59, 1),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Dias Mashikov",
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 12,
                  )),
              SizedBox(
                height: 4,
              ),
              Text("hajime@gmail.com",
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 12,
                  )),
              SizedBox(
                height: 4,
              ),
              Text("+7774442011",
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 12,
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
        builder: (context) => ((BillingAddressScreen())),
      )),
          child: Card(
        child: Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Color.fromRGBO(58, 67, 59, 1),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Dias Mashikov",
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 10,
                  )),
              SizedBox(
                height: 2,
              ),
              Text("Кабанбай Батыра 20",
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 10,
                  )),
              SizedBox(
                height: 2,
              ),
              Text("Казахстан",
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 10,
                  )),
              SizedBox(
                height: 2,
              ),
              Text("Алматинская область",
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 10,
                  )),
              SizedBox(
                height: 2,
              ),
              Text("Алматы",
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 10,
                  )),
              SizedBox(
                height: 2,
              ),
              Text("010000",
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 10,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShippingAddressContainer() {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ((ShippingAddressScreen())),
      )),
          child: Card(
        child: Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.local_shipping_outlined,
                color: Color.fromRGBO(58, 67, 59, 1),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Dias Mashikov",
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 10,
                  )),
              SizedBox(
                height: 2,
              ),
              Text("Кабанбай Батыра 20",
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 10,
                  )),
              SizedBox(
                height: 2,
              ),
              Text("Казахстан",
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 10,
                  )),
              SizedBox(
                height: 2,
              ),
              Text("Алматинская область",
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 10,
                  )),
              SizedBox(
                height: 2,
              ),
              Text("Алматы",
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 10,
                  )),
              SizedBox(
                height: 2,
              ),
              Text("010000",
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 10,
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
        builder: (context) => ((PaymentMethodScreen())),
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
              SizedBox(width: 10,),
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
            ])
        ),
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
            SizedBox(width: 10,),
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
          ])
      ),
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
            SizedBox(width: 10,),
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
          ])
      ),
    );
  }
}
