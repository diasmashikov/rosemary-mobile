import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:rosemary/constants/colors.dart';
import 'package:rosemary/constants/responsive_ui.dart';
import 'package:rosemary/cubit/product_detail_cubit.dart';
import 'package:rosemary/cubit/products_cubit.dart';
import 'package:rosemary/data/models/order.dart';
import 'package:rosemary/data/models/product.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/screens/singleScreens/shopping_cart_screen.dart';
import 'package:rosemary/screens/womenScreens/women_products_screen.dart';
import 'package:rosemary/utils/widgets/custom_app_bar.dart';
import 'package:rosemary/utils/widgets/custom_drop_down.dart';
import 'package:rosemary/utils/singletons/singleton_callbacks.dart';
import 'package:rosemary/utils/singletons/singleton_order_count.dart';
import '../../navigation_drawer_widget.dart';
import '../singleScreens/favorites_screen.dart';

import 'package:sizer/sizer.dart';


class WomenProductScreen extends StatefulWidget {
  final Product productInfo;
  final String? token;
  final User? userData;
  final Repository repository;

  final int? cartOrderItemsCount;

  const WomenProductScreen(
      {Key? key,
      required this.productInfo,
      required this.token,
      required this.userData,
      required this.repository,
      required this.cartOrderItemsCount})
      : super(key: key);
  @override
  _WomenProductState createState() => _WomenProductState(this.productInfo);
}

class _WomenProductState extends State<WomenProductScreen> {
  Color _expansionTileTextColor = Color.fromRGBO(58, 67, 59, 1);

  final Product productInfo;

  String? _selectedSize;
  String _quantity = "1";
  bool noCartOrder = true;
  late Order cartOrder;
  int? _value;
  int? _cartOrderItemsCount;
  int _cartOrderItemsCounter = 0;

  Color _selectedColor = Color.fromRGBO(58, 67, 59, 1);

  // for ios
  double clothImageWidth = 400;
  double clothImageHeight = 380;

  // for android
  //double productCellHeight = 240;

  late ProductDetailCubit _productDetailCubit;

  _WomenProductState(this.productInfo);
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    print(widget.productInfo.images);
    widget.productInfo.images.insert(0, productInfo.image);
    _cartOrderItemsCount =
        SingletonOrderCount.orderCount! + _cartOrderItemsCounter;
    _productDetailCubit = BlocProvider.of<ProductDetailCubit>(context);
    _productDetailCubit.fetchCartOrder(
        token: widget.token, user: widget.userData, status: "Cart");
  }

  @override
  Widget build(BuildContext context) {
    SingletonCallbacks.refreshOrderCountCallBack = updateAfterReturn;
    _cartOrderItemsCount =
        SingletonOrderCount.orderCount! + _cartOrderItemsCounter;

    print(_cartOrderItemsCount);
    return Scaffold(
      drawer: NavigationDrawerWidget(
        token: widget.token,
        userData: widget.userData,
        cartOrderItemsCount: _cartOrderItemsCount,
        repository: widget.repository,
      ),
      appBar: CustomAppBar(
          title: "Женщины",
          favoriteIcon: Icons.favorite_outline,
          shoppingCartIcon: Icons.shopping_cart_outlined,
          settingsIcon: null,
          adminPanel: (widget.userData!.isAdmin != true)
              ? null
              : Icons.admin_panel_settings_outlined,
          token: widget.token,
          userData: widget.userData,
          repository: widget.repository,
          cartOrderItemsCount: SingletonOrderCount.orderCount),
      body: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
          if (!(state is ProductDetailLoaded)) {
            return Center(child: CircularProgressIndicator());
          }

          if ((state as ProductDetailLoaded).cartOrder != null) {
            noCartOrder = false;
            cartOrder = (state as ProductDetailLoaded).cartOrder!;
          }
          return Container(
            margin: EdgeInsets.symmetric(horizontal: APP_SCREEN_CONTENT_PADDING_H_WIDTH, vertical: APP_SCREEN_CONTENT_PADDING_V_WIDTH),
            child: ListView(children: [
              _buildClothImage(
                  width: 20.w,
                  height:  10.h,
                  imagePath: productInfo.image,
                  imagesPaths: productInfo.images,
                  context: context),
              SizedBox(
                height: 2.h,
              ),
              _buildClothName(context: context, clothName: productInfo.name),
              SizedBox(
                height: 1.h,
              ),
              _buildClothPrice(clothPrice: productInfo.price.toString()),
               SizedBox(
                height: 2.h,
              ),
              _buildColorName(clothColor: productInfo.color),
               SizedBox(
                height: 2.h,
              ),
              _buildSizePicker(clothSizes: productInfo.sizes),
              SizedBox(
                height: 2.h,
              ),
              _buildQuantityDropDown(),
               SizedBox(
                height: 2.h,
              ),
              _buildAddToCartButton(),
              SizedBox(
                height: 3.h,
              ),
              _buildExpansionTile(
                  title: "Описание", description: productInfo.description),
              Divider(color: Color.fromRGBO(58, 67, 59, 1)),
              _buildExpansionTile(
                  title: "Модель на фото",
                  description:
                      _convertJsonToString(productInfo.modelCharacteristics)),
              Divider(color: Color.fromRGBO(58, 67, 59, 1)),
              _buildExpansionTile(
                  title: "Материал", description: productInfo.material),
            ]),
          );
        },
      ),
    );
  }


  Widget _buildClothImage(
      {required double width,
      required double height,
      required String imagePath,
      required List<String> imagesPaths,
      required BuildContext context}) {
    print(imagePath);
    print(imagesPaths);
    return Column(children: [
      CarouselSlider(
        items: imagesPaths.map((imagePath) {
          return (productInfo.id != '')
              ? CachedNetworkImage(
                      cacheManager: CacheManager(Config('customCacheKey',
                          stalePeriod: Duration(days: 3))),
                      key: UniqueKey(),
                      imageUrl: imagePath,
                      fit: BoxFit.cover,
                  
                      width: double.maxFinite,
                      placeholder: (context, url) =>
                          Container(color: Color.fromRGBO(255,250,250, 0.5)),
                      memCacheHeight: 1000,
                    )
              : Image.file(File(imagePath),
                  height: height, width: width, fit: BoxFit.cover);
        }).toList(),
        carouselController: _controller,
        options: CarouselOptions(
            enlargeCenterPage: true,
            aspectRatio: 1.0,
            viewportFraction: 1,
            enableInfiniteScroll: false,
            initialPage: 0,
           ),
      ),
      SizedBox(
        height: 1.h,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: imagesPaths.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: 1.5.w,
              height: 1.5.h,
              margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.5.w),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : PRIMARY_DARK_COLOR)
                      .withOpacity(_current == entry.key ? 0.9 : 0.4)),
            ),
          );
        }).toList(),
      ),
    ]);
// finitie slider
    /*
    return Container(
      child: CarouselSlider(
          options: CarouselOptions(
            height: 400,
            aspectRatio: 2.0,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            initialPage: 0,
          ),
          items: imagesPaths.map((imagePath) {
            return (productInfo.id != '')
                ? Image.network(
                    imagePath,
                    height: height,
                    width: width,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(imagePath),
                    height: height,
                    width: width,
                    fit: BoxFit.cover,
                  );
          }).toList()),
    );
    */

    /*
    return CarouselSlider(
      options: CarouselOptions(height: 400.0),
      items: 
    );
    */

    /*
    Container(
        alignment: Alignment.center,
        height: height,
        width: width,
        child: (productInfo.id != '')
            ? Image.network(
                imagePath,
                height: height,
                width: width,
                fit: BoxFit.cover,
              )
            : Image.file(
                File(imagePath),
                height: height,
                width: width,
                fit: BoxFit.cover,
              ));
              */
  }

  Widget _buildClothName(
      {required String clothName, required BuildContext context}) {
    return Text(clothName,
        style: TextStyle(
          color: Color.fromRGBO(58, 67, 59, 1),
          fontFamily: 'Merriweather-Bold',
          fontSize: 13.sp,
        ));
  }

  Widget _buildClothPrice({required String clothPrice}) {
    return Text(
      clothPrice + " KZT",
      style: TextStyle(
          color: Color.fromRGBO(58, 67, 59, 1),
          fontFamily: 'SolomonSans-SemiBold',
          fontSize: 15.sp),
    );
  }

  Widget _buildColorName({required String clothColor}) {
    return Text(
      'Цвет: ' + clothColor,
      style: TextStyle(
          color: Color.fromRGBO(58, 67, 59, 1),
          fontFamily: 'Merriweather-Bold',
          fontSize:13.sp),
    );
  }

  Widget _buildSizePicker({required String clothSizes}) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter _setState) {
      return Wrap(
          alignment: WrapAlignment.start,
          spacing: 8.0, // gap between adjacent chips
          runSpacing: 4.0, // gap between lines
          children: clothSizes
              .split('/')
              .asMap()
              .entries
              .map((element) => _buildSizeRadioButton(
                  size: element.value,
                  setStatePicker: _setState,
                  index: element.key))
              .toList());
    });
  }

  Widget _buildSizeRadioButton(
      {required String size,
      required StateSetter setStatePicker,
      required int index}) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter _setState) {
      return OutlinedButton(
        child: Text(size,
            style: TextStyle(
                color: _value == index ? GOLD_COLOR : PRIMARY_DARK_COLOR,
                fontFamily: 'SolomonSans-SemiBold')),
        onPressed: () => setState(() {
          _value = index;
          _selectedSize = size;
          print(_selectedSize);
        }),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
              width: 0.2.w,
              color: _value == index ? GOLD_COLOR : PRIMARY_DARK_COLOR),
        ),
      );
    });
  }

  Widget _buildQuantityDropDown() {
    return Container(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Количество",
              style: TextStyle(
                  color: Color.fromRGBO(58, 67, 59, 1),
                  fontFamily: 'Merriweather-Bold',
                  fontSize: 13.sp)),
          SizedBox(
            height: 1.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 1.w),
            width: double.infinity,
            child: DropdownButton(
                isExpanded: true,
                value: _quantity,
                items: ["1", "2", "3", "4", "5"]
                    .map<DropdownMenuItem<String>>((element) {
                  return DropdownMenuItem<String>(
                    value: element,
                    child: Text(element,
                        style: TextStyle(
                            fontSize: 11.5.sp,
                            color: Color.fromRGBO(58, 67, 59, 1),
                            fontFamily: 'SolomonSans-SemiBold')),
                  );
                }).toList(),
                hint: Text("Выберите кол-во",
                    style: TextStyle(
                        fontSize: 11.5.sp,
                        color: Color.fromRGBO(58, 67, 59, 1),
                        fontFamily: 'SolomonSans-SemiBold')),
                onChanged: (element) {
                  setState(() {
                    _quantity = element as String;
                  });
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton() {
    return Container(
      height: 6.h,
      child: OutlinedButton(
        child: Text('Добавить в корзину',
            style: TextStyle(
                color: Color.fromRGBO(58, 67, 59, 1),
                fontFamily: 'SolomonSans-SemiBold')),
        onPressed: () {
          if (noCartOrder == true) {
            print("noCartOrder");
            if (_selectedSize != null) {
              _productDetailCubit
                  .postOrderCart(
                      token: widget.token,
                      user: widget.userData,
                      product: productInfo,
                      pickedSize: _selectedSize,
                      quantity: int.parse(_quantity))
                  .then((_) {
                _cartOrderItemsCounter = (_cartOrderItemsCounter + 1);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Продукт добавлен в корзину'),
                  duration: const Duration(seconds: 2),
                ));
                SingletonOrderCount.orderCount =
                    SingletonOrderCount.orderCount! + _cartOrderItemsCounter;
                Navigator.pop(context, () {
                  setState(() {});
                });
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Выберите размер'),
                duration: const Duration(seconds: 2),
              ));
            }
          } else {
            print("CartOrder");

            if (_selectedSize != null) {
              _productDetailCubit
                  .putOrderCart(
                      token: widget.token,
                      cartOrder: cartOrder,
                      user: widget.userData,
                      product: productInfo,
                      quantity: _quantity,
                      size: _selectedSize)
                  .then((_) {
                _cartOrderItemsCounter = (_cartOrderItemsCounter + 1);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Продукт добавлен в корзину'),
                  duration: const Duration(seconds: 2),
                ));
                SingletonOrderCount.orderCount =
                    SingletonOrderCount.orderCount! + _cartOrderItemsCounter;
                Navigator.pop(context, () {});
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Выберите размер'),
                duration: const Duration(seconds: 2),
              ));
            }
          }
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(width: 0.2.w, color: Color.fromRGBO(58, 67, 59, 1)),
        ),
      ),
    );
  }

  _convertJsonToString(jsonObject) {
    return "Рост модели: " +
        jsonObject.modelHeight.toString() +
        " см" +
        "\n\nВес модели: " +
        jsonObject.modelWeight.toString() +
        " кг" +
        "\n\nРазмер на модели: " +
        jsonObject.modelSize;
  }

  Widget _buildExpansionTile(
      {required String title, required String description}) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
          tilePadding: EdgeInsets.all(0),
          onExpansionChanged: (expanded) {
            setState(() {
              if (expanded) {
                _expansionTileTextColor = Color.fromRGBO(58, 67, 59, 1);
              } else {
                _expansionTileTextColor = Color.fromRGBO(58, 67, 59, 1);
              }
            });
          },
          iconColor: _expansionTileTextColor,
          title: Text(
            title,
            style: TextStyle(
                color: _expansionTileTextColor,
                fontFamily: 'Merriweather-Bold',
                fontSize: 11.5.sp),
          ),
          children: <Widget>[
            ListTile(
                title: Text(
              description,
              style: TextStyle(
                  color: _expansionTileTextColor,
                  fontFamily: 'Merriweather-Regular',
                  fontSize: 11.5.sp),
            ))
          ]),
    );
  }

  

  void updateAfterReturn() {
    setState(() {});
  }
}
