import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosemary/constants/colors.dart';
import 'package:rosemary/constants/responsive_ui.dart';
import 'package:rosemary/cubit/favorites_cubit.dart';
import 'package:rosemary/cubit/login_cubit.dart';
import 'package:rosemary/cubit/shopping_cart_cubit.dart';
import 'package:rosemary/cubit/statistics_cubit.dart';
import 'package:rosemary/data/models/ordersInProgress.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/screens/adminScreens/AdminPanelScreen.dart';
import 'package:rosemary/screens/singleScreens/favorites_screen.dart';
import 'package:rosemary/utils/widgets/google_maps_widget.dart';
import 'package:rosemary/utils/singletons/singleton_orders.dart';
import 'package:sizer/sizer.dart';

import 'package:rosemary/screens/settingsScreens/settings_screen.dart';
import 'package:rosemary/screens/singleScreens/login_screen.dart';
import 'package:rosemary/screens/singleScreens/shopping_cart_screen.dart';
import 'package:rosemary/screens/womenScreens/women_screen.dart';
import 'package:rosemary/utils/singletons/singleton_callbacks.dart';
import 'package:rosemary/utils/singletons/singleton_order_count.dart';

class OrdersAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double height = AppBar().preferredSize.height;
  final User? user;

  OrdersAppBar({
    Key? key,
    required this.user,
  }) : super(key: key);
  @override
  _OrdersAppBarState createState() => _OrdersAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _OrdersAppBarState extends State<OrdersAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, color: PRIMARY_DARK_COLOR),
          iconSize: APP_BAR_ICONS,
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        centerTitle: false,
        titleSpacing: 0,
        title: Text("Заказы",
            style: TextStyle(
                fontSize: 13.5.sp,
                color: Color.fromRGBO(58, 67, 59, 1),
                fontFamily: 'Merriweather-Regular')),
        actions: <Widget>[
          _googleMapsIcon(),
          SizedBox(
            width: 1.w,
          )
        ]);
  }

  Widget _googleMapsIcon() {
    return IconButton(
      padding: EdgeInsets.only(
          right: APP_BAR_ICONS_PADDING_RIGHT,
          left: APP_BAR_ICONS_PADDING_RIGHT),
      iconSize: APP_BAR_ICONS,
      icon: Icon(Icons.location_on_outlined,
          color: Color.fromRGBO(58, 67, 59, 1)),
      onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => GoogleMaps(orders: SingletonOrders.orders, user: widget.user))),
    );
  }
}
