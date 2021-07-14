import 'package:flutter/material.dart';
import 'package:rosemary/router.dart';
import 'package:rosemary/screens/main_screen.dart';

void main() {
  runApp(MyApp(router: AppRouter()));
}

class MyApp extends StatelessWidget {
  final AppRouter router;

  const MyApp({Key? key, required this.router}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MainScreen(), 

    theme: ThemeData(
   primaryColor: Color.fromRGBO(237, 236, 232, 1),
   ),);
  }
}
