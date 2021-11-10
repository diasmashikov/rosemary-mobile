import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosemary/constants/colors.dart';
import 'package:rosemary/cubit/crudCubits/crud_orders_cubit.dart';
import 'package:rosemary/data/models/order.dart';
import 'package:rosemary/data/models/orderItem.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/screens/adminScreens/crudScreens/crudOrdersScreen.dart';

import 'package:sizer/sizer.dart';


class GetListView extends StatefulWidget {
  List<Order>? orders;
  List<Order>? ordersOnSearch = [];
  User? userData;
  String orderType;
  Function buildContainer;
  TextEditingController controller;

  @override
  State<StatefulWidget> createState() => _GetListViewState();
  GetListView(
      {required this.orders,
      required this.buildContainer,
      required this.userData,
      required this.controller,
      required this.orderType});
}

class _GetListViewState extends State<GetListView>
    with AutomaticKeepAliveClientMixin<GetListView> {
  late CrudOrdersCubit? _crudOrdersCubit;
  Color _expansionTileTextColor = Color.fromRGBO(58, 67, 59, 1);

  late bool containsCity;
  late bool containsShippingAddress;
  late bool containsPhoneNumber;
  late bool containsName;
  int realIndexFromSearch = 0;
  int indexCounter = -1;

  @override
  void initState() {
    super.initState();
    print("ONCE UPON A TIME");
    if (widget.orderType == "Активные" || widget.orderType == "Завершенные") {
      _crudOrdersCubit = null;
    } else {
     _crudOrdersCubit = BlocProvider.of<CrudOrdersCubit>(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        (widget.orderType == "Активные" || widget.orderType == "Завершенные") ? Container() : Container(
          width: 90.w,
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ThemeData().colorScheme.copyWith(
                    primary: PRIMARY_DARK_COLOR,
                  ),
            ),
            child: TextField(
              onChanged: (value) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  setState(() {
                    widget.ordersOnSearch = widget.orders!.where((element) {
                      realIndexFromSearch = widget.orders!.indexOf(element);

                      containsCity = element.city
                          .toLowerCase()
                          .contains(value.toLowerCase());
                      containsShippingAddress = element.shippingAddress
                          .toLowerCase()
                          .contains(value.toLowerCase());

                      containsPhoneNumber = element.user!.phone.contains(value);
                      print(element.user!.phone +
                          " " +
                          containsPhoneNumber.toString());

                      containsName = element.user!.name
                          .toLowerCase()
                          .contains(value.toLowerCase());
                      if (containsCity) {
                        //realIndexFromSearch = indexCounter;
                        return containsCity;
                      } else if (containsShippingAddress) {
                        //realIndexFromSearch = indexCounter;

                        return containsShippingAddress;
                      } else if (containsPhoneNumber) {
                        //realIndexFromSearch = indexCounter;

                        return containsPhoneNumber;
                      } else if (containsName) {
                        //realIndexFromSearch = indexCounter;

                        return containsName;
                      } else
                        return false;
                    }).toList();
                  });
                });
              },
              controller: widget.controller,
              cursorColor: PRIMARY_DARK_COLOR,
              style: TextStyle(color: PRIMARY_DARK_COLOR),
              decoration: new InputDecoration(
                  prefixIcon: Icon(Icons.search, color: PRIMARY_DARK_COLOR),
                  suffixIcon: IconButton(
                      onPressed: () {
                        widget.controller.clear();
                        widget.ordersOnSearch!.clear();
                        setState(() {});
                      },
                      icon: Icon(Icons.cancel_outlined,
                          color: PRIMARY_DARK_COLOR)),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: PRIMARY_DARK_COLOR, width: 0.2.w),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: PRIMARY_DARK_COLOR, width: 0.2.w),
                  ),
                  hintText: "Поиск"),
            ),
          ),
        ) ,
        SizedBox(
          height: 1.h,
        ),
        if (widget.controller.text.isNotEmpty &&
            widget.ordersOnSearch!.length == 0)
          Center(
            child: Column(children: [
              SizedBox(
                height: 250,
              ),
              Text("Результаты не найдены",
                  style: TextStyle(
                      color: Color.fromRGBO(58, 67, 59, 1),
                      fontFamily: 'Merriweather-Regular',
                      fontSize: 11.5.sp)),
            ]),
          )
        else if (widget.orders!.isNotEmpty)
          ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              itemCount: widget.controller.text.isNotEmpty
                  ? widget.ordersOnSearch!.length
                  : widget.orders!.length,
              itemBuilder: (BuildContext context, int index) {
                print(realIndexFromSearch);
                return widget.controller.text.isNotEmpty
                    ?
                    // gives search list
                    widget.buildContainer(
                        orderNumber: "#" + index.toString(),
                        customerName: widget.ordersOnSearch![index].user!.name,
                        orderStatus:
                            chooseStatus(widget.ordersOnSearch![index].status),
                        city: widget.ordersOnSearch![index].city,
                        street: widget.ordersOnSearch![index].shippingAddress,
                        homeNumber: "",
                        productName: "Платье \"Чарламэйн\"",
                        quantity: "4",
                        size: "M",
                        color: "Серое",
                        phone: widget.ordersOnSearch![index].user!.phone,
                        orderItems: widget.ordersOnSearch![index].orderItems,
                        index: realIndexFromSearch,
                        orderId: widget.ordersOnSearch![index].id)
                    :
                    // gives typical list
                    widget.buildContainer(
                        orderNumber: "#" + index.toString(),
                        customerName: widget.orders![index].user!.name,
                        orderStatus: chooseStatus(widget.orders![index].status),
                        city: widget.orders![index].city,
                        street: widget.orders![index].shippingAddress,
                        homeNumber: "",
                        productName: "Платье \"Чарламэйн\"",
                        quantity: "4",
                        size: "M",
                        color: "Серое",
                        phone: widget.orders![index].user!.phone,
                        orderItems: widget.orders![index].orderItems,
                        index: index,
                        orderId: widget.orders![index].id);
              })
        else
          Column(children: [
            SizedBox(
              height: 250,
            ),
            Text("Нет " + chooseTypeOfOrder(widget.orderType),
                style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 16)),
          ]),
      ],
    );
  }

  String chooseTypeOfOrder(status) {
    if (status == "Подготавливается") {
      return "подготавливаемых заказов";
    } else if (status == "Доставляется") {
      return "доставлемых заказов";
    } else if (status == "Доставлено") {
      return "доставленных заказов";
    } else {
      return "заказов";
    }
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

  @override
  bool get wantKeepAlive => true;
}
