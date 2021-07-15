import 'package:flutter/material.dart';
import '../navigation_drawer_widget.dart';

class ShoppingCartScreen extends StatefulWidget {
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  double clothImageWidth = 150;
  double clothImageHeight = 190;
  @override
  Widget build(BuildContext context) => Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
          centerTitle: false,
          title: Text("Корзина",
              style: TextStyle(
                  color: Color.fromRGBO(58, 67, 59, 1),
                  fontFamily: 'Merriweather-Regular'))),
      body: ListView(
        padding: EdgeInsets.all(0),
        children: [
          _buildCartItem(
              width: clothImageWidth,
              height: clothImageHeight,
              imagePath: 'assets/goods_images/product1.jpg',
              context: context,
              clothName: "Платье \"Love me\"",
              colorName: "Голубой",
              size: "S",
              count: "1", 
              clothPrice: "10,000 T"),
          Divider(color: Color.fromRGBO(58, 67, 59, 1)),
          _buildCartItem(
              width: clothImageWidth,
              height: clothImageHeight,
              imagePath: 'assets/goods_images/product2.jpg',
              context: context,
              clothName: "Платье \"Justice\"",
              colorName: "Черное",
              size: "S",
              count: "1", 
              clothPrice: "17,000 T"),
          Divider(color: Color.fromRGBO(58, 67, 59, 1)),
          _buildTotalOrder(totalPrice: "27,000 T"),
        ],
      ));

  Widget _buildCartItem(
      {required double width,
      required double height,
      required String imagePath,
      required String clothName,
      required String colorName,
      required String size,
      required String count,
      required String clothPrice,
      required BuildContext context}) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: height,
            width: width,
            child: Image.asset(
              imagePath,
              height: height,
              width: width,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Container(
              height: 192,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildClothName(clothName: clothName, context: context),

                  _buildColorName(colorName: colorName),

                  _buildSizeType(size: size),

                  _buildCount(count: count),

                  _buildClothPrice(clothPrice: clothPrice),
                  //const SizedBox(height: 80)
                ],
              ),
            ),
          ),
          Container(
            height: 200,
            child: IconButton(
              alignment: Alignment.bottomCenter,
              iconSize: 30,
              icon: Icon(Icons.delete, color: Color.fromRGBO(58, 67, 59, 1)),
              onPressed: () => {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Сохранено'),
                  duration: const Duration(seconds: 2),
                ))
              },
            ),
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
          fontSize: 16,
        ));
  }

  Widget _buildColorName({required String colorName}) {
    return Text(
      colorName,
      style: TextStyle(
          color: Color.fromRGBO(58, 67, 59, 1),
          fontFamily: 'Merriweather-Regular',
          fontSize: 16),
    );
  }

  Widget _buildSizeType({required String size}) {
    var text = 'Размер: ' + size;
    return Text(
      text,
      style: TextStyle(
          color: Color.fromRGBO(58, 67, 59, 1),
          fontFamily: 'Merriweather-Regular',
          fontSize: 16),
    );
  }

  Widget _buildCount({required String count}) {
    var text = 'Кол-во: ' + count;
    return Text(
      text,
      style: TextStyle(
          color: Color.fromRGBO(58, 67, 59, 1),
          fontFamily: 'Merriweather-Regular',
          fontSize: 16),
    );
  }

  Widget _buildClothPrice({required String clothPrice}) {
    return Text(
      clothPrice,
      style: TextStyle(
          color: Color.fromRGBO(58, 67, 59, 1),
          fontFamily: 'SolomonSans-SemiBold',
          fontSize: 20),
    );
  }

  Widget _buildTotalOrder({required String totalPrice}) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Text("Итого к оплате: ",
          style: TextStyle(
            color: Color.fromRGBO(58, 67, 59, 1),
            fontFamily: 'Merriweather-Regular',
            fontSize: 16,
          )),
          Text(
        totalPrice,
        style: TextStyle(
            color: Color.fromRGBO(58, 67, 59, 1),
            fontFamily: 'SolomonSans-SemiBold',
            fontSize: 20),
      )
        ],),
        SizedBox(height: 20,),
        Container(
          width: double.infinity,
          height: 50,
      child: OutlinedButton(
        child: Text('Оплатить',
            style: TextStyle(
              fontSize: 16,
                color: Color.fromRGBO(58, 67, 59, 1),
                fontFamily: 'SolomonSans-SemiBold')),
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: BorderSide(width: 1.0, color: Color.fromRGBO(58, 67, 59, 1)),
        ),
      ),
    ),
      ],
      ),
    );
  }
}
