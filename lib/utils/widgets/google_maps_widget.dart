import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rosemary/data/models/order.dart';
import 'package:rosemary/data/models/ordersInProgress.dart';
import 'package:geocoding/geocoding.dart' as gc;
import 'package:rosemary/data/models/user.dart';

import 'package:sizer/sizer.dart';

class GoogleMaps extends StatefulWidget {
  final OrdersInProgress? orders;
  final User? user;
  const GoogleMaps({Key? key, required this.orders, required this.user})
      : super(key: key);

  @override
  _GoogleMapsState createState() =>
      _GoogleMapsState(orders: orders, user: user);
}

class _GoogleMapsState extends State<GoogleMaps> {
  Set<Marker> _markers = {};
  final OrdersInProgress? orders;
  final User? user;

  _GoogleMapsState({required this.orders, required this.user});
  @override
  void initState() {
    super.initState();
  }

  void _onMarkerTapped(
      {required String orderId, required Order order, required User? user}) {
    displayDialogOrder(order, orderId, user, context);
  }

  void _onMapCreated(GoogleMapController controller) async {
    controller.setMapStyle(Utils.mapStyle);

    for (Order orderPending in orders!.orderListPending) {
      String orderId = orderPending.id.substring(1, 6);
      print(orderPending.shippingAddress);
      try {
        List<gc.Location> location =
            await gc.locationFromAddress(orderPending.shippingAddress);
        double latitude = location[0].latitude;
        double longitude = location[0].longitude;
        _markers.add(Marker(
          onTap: () => _onMarkerTapped(
              orderId: orderId, order: orderPending, user: user),
          markerId: MarkerId(orderId),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(title: "Заказ " + orderId),
        ));
      } catch (e) {
        print(e);
        continue;
      }
    }

    setState(() {});
  }

  Future<void> getLatLangFromInternet(String address) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
          initialCameraPosition: CameraPosition(
              target: LatLng(43.1951445, 76.89270069999999), zoom: 3),
          onMapCreated: _onMapCreated,
          markers: _markers,
          mapType: MapType.normal),
    );
  }
}

void displayDialogOrder(
        Order order, String orderId, User? user, BuildContext context) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text("Заказ #" + orderId),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter _setState) {
            return Wrap(
              runSpacing: 8,
              alignment: WrapAlignment.start,
              children: [
                Text("Имя заказчика: " + user!.name,
                    style: TextStyle(
                        color: Color.fromRGBO(58, 67, 59, 1),
                        fontFamily: 'SolomonSans-SemiBold',
                        fontSize: 11.sp)),
                Text("Телефон заказчика: " + order.phone,
                    style: TextStyle(
                        color: Color.fromRGBO(58, 67, 59, 1),
                        fontFamily: 'SolomonSans-SemiBold',
                        fontSize: 11.sp)),
                Text("Адрес заказчика: " + order.shippingAddress,
                    style: TextStyle(
                        color: Color.fromRGBO(58, 67, 59, 1),
                        fontFamily: 'SolomonSans-SemiBold',
                        fontSize: 11.sp)),
                Text("Сумма заказа: " + order.totalPrice.toString() + " KZT",
                    style: TextStyle(
                        color: Color.fromRGBO(58, 67, 59, 1),
                        fontFamily: 'SolomonSans-SemiBold',
                        fontSize: 11.sp)),
                Text("Товары на заказ: ",
                    style: TextStyle(
                        color: Color.fromRGBO(58, 67, 59, 1),
                        fontFamily: 'SolomonSans-SemiBold',
                        fontSize: 11.sp)),
                _buildOrderItems(order.orderItems, context)
              ],
            );
          })),
    );

Widget _buildOrderItems(orderItems, context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: orderItems
        .map<Widget>((orderItem) => _buildOrderItem(orderItem))
        .toList(),
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

class Utils {
  static String mapStyle = ''' 
  [
  {
    "featureType": "poi",
    "elementType": "labels",
    "stylers": [
      {
        "visibility": "simplified"
      }
    ]
  },
  {
    "featureType": "poi.attraction",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi.business",
    "stylers": [
      {
        "visibility": "simplified"
      }
    ]
  },
  {
    "featureType": "poi.business",
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "simplified"
      }
    ]
  },
  {
    "featureType": "poi.business",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "lightness": -100
      }
    ]
  },
  {
    "featureType": "poi.government",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi.medical",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi.place_of_worship",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi.school",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi.sports_complex",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  }
]
  ''';
}
