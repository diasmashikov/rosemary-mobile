import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:rosemary/constants/colors.dart';
import 'package:rosemary/cubit/categories_cubit.dart';
import 'package:rosemary/cubit/favorites_cubit.dart';
import 'package:rosemary/cubit/product_detail_cubit.dart';
import 'package:rosemary/data/models/favorite.dart';
import 'package:rosemary/data/models/product.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/screens/singleScreens/shopping_cart_screen.dart';
import 'package:rosemary/screens/womenScreens/women_product_screen.dart';
import 'package:rosemary/screens/womenScreens/women_screen.dart';
import 'package:rosemary/utils/widgets/custom_app_bar.dart';
import 'package:rosemary/utils/singletons/singleton_callbacks.dart';
import '../../navigation_drawer_widget.dart';

class FavoritesScreen extends StatefulWidget {
  final String? token;
  final User? userData;
  final Repository repository;

  final int? cartOrderItemsCount;

  const FavoritesScreen(
      {Key? key,
      required this.token,
      required this.userData,
      required this.repository,
      required this.cartOrderItemsCount})
      : super(key: key);
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<FavoritesScreen> {
  // for ios
  double productCellWidth = 190;
  double productCellHeight = 240;

  // for android
  //double productCellWidth = 160;
  //double productCellHeight = 240;

  late FavoritesCubit _favoritesCubit;
  late Favorite _favorites;

  void initState() {
    super.initState();
    _favoritesCubit = BlocProvider.of<FavoritesCubit>(context);
    _favoritesCubit.fetchFavorites(token: widget.token, user: widget.userData);
  }

  @override
  Widget build(BuildContext context) {
    SingletonCallbacks.refreshOrderCountCallBack = updateAfterReturn;
    return Scaffold(
        drawer: NavigationDrawerWidget(
            token: widget.token,
            userData: widget.userData,
            repository: widget.repository,
            cartOrderItemsCount: widget.cartOrderItemsCount),
        appBar: CustomAppBar(
            title: "Желаемые",
            favoriteIcon: Icons.favorite_outline,
            shoppingCartIcon: Icons.shopping_cart_outlined,
            settingsIcon: null,
            adminPanel: (widget.userData!.isAdmin != true)
                ? null
                : Icons.admin_panel_settings_outlined,
            token: widget.token,
            userData: widget.userData,
            repository: widget.repository,
            cartOrderItemsCount: widget.cartOrderItemsCount),
        body: BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              if (!(state is FavoritesLoaded)) {
            return Center(child: CircularProgressIndicator());
          }
          if ((state as FavoritesLoaded).favorites!.id == "error") {
            return _buildCartIsEmptyNotif();
          } else {
            _favorites = (state as FavoritesLoaded).favorites!;
          }

          _favorites = (state as FavoritesLoaded).favorites!;

          if(_favorites.products.length == 0) {
            return _buildCartIsEmptyNotif();
          }
          return GridView.builder(
              padding: EdgeInsets.symmetric(vertical: 15),
               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 20,
                      crossAxisCount: 2,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.5),
                    ),
              itemCount: _favorites.products.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildWomanProductContainer(
                    width: productCellWidth,
                    height: productCellHeight,
                    productInfo: _favorites.products[index],
                    imagePath: _favorites.products[index].image,
                    clothProductName: _favorites.products[index].name,
                    clothPrice: _favorites.products[index].price.toString(),
                    index: index);
              });
        }));
  }

  Widget _buildCartIsEmptyNotif() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Ваша корзина желаний пуста. Исправьте это :)",
            style: TextStyle(
                color: Color.fromRGBO(58, 67, 59, 1),
                fontFamily: 'Merriweather-Regular',
                fontSize: 16)),
        SizedBox(
          height: 8,
        ),
        OutlinedButton(
          child: Text('Перейти в магазин',
              style: TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(58, 67, 59, 1),
                  fontFamily: 'SolomonSans-SemiBold')),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BlocProvider(
                      create: (context) =>
                          CategoriesCubit(repository: widget.repository),
                      child: WomenScreen(
                          repository: widget.repository,
                          token: widget.token,
                          userData: widget.userData,
                          cartOrderItemsCount: widget.cartOrderItemsCount),
                    )));
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(width: 1.0, color: Color.fromRGBO(58, 67, 59, 1)),
          ),
        ),
      ],
    ));
  }

  Widget _buildWomanProductContainer({
    required double width,
    required double height,
    required Product productInfo,
    required String imagePath,
    required String clothProductName,
    required String clothPrice,
    required int index,
  }) {
    return InkWell(
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) =>
                ProductDetailCubit(repository: widget.repository),
            child: WomenProductScreen(
                productInfo: productInfo,
                token: widget.token,
                userData: widget.userData,
                repository: widget.repository,
                cartOrderItemsCount: widget.cartOrderItemsCount),
          ),
        ));
        setState(() {});
      },
      child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //alignment: WrapAlignment.center,
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: [
                    Container(
                        color: Colors.transparent,
                        child: (productInfo.id != '')
                            ? CachedNetworkImage(
                                cacheManager: CacheManager(Config(
                                    'customCacheKey',
                                    stalePeriod: Duration(days: 7))),
                                key: UniqueKey(),
                                imageUrl: imagePath,
                                fit: BoxFit.cover,
                                height: height,
                                width: width,
                                placeholder: (context, url) =>
                                    Container(color: Colors.grey),
                                memCacheHeight: 250,
                              )
                            : Image.file(
                                File(imagePath),
                                fit: BoxFit.cover,
                                height: height,
                                width: width,
                              )),
                    Positioned(
                      right: 5,
                      bottom: 5,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20,
                        child: IconButton(
                          alignment: Alignment.center,
                          icon: Icon(Icons.delete_outline,
                              size: 20, color: PRIMARY_DARK_COLOR),
                          onPressed: () => {
                            _favoritesCubit.deleteFavorite(token: widget.token, user: widget.userData, favoritedId: _favorites.id, itemToDelete: productInfo.id).then((value) => {
                              _favorites.products.removeAt(index),
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Удалено'),
                              duration: const Duration(seconds: 1),
                            )),
                            setState(() {

                            })

                            
                            }),
                            
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(clothProductName,
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                  )),
              OutlinedButton(
                child: Text(clothPrice,
                    style: TextStyle(
                        color: Color.fromRGBO(58, 67, 59, 1),
                        fontFamily: 'SolomonSans-SemiBold')),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) =>
                        ProductDetailCubit(repository: widget.repository),
                    child: WomenProductScreen(
                        productInfo: productInfo,
                        token: widget.token,
                        userData: widget.userData,
                        repository: widget.repository,
                        cartOrderItemsCount: widget.cartOrderItemsCount),
                  ),
                )),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      width: 1.0, color: Color.fromRGBO(58, 67, 59, 1)),
                ),
              ),
            ],
          )),
    );
  }

  void updateAfterReturn() {
    setState(() {});
  }
}
