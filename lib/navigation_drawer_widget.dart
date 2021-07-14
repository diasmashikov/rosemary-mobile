import 'package:flutter/material.dart';
import 'package:rosemary/screens/main_screen.dart';
import 'package:rosemary/screens/women_screen.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  @override
  Widget build(BuildContext context) {
    final name = 'Dias Mashikov';
    final status = 'VIP';
    final urlImage = 'https://images.unsplash.com/photo-1547721064-da6cfb341d50';

    return Drawer(
      child: Material(
          color: Color.fromRGBO(237, 236, 232, 1),
          child: ListView(
            children: <Widget>[
              buildHeader(
                  urlImage: urlImage,
                  name: name,
                  status: status,
                  onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UserScreen(),
                      ))),
             const SizedBox(
                height: 4,
              ),
              Container(
                child: Column(children: [
                  buildMenuItem(
                  text: 'Главная',
                  icon: Icons.home_outlined,
                  onClicked: () => selectedItem(context, 0)),
              const SizedBox(
                height: 12,
              ),
              buildMenuItem(
                text: 'Женщины',
                icon: Icons.shopping_bag_outlined,
                onClicked: () => selectedItem(context, 1)
              ),
              const SizedBox(
                height: 12,
              ),
              buildMenuItem(text: 'Подарки', icon: Icons.card_giftcard_rounded),
              const SizedBox(
                height: 12,
              ),
              buildMenuItem(
                text: 'Акции',
                icon: Icons.local_offer_outlined
              ),
              const SizedBox(height: 12),
              Divider(color: Color.fromRGBO(58, 67, 59, 1)),
              const SizedBox(height: 12),
              buildMenuItem(
                text: 'Контакты',
                icon: Icons.call_outlined,
              ),
              const SizedBox(height: 12),
              buildMenuItem(
                text: 'Частые вопросы',
                icon: Icons.help_center_outlined,
              ),
                ],)

              )
            ],
          )),
    );
  }

  Widget buildHeader(
      {required String urlImage,
      required String name,
      required String status,
      required VoidCallback onClicked}) =>
    InkWell(
        onTap: onClicked,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 18),
            child: Row(
              children: [
                CircleAvatar(
                    radius: 36,
                     backgroundImage: NetworkImage(urlImage),),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(fontSize: 20, color: Color.fromRGBO(58, 67, 59, 1), fontFamily: 'Merriweather-Bold')
                          ),
                        const SizedBox(height: 4), 
                        Text(
                          status,
                          style: TextStyle(fontSize: 14, color: Color.fromRGBO(58, 67, 59, 1), fontFamily: 'Merriweather-Bold')
                        )
                      ],)
              ],
            )));

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Color.fromRGBO(58, 67, 59, 1);
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color, size: 28),
      minLeadingWidth: 20,
      title: Text(text, style: TextStyle(color: color, fontFamily: 'Merriweather-Bold', fontSize: 16
      )),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MainScreen(),
        ));
        break;

      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => WomenScreen(),
        ));
        break;
    }
  }

  

}

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('User'),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        drawer: NavigationDrawerWidget(),
      );
}


