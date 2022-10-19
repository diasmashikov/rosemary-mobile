import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosemary/constants/colors.dart';
import 'package:rosemary/constants/responsive_ui.dart';
import 'package:rosemary/cubit/favorites_cubit.dart';
import 'package:rosemary/cubit/login_cubit.dart';
import 'package:rosemary/cubit/shopping_cart_cubit.dart';
import 'package:rosemary/cubit/statistics_cubit.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/screens/adminScreens/AdminPanelScreen.dart';
import 'package:rosemary/screens/singleScreens/favorites_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:rosemary/screens/settingsScreens/settings_screen.dart';
import 'package:rosemary/screens/singleScreens/login_screen.dart';
import 'package:rosemary/screens/singleScreens/shopping_cart_screen.dart';
import 'package:rosemary/screens/womenScreens/women_screen.dart';
import 'package:rosemary/utils/singletons/singleton_callbacks.dart';
import 'package:rosemary/utils/singletons/singleton_order_count.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double height = AppBar().preferredSize.height;
  final String title;
  final IconData? favoriteIcon;
  final IconData? shoppingCartIcon;
  final IconData? settingsIcon;
  final IconData? adminPanel;
  final String? token;
  final User? userData;
  final Repository repository;
  final int? cartOrderItemsCount;

  CustomAppBar(
      {Key? key,
      required this.title,
      required this.favoriteIcon,
      required this.shoppingCartIcon,
      required this.settingsIcon,
      required this.adminPanel,
      required this.token,
      required this.userData,
      required this.repository,
      required this.cartOrderItemsCount})
      : super(key: key);
  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _CustomAppBarState extends State<CustomAppBar> {
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
        backgroundColor: Color.fromRGBO(247, 247, 247, 1),
        title: Text(widget.title,
            style: TextStyle(
                fontSize: 13.5.sp,
                color: Color.fromRGBO(58, 67, 59, 1),
                fontFamily: 'Merriweather-Regular')),
        actions: <Widget>[
          _hideIconFavorite(),
          _hideIconShoppingCart(),
          _hideIconSettings(),
          _hideAdminPanel(),
          SizedBox(
            width: (widget.adminPanel == null) ? 3.w : 1.w,
          )
        ]);
  }

  Widget _hideIconFavorite() {
    if (widget.favoriteIcon != null) {
      return IconButton(
        padding: EdgeInsets.only(
            right: APP_BAR_ICONS_PADDING_RIGHT,
            left: APP_BAR_ICONS_PADDING_RIGHT),
        iconSize: APP_BAR_ICONS,
        icon:
            Icon(Icons.favorite_outline, color: Color.fromRGBO(58, 67, 59, 1)),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => FavoritesCubit(repository: widget.repository),
            child: FavoritesScreen(
                token: widget.token,
                userData: widget.userData,
                repository: widget.repository,
                cartOrderItemsCount: widget.cartOrderItemsCount),
          ),
        )),
      );
    } else {
      return Container();
    }
  }

  Widget _hideIconShoppingCart() {
    if (widget.shoppingCartIcon != null) {
      return Stack(alignment: Alignment.center, children: [
        Padding(
          padding: EdgeInsets.only(
              right: APP_BAR_ICONS_PADDING_RIGHT,
              left: APP_BAR_ICONS_PADDING_RIGHT),
          child: InkWell(
            onTap: () async {
              print(SingletonOrderCount.orderCount);
              (widget.token == null)
                  ? await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) =>
                            LoginCubit(repository: widget.repository),
                        child: LoginScreen(repository: widget.repository),
                      ),
                    ))
                  : await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) =>
                            ShoppingCartCubit(repository: widget.repository),
                        child: ShoppingCartScreen(
                          token: widget.token,
                          userData: widget.userData,
                          repository: widget.repository,
                          cartOrderItemsCount: widget.cartOrderItemsCount,
                        ),
                      ),
                    ));
              SingletonCallbacks.refreshOrderCountCallBack();
            },
            child: Badge(
                position: BadgePosition.topEnd(top: -16, end: -10),
                elevation: 0,
                badgeContent: Text(widget.cartOrderItemsCount.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 2.8.w,
                        color: Color.fromRGBO(58, 67, 59, 1),
                        fontFamily: 'Merriweather-Regular')),
                badgeColor: GOLD_COLOR,
                child: Icon(Icons.shopping_cart_outlined,
                    size: APP_BAR_ICONS, color: Color.fromRGBO(58, 67, 59, 1))),
          ),
        ),
      ]);
    } else {
      return Container();
    }
  }

  Widget _hideIconSettings() {
    if (widget.settingsIcon != null) {
      return IconButton(
        iconSize: APP_BAR_ICONS,
        padding: EdgeInsets.only(
            right: APP_BAR_ICONS_PADDING_RIGHT,
            left: APP_BAR_ICONS_PADDING_RIGHT),
        icon: Icon(widget.settingsIcon, color: Color.fromRGBO(58, 67, 59, 1)),
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SettingsScreen(
                token: widget.token,
                userData: widget.userData,
                repository: widget.repository,
                cartOrderItemsCount: widget.cartOrderItemsCount),
          ));
          SingletonCallbacks.refreshOrderCountCallBack();
        },
      );
    } else {
      return Container();
    }
  }

  Widget _hideAdminPanel() {
    if (widget.adminPanel != null) {
      return IconButton(
        iconSize: APP_BAR_ICONS,
        padding: EdgeInsets.only(
            right: APP_BAR_ICONS_PADDING_RIGHT,
            left: APP_BAR_ICONS_PADDING_RIGHT),
        icon: Icon(widget.adminPanel, color: Color.fromRGBO(58, 67, 59, 1)),
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BlocProvider(
                    create: (context) => StatisticsCubit(widget.repository),
                    child: AdminPanelScreen(
                      token: widget.token,
                      userData: widget.userData,
                      repository: widget.repository,
                      cartOrderItemsCount: widget.cartOrderItemsCount,
                    ),
                  )));

          setState(() {});
        },
      );
    } else {
      return Container();
    }
  }
}
