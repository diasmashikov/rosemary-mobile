import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosemary/constants/responsive_ui.dart';
import 'package:rosemary/cubit/categories_cubit.dart';
import 'package:rosemary/cubit/contacts_cubit.dart';
import 'package:rosemary/cubit/crudCubits/crud_orders_cubit.dart';
import 'package:rosemary/cubit/promotions_cubit.dart';

import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/screens/adminScreens/crudScreens/crudOrdersScreen.dart';
import 'package:rosemary/screens/adminScreens/crudScreens/crudUsersScreen.dart';
import 'package:rosemary/screens/main_screen.dart';
import 'package:rosemary/screens/singleScreens/contacts_screen.dart';
import 'package:rosemary/screens/singleScreens/promotions_screen.dart';
import 'package:rosemary/screens/womenScreens/women_screen.dart';

import 'package:rosemary/utils/widgets/custom_app_bar.dart';

import '../../../navigation_drawer_widget.dart';

import 'package:sizer/sizer.dart';

class CRUDScreen extends StatefulWidget {
  final String? token;
  final User? userData;
  final Repository repository;

  final int? cartOrderItemsCount;

  const CRUDScreen(
      {Key? key,
      required this.token,
      required this.userData,
      required this.repository,
      required this.cartOrderItemsCount})
      : super(key: key);
  @override
  _CRUDScreenState createState() => _CRUDScreenState();
}

class _CRUDScreenState extends State<CRUDScreen> {
  // for iosw
  double clothImageWidth = 150;
  double clothImageHeight = 75;
  double verticalMargin = 40;

  // for android
  //double productCellWidth = 160;
  //double productCellHeight = 240;
  @override
  Widget build(BuildContext context) => Scaffold(
      drawer: NavigationDrawerWidget(
          cartOrderItemsCount: 0,
          token: widget.token,
          userData: widget.userData,
          repository: widget.repository),
      appBar: CustomAppBar(
          cartOrderItemsCount: 0,
          title: "Контроль информации",
          favoriteIcon: null,
          shoppingCartIcon: null,
          settingsIcon: null,
          adminPanel: null,
          token: widget.token,
          userData: widget.userData,
          repository: widget.repository),
      body: Container(
        
        child: ListView(
          
          children: [
            GridView.count(
              padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: APP_SCREEN_CONTENT_PADDING_H_WIDTH),
              
              shrinkWrap: true,
              mainAxisSpacing: 0.1.h, crossAxisCount: 2, crossAxisSpacing: 0.1.w, childAspectRatio: 6.4.w / 4.h,
              children: [
                _buildGoodsCRUDSection(),
                _buildOrdersCRUDSection(),
                _buildMainScreenCRUDSection(),
                _buildPromotionsCRUDSection(),
                _buildContactsCRUDSection(),
                _buildUsersCRUDSection(),
              ],
            ),
          ],
        ),
      ));

  Widget _buildGoodsCRUDSection() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) =>
                      CategoriesCubit(repository: widget.repository),
                  child: WomenScreen(
                      token: widget.token,
                      userData: widget.userData,
                      repository: widget.repository,
                      cartOrderItemsCount: widget.cartOrderItemsCount),
                )));
      },
      child: Container(
        child: Card(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      child: Image.asset(
                        "assets/goods_images/product5.jpg",
                        width: 45.w,
                    height: 30.h,
                    fit: BoxFit.cover,
                        color: Color.fromRGBO(0, 0, 0, 0.4),
                        colorBlendMode: BlendMode.darken,
                      ),
                    ),
                    Text("Товары",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Merriweather-Bold',
                            fontSize: 14.sp))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersCRUDSection() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) =>
                      CrudOrdersCubit(repository: widget.repository),
                  child: crudOrdersScreen(
                      token: widget.token,
                      userData: widget.userData,
                      repository: widget.repository),
                )));
      },
      child: Container(
        child: Card(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      child: Image.asset(
                        "assets/goods_images/product7.jpg",
                        width: 45.w,
                    height: 30.h,
                        fit: BoxFit.cover,
                        color: Color.fromRGBO(0, 0, 0, 0.4),
                        colorBlendMode: BlendMode.darken,
                      ),
                    ),
                    Text("Заказы",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Merriweather-Bold',
                            fontSize: 14.sp))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainScreenCRUDSection() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MainScreen(
                  repository: widget.repository,
                  token: widget.token,
                  userData: widget.userData,
                  adminAccess: widget.userData!.isAdmin
                      ,
                )));
      },
      child: Container(
        child: Card(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      child: Image.asset(
                        "assets/goods_images/product2.jpg",
                        width: double.infinity,
                        fit: BoxFit.fill,
                        color: Color.fromRGBO(0, 0, 0, 0.4),
                        colorBlendMode: BlendMode.darken,
                      ),
                    ),
                    Text("Главная страница",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Merriweather-Bold',
                            fontSize: 14.sp))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromotionsCRUDSection() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) =>
                      PromotionsCubit(repository: widget.repository),
                  child: PromotionsScreen(
                      token: widget.token,
                      userData: widget.userData,
                      repository: widget.repository,
                      cartOrderItemsCount: widget.cartOrderItemsCount),
                )));
      },
      child: Container(
        child: Card(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      child: Image.asset(
                        "assets/goods_images/product8.jpg",
                        width: double.infinity,
                        fit: BoxFit.fill,
                        color: Color.fromRGBO(0, 0, 0, 0.4),
                        colorBlendMode: BlendMode.darken,
                      ),
                    ),
                    Text("Акции",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Merriweather-Bold',
                            fontSize: 14.sp))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactsCRUDSection() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) =>
                      ContactsCubit(repository: widget.repository),
                  child: ContactsScreen(
                      token: widget.token,
                      userData: widget.userData,
                      repository: widget.repository,
                      cartOrderItemsCount: widget.cartOrderItemsCount),
                )));
      },
      child: Container(
        child: Card(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      child: Image.asset(
                        "assets/goods_images/product4.jpg",
                        width: double.infinity,
                        fit: BoxFit.fill,
                        color: Color.fromRGBO(0, 0, 0, 0.4),
                        colorBlendMode: BlendMode.darken,
                      ),
                    ),
                    Text("Контакты",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Merriweather-Bold',
                            fontSize: 14.sp))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsersCRUDSection() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => crudUsersScreen(
                token: widget.token,
                userData: widget.userData,
                repository: widget.repository)));
      },
      child: Container(
        child: Card(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      child: Image.asset(
                        "assets/goods_images/product6.jpg",
                        width: double.infinity,
                        fit: BoxFit.fill,
                        color: Color.fromRGBO(0, 0, 0, 0.4),
                        colorBlendMode: BlendMode.darken,
                      ),
                    ),
                    Text("Пользователи",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Merriweather-Bold',
                            fontSize: 14.sp))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
