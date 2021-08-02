import 'package:flutter/material.dart';

import '../../navigation_drawer_widget.dart';

class PlaceOrderScreen extends StatefulWidget {
  @override
  _PlaceOrderScreenState createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  double clothImageWidth = 150;
  double clothImageHeight = 190;
  @override
  Widget build(BuildContext context) => Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
          centerTitle: false,
          title: Text("Покупка",
              style: TextStyle(
                  color: Color.fromRGBO(58, 67, 59, 1),
                  fontFamily: 'Merriweather-Regular'))),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView(
          children: [
            _buildMyInformationSection(),
            Divider(color: Color.fromRGBO(58, 67, 59, 1)),
            _buildBillingAddressSection(),
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

  Widget _buildMyInformationSection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Моя информация",
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Bold',
              fontSize: 20,
            )),
        SizedBox(
          height: 20,
        ),
        Text("Dias Mashikov",
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Regular',
              fontSize: 16,
            )),
        SizedBox(
          height: 4,
        ),
        Text("hajime@gmail.com",
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Regular',
              fontSize: 16,
            )),
        SizedBox(
          height: 4,
        ),
        Text("+777777777",
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Regular',
              fontSize: 16,
            )),
      ]),
    );
  }

  Widget _buildBillingAddressSection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Платежный адрес",
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Bold',
              fontSize: 20,
            )),
        SizedBox(
          height: 20,
        ),
        Text("Dias Mashikov",
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Regular',
              fontSize: 16,
            )),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 8,
        ),
        Text("Кабанабай Батыра 20",
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Regular',
              fontSize: 16,
            )),
        SizedBox(
          height: 8,
        ),
        Text("Алматинская область, Алмата",
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Regular',
              fontSize: 16,
            )),
        SizedBox(
          height: 8,
        ),
        Text("010000",
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Regular',
              fontSize: 16,
            )),
        SizedBox(
          height: 8,
        ),
        Text("Казахстан",
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Regular',
              fontSize: 16,
            )),
      ]),
    );
  }

  Widget _buildShippingSection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Адрес доставки",
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Bold',
              fontSize: 20,
            )),
        SizedBox(
          height: 20,
        ),
        Text("Dias Mashikov",
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Regular',
              fontSize: 16,
            )),
        SizedBox(
          height: 8,
        ),
        Text("Быстрая доставка - 1 рабочий день",
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Regular',
              fontSize: 16,
            )),
        SizedBox(
          height: 8,
        ),
        Text("1000 Т",
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Regular',
              fontSize: 16,
            )),
        SizedBox(
          height: 8,
        ),
        Text("Кабанабай Батыра 20",
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Regular',
              fontSize: 16,
            )),
        SizedBox(
          height: 8,
        ),
        Text("Алматинская область, Алмата",
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Regular',
              fontSize: 16,
            )),
        SizedBox(
          height: 8,
        ),
        Text("010000",
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Regular',
              fontSize: 16,
            )),
        SizedBox(
          height: 8,
        ),
        Text("Казахстан",
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Regular',
              fontSize: 16,
            )),
      ]),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Метод оплаты",
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Bold',
              fontSize: 20,
            )),
        SizedBox(
          height: 20,
        ),
        Row(children: [
          Container(
            alignment: Alignment.center,
            height: 50,
            width: 50,
            child: Image.asset(
              'assets/visa.png',
              height: 50,
              width: 50,
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(width: 20,),
          Text("**** **** **** 4386",
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'SolomonSans-SemiBold',
              fontSize: 16,
            )),
        ],)
        
        
        
      ]),
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
              fontSize: 20,
            )),

            SizedBox(
          height: 20,
        ),
        Row(children: [
          Container(
            alignment: Alignment.center,
            height: 100,
            width: 100,
            child: Image.asset(
              'assets/goods_images/product1.jpg',
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 20,),
          Container(
            alignment: Alignment.center,
            height: 100,
            width: 100,
            child: Image.asset(
              'assets/goods_images/product2.jpg',
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          
        ],)
        
      ]));
      
  }

  Widget _buildOrderFinancials() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
    
    
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Text("Цена товаров",
          style: TextStyle(
            color: Color.fromRGBO(58, 67, 59, 1),
            fontFamily: 'Merriweather-Regular',
            fontSize: 16,
          )),
          Text(
        "10000 T",
        style: TextStyle(
            color: Color.fromRGBO(58, 67, 59, 1),
            fontFamily: 'SolomonSans-SemiBold',
            fontSize: 20),
      )

        ],),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Text("Цена доставки : ",
          style: TextStyle(
            color: Color.fromRGBO(58, 67, 59, 1),
            fontFamily: 'Merriweather-Regular',
            fontSize: 16,
          )),
          SizedBox(height: 36,),
          Text(
        "1000 T",
        style: TextStyle(
            color: Color.fromRGBO(58, 67, 59, 1),
            fontFamily: 'SolomonSans-SemiBold',
            fontSize: 20),
      )
        ],),

      ],
      ),
    );
  }

  Widget _buildOrderFinancialsTotals() {

   return Container(
      margin: EdgeInsets.symmetric(vertical: 20),

     child: Column(
       children: [
         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text("Итого к оплате: ",
                style: TextStyle(
                  color: Color.fromRGBO(58, 67, 59, 1),
                  fontFamily: 'Merriweather-Regular',
                  fontSize: 16,
                )),
                Text(
              "11000 T",
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
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PlaceOrderScreen(),
                )),
          style: OutlinedButton.styleFrom(
            side: BorderSide(width: 1.0, color: Color.fromRGBO(58, 67, 59, 1)),
          ),
        )
          )],
      ),
   );

  
  }
}
