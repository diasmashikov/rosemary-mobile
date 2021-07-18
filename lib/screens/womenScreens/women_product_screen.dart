import 'package:flutter/material.dart';
import 'package:rosemary/screens/shopping_cart_screen.dart';
import '../../navigation_drawer_widget.dart';

class WomenProductScreen extends StatefulWidget {
  @override
  _WomenProductState createState() => _WomenProductState();
}

class _WomenProductState extends State<WomenProductScreen> {
  Color _expansionTileTextColor = Color.fromRGBO(58, 67, 59, 1);

  // for ios
  double clothImageWidth = 400;
  double clothImageHeight = 380;

  // for android
  //double productCellHeight = 240;
  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          centerTitle: false,
          title: Text("Женщины",
              style: TextStyle(
                  color: Color.fromRGBO(58, 67, 59, 1),
                  fontFamily: 'Merriweather-Regular')),
          actions: [
            IconButton(
              icon: Icon(Icons.favorite_outline,
                  color: Color.fromRGBO(58, 67, 59, 1)),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart_outlined,
                  color: Color.fromRGBO(58, 67, 59, 1)),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ShoppingCartScreen(),
              )),
            )
          ],
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ListView(children: [
            _buildClothImage(
                width: clothImageWidth,
                height: clothImageHeight,
                imagePath: 'assets/goods_images/product1.jpg',
                context: context),
            const SizedBox(
              height: 24,
            ),
            _buildClothName(context: context, clothName: "Платье \"Love me\""),
            const SizedBox(
              height: 8,
            ),
            _buildClothPrice(clothPrice: "10,000 T"),
            const SizedBox(
              height: 24,
            ),
            _buildColorName(),
            const SizedBox(
              height: 8,
            ),
            _buildColorPicker(),
            const SizedBox(
              height: 12,
            ),
            _buildSizeType(),
            const SizedBox(
              height: 8,
            ),
            _buildSizePicker(),
            const SizedBox(
              height: 24,
            ),
            _buildAddToCartButton(),
            const SizedBox(
              height: 36,
            ),
            _buildExpansionTile(title: "Описание", description: "Это платье прямиком из Турции"),
            Divider(color: Color.fromRGBO(58, 67, 59, 1)),
            _buildExpansionTile(title: "Модель на фото", description: "Рост модели: 180 см\n\nВес модели: 78 кг\n\nРазмер на модели: M"),
            Divider(color: Color.fromRGBO(58, 67, 59, 1)),
            _buildExpansionTile(title: "Материал", description: "5% хлопок\n\n95% эластан"),

         
          ]),
        ),
      );

  Widget _buildClothImage(
      {required double width,
      required double height,
      required String imagePath,
      required BuildContext context}) {
    return Container(
      alignment: Alignment.center,
      height: height,
      width: width,
      child: Image.asset(
        imagePath,
        height: height,
        width: width,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildClothName(
      {required String clothName, required BuildContext context}) {
    return Text(clothName,
        style: TextStyle(
          color: Color.fromRGBO(58, 67, 59, 1),
          fontFamily: 'Merriweather-Bold',
          fontSize: 20,
        ));
  }

  Widget _buildClothPrice({required String clothPrice}) {
    return Text(
      clothPrice,
      style: TextStyle(
          color: Color.fromRGBO(58, 67, 59, 1),
          fontFamily: 'SolomonSans-SemiBold',
          fontSize: 24),
    );
  }

  Widget _buildColorName() {
    return Text(
      'Цвет: ГОЛУБОЙ',
      style: TextStyle(
          color: Color.fromRGBO(58, 67, 59, 1),
          fontFamily: 'Merriweather-Bold',
          fontSize: 20),
    );
  }

  Widget _buildColorPicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildColorRadioButton(color: Colors.blueGrey, selected: 1),
        _buildColorRadioButton(color: Colors.brown, selected: 0)
      ],
    );
  }

  Widget _buildColorRadioButton(
      {required MaterialColor color, required int selected}) {
    return IconButton(
      padding: EdgeInsets.all(0),
      alignment: Alignment.topLeft,
      iconSize: 35,
      icon: Icon(Icons.circle, color: color),
      onPressed: () => {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Сохранено'),
          duration: const Duration(seconds: 2),
        ))
      },
    );
  }

  Widget _buildSizeType() {
    return Text(
      'Размер: S',
      style: TextStyle(
          color: Color.fromRGBO(58, 67, 59, 1),
          fontFamily: 'Merriweather-Bold',
          fontSize: 20),
    );
  }

  Widget _buildSizePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSizeRadioButton(size: 'S', selected: 1),
        const SizedBox(
          width: 10,
        ),
        _buildSizeRadioButton(size: 'M', selected: 0)
      ],
    );
  }

  Widget _buildSizeRadioButton({required String size, required int selected}) {
    return OutlinedButton(
      child: Text(size,
          style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'SolomonSans-SemiBold')),
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: BorderSide(width: 1.0, color: Color.fromRGBO(58, 67, 59, 1)),
      ),
    );
  }

  Widget _buildAddToCartButton() {
    return Container(
      height: 50.0,
      child: OutlinedButton(
        child: Text('Добавить в корзину',
            style: TextStyle(
                color: Color.fromRGBO(58, 67, 59, 1),
                fontFamily: 'SolomonSans-SemiBold')),
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: BorderSide(width: 1.0, color: Color.fromRGBO(58, 67, 59, 1)),
        ),
      ),
    );
  }

  Widget _buildExpansionTile({required String title, required String description}) {
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
                fontSize: 16),
          ),
          children: <Widget>[
            ListTile(
                title: Text(
              description,
              style: TextStyle(
                  color: _expansionTileTextColor,
                  fontFamily: 'Merriweather-Regular',
                  fontSize: 16),
            ))
          ]),
    );
  }
}
