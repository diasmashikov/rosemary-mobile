import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:rosemary/constants/colors.dart';
import 'package:rosemary/constants/responsive_ui.dart';
import 'package:rosemary/cubit/info_cubit.dart';
import 'package:rosemary/cubit/place_order_cubit.dart';
import 'package:rosemary/cubit/product_detail_cubit.dart';
import 'package:rosemary/cubit/shipping_address_cubit.dart';
import 'package:rosemary/data/models/order.dart';
import 'package:rosemary/data/models/orderItem.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/screens/paymentScreens/info_screen.dart';
import 'package:rosemary/screens/paymentScreens/shipping_screen.dart';
import 'package:rosemary/utils/singletons/singleton_callbacks.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../navigation_drawer_widget.dart';
import '../main_screen.dart';

import 'package:sizer/sizer.dart';


class PlaceOrderScreen extends StatefulWidget {
  final String? token;
  final User? userData;
  final Repository repository;
  final Order shoppingCartOrder;

  final int? cartOrderItemsCount;

  const PlaceOrderScreen(
      {Key? key,
      required this.token,
      required this.userData,
      required this.repository,
      required this.shoppingCartOrder,
      required this.cartOrderItemsCount})
      : super(key: key);

  @override
  _PlaceOrderScreenState createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  double clothImageWidth = 150;
  double clothImageHeight = 190;

  String chosenStatus = "Kaspi перевод";

  late PlaceOrderCubit _placeOrderCubit;

  @override
  void initState() {
    super.initState();
    _placeOrderCubit = BlocProvider.of<PlaceOrderCubit>(context);
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
            title: Text("Покупка",
                style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular'))),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: APP_SCREEN_CONTENT_PADDING_H_WIDTH, vertical: APP_SCREEN_CONTENT_PADDING_V_WIDTH),
          child: ListView(
            children: [
              _buildMyInformationSection(),
              Divider(color: Color.fromRGBO(58, 67, 59, 1)),
              _buildShippingSection(),
              Divider(color: Color.fromRGBO(58, 67, 59, 1)),
              _buildPaymentMethodSection(),
              Divider(color: Color.fromRGBO(58, 67, 59, 1)),
              _buildOrderDetailsSection(),
              Divider(color: Color.fromRGBO(58, 67, 59, 1)),
              _buildOrderFinancials(),
              Divider(color: Color.fromRGBO(58, 67, 59, 1)),
              _buildOrderFinancialsTotals(),
            ],
          ),
        ));
  }

  Widget _buildMyInformationSection() {
    return InkWell(
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => (BlocProvider(
            create: (context) => InfoCubit(repository: widget.repository),
            child: InfoScreen(
                token: widget.token,
                userData: widget.userData,
                repository: widget.repository,
                cartOrderItemsCount: widget.cartOrderItemsCount),
          )),
        ));
        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: APP_SCREEN_CONTENT_PADDING_V_WIDTH),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Моя информация",
                    style: TextStyle(
                      color: Color.fromRGBO(58, 67, 59, 1),
                      fontFamily: 'Merriweather-Bold',
                      fontSize: 13.sp,
                    )),
                SizedBox(
                  height: 2.h,
                ),
                Text(widget.userData!.name,
                    style: TextStyle(
                      color: Color.fromRGBO(58, 67, 59, 1),
                      fontFamily: 'Merriweather-Regular',
                      fontSize: 11.5.sp,
                    )),
                SizedBox(
                  height: 0.5.h,
                ),
                Text(widget.userData!.email,
                    style: TextStyle(
                      color: Color.fromRGBO(58, 67, 59, 1),
                      fontFamily: 'Merriweather-Regular',
                      fontSize: 11.5.sp,
                    )),
                SizedBox(
                  height: 0.5.h,
                ),
                Text(widget.userData!.phone,
                    style: TextStyle(
                      color: Color.fromRGBO(58, 67, 59, 1),
                      fontFamily: 'Merriweather-Regular',
                      fontSize: 11.5.sp,
                    )),
              ],
            ),
            Spacer(),
            IconButton(
                icon: Icon(Icons.arrow_right,
                    size: 10.w, color: Color.fromRGBO(58, 67, 59, 1)),
                onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingSection() {
    return InkWell(
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => (BlocProvider(
            create: (context) =>
                ShippingAddressCubit(repository: widget.repository),
            child: ShippingAddressScreen(
                token: widget.token,
                userData: widget.userData,
                repository: widget.repository,
                cartOrderItemsCount: widget.cartOrderItemsCount),
          )),
        ));
        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: APP_SCREEN_CONTENT_PADDING_V_WIDTH),
        child: Row(
          children: [
            (widget.userData!.street != "temporary" ||
                    widget.userData!.zip != "temporary" ||
                    widget.userData!.city != "temporary" ||
                    widget.userData!.country != "temporary" ||
                    widget.userData!.region != "temporary")
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text("Адрес доставки",
                            style: TextStyle(
                              color: Color.fromRGBO(58, 67, 59, 1),
                              fontFamily: 'Merriweather-Bold',
                              fontSize: 13.sp,
                            )),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(widget.userData!.name,
                            style: TextStyle(
                              color: Color.fromRGBO(58, 67, 59, 1),
                              fontFamily: 'Merriweather-Regular',
                              fontSize: 11.5.sp,
                            )),
                        SizedBox(
                          height: 1.h,
                        ),
                        Text(widget.userData!.street,
                            style: TextStyle(
                              color: Color.fromRGBO(58, 67, 59, 1),
                              fontFamily: 'Merriweather-Regular',
                              fontSize: 11.5.sp,
                            )),
                        SizedBox(
                          height: 1.h,
                        ),
                        Text(
                            widget.userData!.region +
                                ", " +
                                widget.userData!.city,
                            style: TextStyle(
                              color: Color.fromRGBO(58, 67, 59, 1),
                              fontFamily: 'Merriweather-Regular',
                              fontSize: 11.5.sp,
                            )),
                        SizedBox(
                          height: 1.h,
                        ),
                        Text(widget.userData!.zip,
                            style: TextStyle(
                              color: Color.fromRGBO(58, 67, 59, 1),
                              fontFamily: 'Merriweather-Regular',
                              fontSize: 11.5.sp,
                            )),
                        SizedBox(
                          height: 1.h,
                        ),
                        Text(widget.userData!.country,
                            style: TextStyle(
                              color: Color.fromRGBO(58, 67, 59, 1),
                              fontFamily: 'Merriweather-Regular',
                              fontSize: 11.5.sp,
                            )),
                      ])
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text("Адрес доставки",
                            style: TextStyle(
                              color: Color.fromRGBO(58, 67, 59, 1),
                              fontFamily: 'Merriweather-Bold',
                              fontSize: 13.sp,
                            )),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text("Не хватает информации",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: PENDING_COLOR,
                              fontFamily: 'Merriweather-Regular',
                              fontSize: 11.5.sp,
                            )),
                        SizedBox(
                          height: 1.h,
                        ),
                        Text("Нажмите на эту секцию для",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: PENDING_COLOR,
                              fontFamily: 'Merriweather-Regular',
                              fontSize: 11.5.sp,
                            )),
                        SizedBox(
                          height: 1.h,
                        ),
                        Text("Дополнения данных",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: PENDING_COLOR,
                              fontFamily: 'Merriweather-Regular',
                              fontSize: 11.5.sp,
                            )),
                      ]),
            Spacer(),
            IconButton(
                icon: Icon(Icons.arrow_right,
                    size: 10.w, color: Color.fromRGBO(58, 67, 59, 1)),
                onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Метод оплаты",
                style: TextStyle(
                  color: Color.fromRGBO(58, 67, 59, 1),
                  fontFamily: 'Merriweather-Bold',
                  fontSize: 13.sp,
                )),
            SizedBox(
              height: 2.h,
            ),
            Wrap(
                alignment: WrapAlignment.start,
                direction: Axis.vertical,
                spacing: 1.5.h, // gap between adjacent chips
                runSpacing: 4.w, // gap between lines
                children: [
                  'Kaspi перевод',
                  'Оплата картой',
                ]
                    .asMap()
                    .entries
                    .map((element) => InkWell(
                          onTap: () {
                            chosenStatus = element.value;
                            setState(() {});
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.circle,
                                color: (chosenStatus == element.value)
                                    ? GOLD_COLOR
                                    : Colors.transparent,
                                size: 6.w,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(element.value,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(58, 67, 59, 1),
                                      fontFamily: 'SolomonSans-SemiBold',
                                      fontSize: 11.5.sp)),
                            ],
                          ),
                        ))
                    .toList()),
          ]),
          Spacer(),
          IconButton(
              icon: Icon(Icons.arrow_right,
                  size: 10.w, color: Color.fromRGBO(58, 67, 59, 1)),
              onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildOrderDetailsSection() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Взятые товары",
              style: TextStyle(
                color: Color.fromRGBO(58, 67, 59, 1),
                fontFamily: 'Merriweather-Bold',
                fontSize: 13.sp,
              )),
          SizedBox(
            height: 2.h,
          ),
          Container(
            height: 10.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 1.h, // gap between adjacent chips
                    runSpacing: 2.w, // gap between lines
                    children: widget.shoppingCartOrder.orderItems
                        .map((element) => _buildOrderDetail(orderItem: element))
                        .toList())
              ],
            ),
          )
        ]));
  }

  Widget _buildOrderDetail({required OrderItem orderItem}) {
    return Column(children: [
      SizedBox(
        width: 4.w,
      ),
      Container(
          alignment: Alignment.center,
          
          child: CachedNetworkImage(
            cacheManager: CacheManager(
                Config('customCacheKey', stalePeriod: Duration(days: 7))),
            key: UniqueKey(),
            imageUrl: orderItem.product.image,
            fit: BoxFit.cover,
            height: 10.h,
          width: 22.5.w,
            placeholder: (context, url) => Container(color: Colors.grey),
            memCacheHeight: 250,
          )),
    ]);
  }

  Widget _buildOrderFinancials() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Цена товаров",
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 11.5.sp,
                  )),
              Text(
                widget.shoppingCartOrder.totalPrice.toString() + " Т",
                style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 13.sp),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Цена доставки : ",
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 11.5.sp,
                  )),
              SizedBox(
                height: 4.h,
              ),
              Text(
                "1000 T",
                style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'SolomonSans-SemiBold',
                    fontSize: 13.sp),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderFinancialsTotals() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: APP_SCREEN_CONTENT_PADDING_V_WIDTH),
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
                (widget.shoppingCartOrder.totalPrice + 1000).toString() + " T",
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
              height: 6.h,
              child: OutlinedButton(
                child: Text('Оплатить',
                    style: TextStyle(
                        fontSize: 11.5.sp,
                        color: Color.fromRGBO(58, 67, 59, 1),
                        fontFamily: 'SolomonSans-SemiBold')),
                onPressed: () => {
                  _placeOrderCubit
                        .updateOrder(
                            token: widget.token,
                            userData: widget.userData,
                            status: "Pending",
                            cartOrder: widget.shoppingCartOrder)
                        .then((_) => {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    const Text('Покупка успешно совершена'),
                                duration: const Duration(seconds: 2),
                              )),
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MainScreen(
                                  repository: widget.repository, adminAccess: widget.userData!.isAdmin, userData: widget.userData, token: widget.token
                                ),
                              ))
                            })
                 

                  // kaspi pay
                  /*
                  _launchUniversalLink("https://kaspi.kz/bank/Gold/3")
                      .then((value) {
                    _placeOrderCubit
                        .updateOrder(
                            token: widget.token,
                            userData: widget.userData,
                            status: "Pending",
                            cartOrder: widget.shoppingCartOrder)
                        .then((_) => {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    const Text('Покупка успешно совершена'),
                                duration: const Duration(seconds: 2),
                              )),
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MainScreen(
                                  repository: widget.repository,
                                ),
                              ))
                            });
                            
                  })
                  */
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      width: 0.2.w, color: Color.fromRGBO(58, 67, 59, 1)),
                ),
              ))
        ],
      ),
    );
  }

  Future<void> _launchUniversalLink(String url) async {
    if (await canLaunch(url)) {
      final bool nativeAppLaunchSucceeded = await launch(
        url,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!nativeAppLaunchSucceeded) {
        await launch(url, forceSafariVC: true);
      }
    }
  }

  void updateAfterReturn() {
    print("DALALBAPLSAKDAS");
    setState(() {});
  }




  
}
