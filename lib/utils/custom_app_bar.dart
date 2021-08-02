import 'package:flutter/material.dart';
import 'package:rosemary/screens/singleScreens/favorites_screen.dart';

import 'package:rosemary/screens/settingsScreens/settings_screen.dart';
import 'package:rosemary/screens/singleScreens/shopping_cart_screen.dart';


class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double height = AppBar().preferredSize.height;
  final String title;
  final IconData? favoriteIcon;
  final IconData? shoppingCartIcon;
  final IconData? settingsIcon;

  CustomAppBar({
    Key? key,
    required this.title,
    required this.favoriteIcon,
    required this.shoppingCartIcon,
    required this.settingsIcon,
  }) : super(key: key);
  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        centerTitle: false,
        title: Text(widget.title,
            style: TextStyle(
                color: Color.fromRGBO(58, 67, 59, 1),
                fontFamily: 'Merriweather-Regular')),
        actions: <Widget>[
          _hideIconFavorite(),
          _hideIconShoppingCart(),
          _hideIconSettings()
        ]);
  }

  Widget _hideIconFavorite() {
    if (widget.favoriteIcon != null) {
      return IconButton(
        icon: Icon(widget.favoriteIcon, color: Color.fromRGBO(58, 67, 59, 1)),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FavoritesScreen(),
        )),
      );
    } else {
      return Container();
    }
  }

  Widget _hideIconShoppingCart() {
    if (widget.shoppingCartIcon != null) {
      return IconButton(
        icon:
            Icon(widget.shoppingCartIcon, color: Color.fromRGBO(58, 67, 59, 1)),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ShoppingCartScreen(),
        )),
      );
    } else {
      return Container();
    }
  }

  Widget _hideIconSettings() {
    if (widget.settingsIcon != null) {
      return IconButton(
        icon: Icon(widget.settingsIcon, color: Color.fromRGBO(58, 67, 59, 1)),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SettingsScreen(),
        )),
      );
    } else {
      return Container();
    }
  }
}
