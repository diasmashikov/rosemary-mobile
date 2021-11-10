import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosemary/constants/responsive_ui.dart';
import 'package:rosemary/cubit/categories_cubit.dart';
import 'package:rosemary/cubit/frequently_asked_questions_cubit.dart';
import 'package:rosemary/cubit/promotions_cubit.dart';
import 'package:rosemary/data/network_serivce.dart';
import 'package:rosemary/utils/gradient_text.dart';
import 'package:sizer/sizer.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/screens/singleScreens/contacts_screen.dart';
import 'package:rosemary/screens/singleScreens/frequent_questions_screen.dart';
import 'package:rosemary/screens/main_screen.dart';
import 'package:rosemary/screens/singleScreens/my_orders_screen.dart';
import 'package:rosemary/screens/singleScreens/promotions_screen.dart';
import 'package:rosemary/screens/singleScreens/user_screen.dart';
import 'package:rosemary/screens/womenScreens/women_screen.dart';

import 'constants/gradients.dart';
import 'cubit/contacts_cubit.dart';
import 'cubit/my_orders_cubit.dart';
import 'cubit/user_cubit.dart';
import 'data/models/user.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final String? token;
  final User? userData;
  final Repository repository;
  final int? cartOrderItemsCount;


  final padding = EdgeInsets.symmetric(horizontal: 20);

  NavigationDrawerWidget({Key? key, required this.token, required this.userData, required this.repository, required this.cartOrderItemsCount})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final name = 'Dias Mashikov';
    final status = 'VIP';
    final urlImage =
        'https://images.unsplash.com/photo-1547721064-da6cfb341d50';

    return Drawer(
      
      
      child: Material(
          color: Color.fromRGBO(237, 236, 232, 1),
          child: ListView(
            children: <Widget>[
              buildHeader(
                  urlImage: urlImage,
                  name: userData!.name,
                  status: (userData!.isAdmin == true) ? "Админ" : "Клиент",
                  onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            BlocProvider(
                              create: (context) => UserCubit(repository: repository),
                              child: UserScreen(token: token, userData: userData, repository: repository, cartOrderItemsCount: cartOrderItemsCount),
                            ),
                      ))),
              SizedBox(
                height: 1.0.h,
              ),
              Container(
                  child: Column(
                children: [
                  buildMenuItem(
                      text: 'Главная',
                      icon: Icons.home_outlined,
                      onClicked: () => selectedItem(context, 0)),
                  SizedBox(
                    height: DRAWER_ITEMS_VERTICAL_MARGIN,
                  ),
                  buildMenuItem(
                      text: 'Мои заказы',
                      icon: Icons.local_shipping_outlined,
                      onClicked: () => selectedItem(context, 1)),
                  SizedBox(
                                        height: DRAWER_ITEMS_VERTICAL_MARGIN,

                  ),
                  buildMenuItem(
                      text: 'Женщины',
                      icon: Icons.shopping_bag_outlined,
                      onClicked: () => selectedItem(context, 2)),
                  SizedBox(
                                        height: DRAWER_ITEMS_VERTICAL_MARGIN,

                  ),
                  buildMenuItem(
                      text: 'Акции',
                      icon: Icons.local_offer_outlined,
                      onClicked: () => selectedItem(context, 3)),
                  SizedBox(                    height: DRAWER_ITEMS_VERTICAL_MARGIN,
),
                  Divider(color: Color.fromRGBO(58, 67, 59, 1)),
                  SizedBox(                    height: DRAWER_ITEMS_VERTICAL_MARGIN,
),
                  buildMenuItem(
                      text: 'Контакты',
                      icon: Icons.call_outlined,
                      onClicked: () => selectedItem(context, 4)),
                  SizedBox(                    height: DRAWER_ITEMS_VERTICAL_MARGIN,
),
                  buildMenuItem(
                      text: 'Частые вопросы',
                      icon: Icons.help_center_outlined,
                      onClicked: () => selectedItem(context, 5)),
                ],
              ))
            ],
          )),
    );
  }

  Widget buildHeader(
          {required String urlImage,
          required String name,
          required String status,
          required VoidCallback onClicked}) =>
      InkWell(
          onTap: onClicked,
          child: Container(
              padding: EdgeInsets.only(top: 3.h, bottom: 1.5.h, right: 4.5.w, left: 4.2.w),
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
                              fontSize: 12.sp,
                              color: Color.fromRGBO(58, 67, 59, 1),
                              fontFamily: 'Merriweather-Bold')),
                      const SizedBox(height: 4),
                      GradientText(status, fontSize: 11.sp, gradient: GOLDEN_GRADIENT),
                    ],
                  )
                ],
              )));

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Color.fromRGBO(58, 67, 59, 1);
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color, size: 6.5.w),
      minLeadingWidth: 7.w,
      title: Text(text,
          style: TextStyle(
              color: color, fontFamily: 'Merriweather-Bold', fontSize: 10.5.sp)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MainScreen(
            repository: repository,
            token: token,
            userData: userData,
            adminAccess: userData!.isAdmin
          ),
        ));
        break;

      case 1:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => MyOrdersCubit(repository: repository),
                  child: MyOrdersScreen(
                      repository: repository, token: token, userData: userData, cartOrderItemsCount: cartOrderItemsCount),
                )));
        break;

      case 2:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => CategoriesCubit(repository: repository),
                  child: WomenScreen(
                      repository: repository, token: token, userData: userData, cartOrderItemsCount: cartOrderItemsCount),
                )));
        break;

      

      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => PromotionsCubit(repository: repository),
            child: PromotionsScreen(token: token, userData: userData, repository: repository, cartOrderItemsCount: cartOrderItemsCount),
          ),
        ));
        break;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ContactsCubit(repository: repository),
            child: ContactsScreen(token: token, userData: userData, repository: repository, cartOrderItemsCount: cartOrderItemsCount),
          ),
        ));
        break;
      case 5:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              BlocProvider(
                create: (context) => FrequentlyAskedQuestionsCubit(repository: repository),
                child: FrequentQuestionsScreen(token: token, userData: userData, repository: repository, cartOrderItemsCount: cartOrderItemsCount),
              ),
        ));
        break;
    }
  }
}
