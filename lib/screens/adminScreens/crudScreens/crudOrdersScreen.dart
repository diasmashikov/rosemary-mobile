import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosemary/constants/colors.dart';
import 'package:rosemary/constants/responsive_ui.dart';
import 'package:rosemary/cubit/crudCubits/crud_orders_cubit.dart';
import 'package:rosemary/data/models/order.dart';
import 'package:rosemary/data/models/orderItem.dart';
import 'package:rosemary/data/models/ordersInProgress.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/screens/adminScreens/crudScreens/ordersListView.dart';
import 'package:rosemary/utils/widgets/google_maps_widget.dart';
import 'package:rosemary/utils/widgets/orders_app_bar.dart';
import 'package:rosemary/utils/singletons/singleton_orders.dart';
import 'package:rosemary/utils/singletons/singleton_shop_data.dart';
import 'package:timezone/standalone.dart' as tz1;
import 'package:timezone/data/latest.dart' as tz;
import 'package:rosemary/utils/widgets/custom_app_bar.dart';
import 'package:timezone/timezone.dart';
import 'package:geocoding/geocoding.dart' as gc;
import 'package:map_launcher/map_launcher.dart';

import '../../../navigation_drawer_widget.dart';
import 'package:sizer/sizer.dart';

class crudOrdersScreen extends StatefulWidget {
  final String? token;
  final User? userData;
  final Repository repository;

  const crudOrdersScreen(
      {Key? key,
      required this.token,
      required this.userData,
      required this.repository})
      : super(key: key);
  @override
  _crudOrdersScreenState createState() => _crudOrdersScreenState();
}

class _crudOrdersScreenState extends State<crudOrdersScreen>
    with AutomaticKeepAliveClientMixin {
  // for ios
  double clothImageWidth = 400;
  double clothImageHeight = 380;
  double verticalMargin = 40;

  String chosenStatus = "";

  late TZDateTime dateAndTimeInAlmaty;

  late CrudOrdersCubit _crudOrdersCubit;
  Color _expansionTileTextColor = Color.fromRGBO(58, 67, 59, 1);
  OrdersInProgress? orders;

  TextEditingController _orderListPendingController = TextEditingController();
  TextEditingController _orderListShippingController = TextEditingController();
  TextEditingController _orderListShippedController = TextEditingController();

  // for android
  //double productCellWidth = 160;
  //double productCellHeight = 240;
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    //tz.initializeTimeZones();
    //var almaty = tz1.getLocation("Asia/Almaty");
    //dateAndTimeInAlmaty = tz1.TZDateTime.now(almaty);
    print("ONCE UPON A TIME");
    _crudOrdersCubit = BlocProvider.of<CrudOrdersCubit>(context);
    //_crudOrdersCubit.fetchOrdersInProgress(
    //token: widget.token, dateAndTime: dateAndTimeInAlmaty);
  }

/*
  CustomAppBar(
            title: "Заказы",
            favoriteIcon: null,
            shoppingCartIcon: null,
            settingsIcon: null,
            adminPanel: null,
            cartOrderItemsCount: 0,
            token: widget.token,
            userData: widget.userData,
            repository: widget.repository),
            */

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        drawer: NavigationDrawerWidget(
            token: widget.token,
            userData: widget.userData,
            repository: widget.repository,
            cartOrderItemsCount: 0),
        appBar: OrdersAppBar(user: widget.userData),
        body: BlocBuilder<CrudOrdersCubit, CrudOrdersState>(
          builder: (context, state) {
            /*
            if (!(state is CrudOrdersLoaded)) {
              return Center(child: CircularProgressIndicator());
            }
            */

            orders = SingletonShopData.orders!;
            // (state as CrudOrdersLoaded).ordersInProgress;

            SingletonOrders.orders = orders;

            return DefaultTabController(
                length: 3,
                child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: APP_SCREEN_CONTENT_PADDING_H_WIDTH,
                        vertical: APP_SCREEN_CONTENT_PADDING_V_WIDTH),
                    child: Column(
                      children: [
                        TabBar(indicatorColor: PRIMARY_DARK_COLOR, tabs: [
                          Tab(
                            child: Text(
                                "Подготовка" +
                                    "(" +
                                    orders!.orderListPending.length.toString() +
                                    ")",
                                style: TextStyle(
                                  color: Color.fromRGBO(58, 67, 59, 1),
                                  fontFamily: 'Merriweather-Bold',
                                  fontSize: 7.sp,
                                )),
                          ),
                          Tab(
                            child: Text(
                                "Доставка  " +
                                    "(" +
                                    orders!.orderListShipping.length
                                        .toString() +
                                    ")",
                                style: TextStyle(
                                  color: Color.fromRGBO(58, 67, 59, 1),
                                  fontFamily: 'Merriweather-Bold',
                                  fontSize: 7.sp,
                                )),
                          ),
                          Tab(
                            child: Text(
                                "Доставлено " +
                                    "(" +
                                    orders!.orderListShipped.length.toString() +
                                    ")",
                                style: TextStyle(
                                  color: Color.fromRGBO(58, 67, 59, 1),
                                  fontFamily: 'Merriweather-Bold',
                                  fontSize: 7.sp,
                                )),
                          )
                        ]),
                        SizedBox(
                          height: 1.h,
                        ),
                        Expanded(
                          child: TabBarView(children: [
                            GetListView(
                                orders: orders!.orderListPending,
                                buildContainer: _buildOrderContainer,
                                userData: widget.userData,
                                controller: _orderListPendingController,
                                orderType: "Подготавливается"),
                            GetListView(
                                orders: orders!.orderListShipping,
                                buildContainer: _buildOrderContainer,
                                userData: widget.userData,
                                controller: _orderListShippingController,
                                orderType: "Доставляется"),
                            GetListView(
                                orders: orders!.orderListShipped,
                                buildContainer: _buildOrderContainer,
                                userData: widget.userData,
                                controller: _orderListShippedController,
                                orderType: "Доставлено")
                          ]),
                        ),
                      ],
                    )));
          },
        ));
  }

  String chooseStatus(status) {
    if (status == "Pending") {
      return "Подготавливается";
    } else if (status == "Shipping") {
      return "Доставляется";
    } else if (status == "Shipped") {
      return "Доставлен";
    } else if (status == "Подготавливается") {
      return "Подготавливается";
    } else if (status == "Доставляется") {
      return "Доставляется";
    } else if (status == "Доставлен") {
      return "Доставлен";
    } else if (status == "Отменено") {
      return "Отменено";
    } else {
      return "";
    }
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
      onTap: () {
        displayDialogMenu(context, "Изменить статус", _crudOrdersCubit,
            widget.token!, orderId, index, orderStatus, orders);
      },
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

  void displayDialogMenu(
      BuildContext context,
      String title,
      CrudOrdersCubit crudOrdersCubit,
      String token,
      String orderId,
      int index,
      String orderStatus,
      OrdersInProgress? orders) {
    print("PIDARAAAAS");
    print(orders);
    chosenStatus = orderStatus;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text(title),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter _setState) {
            return SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    final availableMaps = await MapLauncher.installedMaps;

                    List<gc.Location> locations =
                        await gc.locationFromAddress("Розыбакиева, 289/2");

                    var latitude = locations[0].latitude;
                    var longitude = locations[0].longitude;

                    print(latitude);
                    print(longitude);

                    // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

                    for (AvailableMap map in availableMaps) {
                      if (map.mapName == "2GIS") {
                        map.showDirections(
                          destination: Coords(latitude, longitude),
                        );
                      }
                    }
                  },
                  child: Text("Track"),
                ),
                SizedBox(
                  height: 10,
                ),
                Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 8.0, // gap between adjacent chips
                    runSpacing: 20.0, // gap between lines
                    children: [
                      'Подготавливается',
                      'Доставляется',
                      'Доставлен',
                      'Отменено'
                    ]
                        .asMap()
                        .entries
                        .map((element) => InkWell(
                              onTap: () {
                                chosenStatus = element.value;
                                _setState(() {});
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: defineStatus(element.value),
                                    size: 24,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(element.value,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color.fromRGBO(58, 67, 59, 1),
                                          fontFamily: 'SolomonSans-SemiBold',
                                          fontSize: 16)),
                                ],
                              ),
                            ))
                        .toList()),
                SizedBox(
                  height: 20,
                ),
                OutlinedButton(
                  child: Text('Обновить статус на ' + chosenStatus,
                      style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(58, 67, 59, 1),
                          fontFamily: 'SolomonSans-SemiBold')),
                  onPressed: () {
                    crudOrdersCubit
                        .updateOrderStatus(token, orderId, chosenStatus)
                        .then((_) {
                      Navigator.of(context).pop();
                      switchOrderByStatus(orderStatus, index);
                      setState(() {});
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        width: 1.0, color: Color.fromRGBO(58, 67, 59, 1)),
                  ),
                )
              ],
            ));
          })),
    );
  }

  void switchOrderByStatus(String orderStatus, int index) {
    print(orderStatus + " DEBAGGA SYKA");
    print(chosenStatus + " DEBAGGA SYKA2");

    if (orderStatus == "Подготавливается") {
      orders!.orderListPending[index].status = chosenStatus;
      if (chosenStatus == "Подготавливается") {
      } else if (chosenStatus == "Доставляется") {
        orders!.orderListShipping.add(orders!.orderListPending[index]);
        orders!.orderListPending.removeAt(index);
      } else if (chosenStatus == "Доставлен") {
        orders!.orderListShipped.add(orders!.orderListPending[index]);
        print("REMOVE WEKA");
        orders!.orderListPending.removeAt(index);
      }
    } else if (orderStatus == "Доставляется") {
      orders!.orderListShipping[index].status = chosenStatus;
      if (chosenStatus == "Подготавливается") {
        orders!.orderListPending.add(orders!.orderListShipping[index]);
        orders!.orderListShipping.removeAt(index);
      } else if (chosenStatus == "Доставляется") {
      } else if (chosenStatus == "Доставлен") {
        orders!.orderListShipped.add(orders!.orderListShipping[index]);
        orders!.orderListShipping.removeAt(index);
      }
    } else if (orderStatus == "Доставлен") {
      orders!.orderListShipped[index].status = chosenStatus;
      if (chosenStatus == "Подготавливается") {
        orders!.orderListPending.add(orders!.orderListShipped[index]);
        orders!.orderListShipped.removeAt(index);
      } else if (chosenStatus == "Доставляется") {
        orders!.orderListShipping.add(orders!.orderListShipped[index]);
        orders!.orderListShipped.removeAt(index);
      } else if (chosenStatus == "Доставлен") {}
    }
  }
}
