import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosemary/cubit/categories_cubit.dart';
import 'package:rosemary/cubit/place_order_cubit.dart';
import 'package:rosemary/cubit/shopping_cart_cubit.dart';
import 'package:rosemary/data/models/order.dart';
import 'package:rosemary/data/models/orderItem.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/screens/paymentScreens/place_order_screen.dart';
import 'package:rosemary/screens/womenScreens/women_screen.dart';
import 'package:rosemary/utils/singletons/singleton_callbacks.dart';
import 'package:rosemary/utils/singletons/singleton_order_count.dart';
import '../../navigation_drawer_widget.dart';

import 'package:sizer/sizer.dart';

class ShoppingCartScreen extends StatefulWidget {
  final String? token;
  final User? userData;
  final Repository repository;

  final int? cartOrderItemsCount;

  ShoppingCartScreen(
      {required this.token,
      required this.userData,
      required this.repository,
      required this.cartOrderItemsCount});

  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  double clothImageWidth = 150;
  double clothImageHeight = 190;

  late Order _shoppingCartOrder;
  late Order shoppingCartOrderCopy;
  late List<OrderItem> shoppingCartItems;
  late ShoppingCartCubit _shoppingCartCubit;
  late int _totalOrder;
  late List<OrderItem> orderItemsCopy;
  int _totalOrderMinus = 0;

  @override
  void initState() {
    super.initState();
    _shoppingCartCubit = BlocProvider.of<ShoppingCartCubit>(context);
    _shoppingCartCubit.fetchShoppingCartItems(
        token: widget.token, userId: widget.userData!.id);
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
        appBar: AppBar(
            centerTitle: false,
            title: Text("Корзина",
                style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular'))),
        body: BlocBuilder<ShoppingCartCubit, ShoppingCartState>(
          builder: (context, state) {
            if (!(state is ShoppingCartLoaded)) {
              return Center(child: CircularProgressIndicator());
            }

            if ((state as ShoppingCartLoaded).shoppingCartItems == null) {
              return _buildCartIsEmptyNotif();
            } else {
              _shoppingCartOrder =
                  (state as ShoppingCartLoaded).shoppingCartItems!;
              shoppingCartItems = _shoppingCartOrder.orderItems;
              _totalOrder = _shoppingCartOrder.totalPrice;
            }

            print(
                shoppingCartItems.length.toString() + " SHOPPING CART LENGTH");

            return (_shoppingCartOrder.orderItems.length >= 1)
                ? Column(children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(0),
                        itemCount: shoppingCartItems.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          print(index.toString() + " INDEX FROM LISTVIEW");
                          if (index == shoppingCartItems.length) {
                            return _buildTotalOrder(
                                totalPrice: (_totalOrder - _totalOrderMinus)
                                    .toString());
                          }
                          return Column(
                            children: [
                              _buildCartItem(
                                  width: 30.w,
                                  height: 55.w,
                                  imagePath:
                                      shoppingCartItems[index].product.image,
                                  context: context,
                                  clothName:
                                      shoppingCartItems[index].product.name,
                                  colorName:
                                      shoppingCartItems[index].product.color,
                                  size: shoppingCartItems[index].pickedSize,
                                  count: shoppingCartItems[index]
                                      .quantity
                                      .toString(),
                                  clothPrice: shoppingCartItems[index]
                                      .product
                                      .price
                                      .toString(),
                                  orderItemId: shoppingCartItems[index].id,
                                  index: index),
                              Divider(color: Color.fromRGBO(58, 67, 59, 1)),
                            ],
                          );
                        },
                      ),
                    ),
                  ])
                : _buildCartIsEmptyNotif();
          },
        ));
  }

  Widget _buildCartIsEmptyNotif() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Ваша корзина пуста",
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

  Widget _buildCartItem(
      {required double width,
      required double height,
      required String imagePath,
      required String clothName,
      required String colorName,
      required String? size,
      required String count,
      required String clothPrice,
      required BuildContext context,
      required String orderItemId,
      required int index}) {
    return Container(
      margin:
          EdgeInsets.only(top: 1.5.h, left: 4.w, right: 4.w, bottom: 0.75.h),
      height: 30.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            child: Image.network(
              imagePath,
              height: 40.h,
              width: 40.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 3.5.w,
          ),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildClothName(clothName: clothName, context: context),

                  _buildColorName(colorName: colorName),

                  _buildSizeType(size: size),

                  _buildCount(count: count),

                  _buildClothPrice(clothPrice: clothPrice, count: count),
                  //const SizedBox(height: 80)
                ],
              ),
            ),
          ),
          IconButton(
            alignment: Alignment.bottomRight,
            iconSize: 8.w,
            icon: Icon(Icons.delete, color: Color.fromRGBO(58, 67, 59, 1)),
            onPressed: () => {
              // making copy to delete items
              orderItemsCopy = _shoppingCartOrder.orderItems
                  .map((item) => OrderItem(
                      id: item.id,
                      product: item.product,
                      pickedSize: item.pickedSize,
                      quantity: item.quantity))
                  .toList(),
              shoppingCartOrderCopy = Order(
                  orderItems: orderItemsCopy,
                  city: _shoppingCartOrder.city,
                  shippingAddress: _shoppingCartOrder.shippingAddress,
                  zip: _shoppingCartOrder.zip,
                  country: _shoppingCartOrder.country,
                  phone: _shoppingCartOrder.phone,
                  status: _shoppingCartOrder.status,
                  totalPrice: _shoppingCartOrder.totalPrice,
                  user: _shoppingCartOrder.user,
                  id: _shoppingCartOrder.id),
              print(index.toString() + " THAT IS INDEX I CLICKED"),
              _totalOrderMinus = (shoppingCartItems[index].quantity *
                  shoppingCartItems[index].product.price),
              if (_shoppingCartOrder.orderItems.length == 1)
                {_buildCartIsEmptyNotif()}
              else if (_shoppingCartOrder.orderItems.length > 1)
                {shoppingCartItems.removeAt(index)},
              _shoppingCartCubit
                  .deleteShoppingCartItem(
                      token: widget.token,
                      userId: widget.userData!.id,
                      shoppingCartOrder: shoppingCartOrderCopy,
                      index: index,
                      orderItemId: orderItemId,
                      changedTotalPrice: _totalOrder - _totalOrderMinus)
                  .then((_) {
                print("LOL BLYAAAAAAAA");
                print(shoppingCartItems.length.toString() + " PENNIS");

                SingletonOrderCount.orderCount =
                    SingletonOrderCount.orderCount! - 1;
                ;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Удалено'),
                  duration: const Duration(seconds: 2),
                ));

                setState(() {});
              })
            },
          ),
        ],
      ),
    );
  }

  Widget _buildClothName(
      {required String clothName, required BuildContext context}) {
    return Text(clothName,
        style: TextStyle(
          color: Color.fromRGBO(58, 67, 59, 1),
          fontFamily: 'Merriweather-Regular',
          fontSize: 11.5.sp,
        ));
  }

  Widget _buildColorName({required String colorName}) {
    return Text(
      colorName,
      style: TextStyle(
          color: Color.fromRGBO(58, 67, 59, 1),
          fontFamily: 'Merriweather-Regular',
          fontSize: 11.5.sp),
    );
  }

  Widget _buildSizeType({required String? size}) {
    var text = 'Размер: ' + size!;
    return Text(
      text,
      style: TextStyle(
          color: Color.fromRGBO(58, 67, 59, 1),
          fontFamily: 'Merriweather-Regular',
          fontSize: 11.5.sp),
    );
  }

  Widget _buildCount({required String count}) {
    var text = 'Кол-во: ' + count;
    return Text(
      text,
      style: TextStyle(
          color: Color.fromRGBO(58, 67, 59, 1),
          fontFamily: 'Merriweather-Regular',
          fontSize: 11.5.sp),
    );
  }

  Widget _buildClothPrice({required String clothPrice, required String count}) {
    return Text(
      (int.parse(clothPrice) * int.parse(count)).toString(),
      style: TextStyle(
          color: Color.fromRGBO(58, 67, 59, 1),
          fontFamily: 'SolomonSans-SemiBold',
          fontSize: 13.sp),
    );
  }

  Widget _buildTotalOrder({required String totalPrice}) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Итого к оплате: ",
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 11.5.sp,
                  )),
              Text(
                totalPrice,
                style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 13.sp),
              )
            ],
          ),
          SizedBox(
            height: 2.h,
          ),
          Container(
            width: double.infinity,
            height: 5.h,
            child: OutlinedButton(
              child: Text('Оплатить',
                  style: TextStyle(
                      fontSize: 11.5.sp,
                      color: Color.fromRGBO(58, 67, 59, 1),
                      fontFamily: 'SolomonSans-SemiBold')),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) =>
                        PlaceOrderCubit(repository: widget.repository),
                    child: PlaceOrderScreen(
                        token: widget.token,
                        userData: widget.userData,
                        repository: widget.repository,
                        shoppingCartOrder: _shoppingCartOrder,
                        cartOrderItemsCount: widget.cartOrderItemsCount),
                  ),
                ));
                SingletonCallbacks.refreshOrderCountCallBack();
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                    width: 0.2.w, color: Color.fromRGBO(58, 67, 59, 1)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  void updateAfterReturn() {
    print("DALALBAPLSAKDAS");
    setState(() {});
  }
}
