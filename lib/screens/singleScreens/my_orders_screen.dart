import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosemary/constants/colors.dart';
import 'package:rosemary/constants/responsive_ui.dart';
import 'package:rosemary/cubit/contacts_cubit.dart';
import 'package:rosemary/cubit/my_orders_cubit.dart';
import 'package:rosemary/data/models/contact.dart';
import 'package:rosemary/data/models/myOrders.dart';
import 'package:rosemary/data/models/orderItem.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/screens/adminScreens/crudScreens/ordersListView.dart';
import 'package:rosemary/screens/singleScreens/shopping_cart_screen.dart';
import 'package:rosemary/utils/widgets/custom_app_bar.dart';
import 'package:rosemary/utils/singletons/singleton_callbacks.dart';
import 'package:rosemary/utils/singletons/singleton_order_count.dart';
import 'package:rosemary/utils/singletons/singleton_shop_data.dart';
import 'package:rosemary/utils/text_form_field_post.dart';

import 'package:url_launcher/link.dart';

import '../../navigation_drawer_widget.dart';
import 'favorites_screen.dart';

import 'package:sizer/sizer.dart';

class MyOrdersScreen extends StatefulWidget {
  final String? token;
  final User? userData;
  final Repository repository;

  final int? cartOrderItemsCount;

  const MyOrdersScreen({
    Key? key,
    required this.token,
    required this.userData,
    required this.repository,
    required this.cartOrderItemsCount,
  }) : super(key: key);
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  // for ios
  double clothImageWidth = 400;
  double clothImageHeight = 380;
  double verticalMargin = 40;

  Color _expansionTileTextColor = Color.fromRGBO(58, 67, 59, 1);

  TextEditingController _activeOrdersController = TextEditingController();
  TextEditingController _historyOrdersController = TextEditingController();

  late MyOrdersCubit _myOrdersCubit;
  late MyOrders myOrders;

  @override
  void initState() {
    super.initState();
    _myOrdersCubit = BlocProvider.of<MyOrdersCubit>(context);
  }

  // for android
  //double productCellWidth = 160;
  //double productCellHeight = 240;
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
            title: "Мои заказы",
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
        body: BlocBuilder<MyOrdersCubit, MyOrdersState>(
          builder: (context, state) {
            myOrders = SingletonShopData.myOrders!;
            return DefaultTabController(
                length: 2,
                child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    child: Column(
                      children: [
                        TabBar(indicatorColor: PRIMARY_DARK_COLOR, tabs: [
                          Tab(
                            child: Text(
                                "Текущие" +
                                    "(" +
                                    myOrders.activeOrders.length.toString() +
                                    ")",
                                style: TextStyle(
                                  color: Color.fromRGBO(58, 67, 59, 1),
                                  fontFamily: 'Merriweather-Bold',
                                  fontSize: 9.sp,
                                )),
                          ),
                          Tab(
                            child: Text(
                                "Завершенные  " +
                                    "(" +
                                    myOrders.historyOrders.length.toString() +
                                    ")",
                                style: TextStyle(
                                  color: Color.fromRGBO(58, 67, 59, 1),
                                  fontFamily: 'Merriweather-Bold',
                                  fontSize: 9.sp,
                                )),
                          ),
                        ]),
                        SizedBox(
                          height: 1.h,
                        ),
                        Expanded(
                          child: TabBarView(children: [
                            GetListView(
                                orders: myOrders.activeOrders,
                                buildContainer: _buildOrderContainer,
                                userData: widget.userData,
                                controller: _activeOrdersController,
                                orderType: "Активные"),
                            GetListView(
                                orders: myOrders.historyOrders,
                                buildContainer: _buildOrderContainer,
                                userData: widget.userData,
                                controller: _historyOrdersController,
                                orderType: "Завершенные"),
                          ]),
                        ),
                      ],
                    )));
          },
        ));
  }

  Widget _buildOrderContainer(
      {required String customerName,
      required String orderNumber,
      required String orderStatus,
      required String city,
      required String street,
      required String homeNumber,
      required String productName,
      required String quantity,
      required String size,
      required String color,
      required String phone,
      required List<OrderItem> orderItems,
      required int index,
      required String orderId}) {
    return InkWell(
      onTap: () {},
      child: Card(
        child: Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.symmetric(
              horizontal: APP_SCREEN_CONTENT_PADDING_H_WIDTH,
              vertical: APP_SCREEN_CONTENT_PADDING_V_WIDTH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                      orderNumber +
                          " - " +
                          customerName +
                          " - " +
                          city +
                          " - " +
                          street +
                          ", " +
                          homeNumber,
                      style: TextStyle(
                          color: Color.fromRGBO(58, 67, 59, 1),
                          fontFamily: 'SolomonSans-SemiBold',
                          fontSize: 9.sp))
                ],
              ),
              _buildOrderItems(orderItems),
              Text(phone,
                  style: TextStyle(
                      color: Color.fromRGBO(58, 67, 59, 1),
                      fontFamily: 'SolomonSans-SemiBold',
                      fontSize: 11.5.sp)),
              SizedBox(
                height: 2.5.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.circle,
                    color: defineStatus(orderStatus),
                    size: 5.5.w,
                  ),
                  SizedBox(
                    width: 1.w,
                  ),
                  Text(orderStatus,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(58, 67, 59, 1),
                          fontFamily: 'SolomonSans-SemiBold',
                          fontSize: 11.sp)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItems(orderItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: StatefulBuilder(builder: (_context, _setState) {
            return InkWell(
              child: ExpansionTile(
                tilePadding: EdgeInsets.all(0),
                onExpansionChanged: (expanded) {
                  _setState(() {
                    if (expanded) {
                      _expansionTileTextColor = Color.fromRGBO(58, 67, 59, 1);
                    } else {
                      _expansionTileTextColor = Color.fromRGBO(58, 67, 59, 1);
                    }
                  });
                },
                iconColor: _expansionTileTextColor,
                title: Text(
                  "Товары на заказ" +
                      " (" +
                      orderItems.length.toString() +
                      " штук)",
                  style: TextStyle(
                      color: _expansionTileTextColor,
                      fontFamily: 'SolomonSans-SemiBold',
                      fontSize: 11.5.sp),
                ),
                expandedAlignment: Alignment.topLeft,
                children: <Widget>[
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: orderItems
                          .map<Widget>(
                              (orderItem) => _buildOrderItem(orderItem))
                          .toList()),
                ],
              ),
            );
          }),
        ),
        SizedBox(
          height: 1.h,
        )
      ],
    );
  }

  Widget _buildOrderItem(orderItem) {
    return Column(
      children: [
        Text(
            orderItem.product.name +
                " - " +
                orderItem.quantity.toString() +
                " штук" +
                " - " +
                orderItem.pickedSize.toString() +
                " - " +
                orderItem.product.color,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Color.fromRGBO(58, 67, 59, 1),
                fontFamily: 'SolomonSans-SemiBold',
                fontSize: 10.sp)),
        SizedBox(
          height: 1.h,
        )
      ],
    );
  }

  Color? defineStatus(orderStatus) {
    if (orderStatus == "Доставлен") {
      return SHIPPED_COLOR;
    } else if (orderStatus == "Доставляется") {
      return SHIPPING_COLOR;
    } else if (orderStatus == "Подготавливается") {
      return PENDING_COLOR;
    } else if (orderStatus == "Отменено") {
      return Colors.black;
    }
  }

  void updateAfterReturn() {
    setState(() {});
  }
}
