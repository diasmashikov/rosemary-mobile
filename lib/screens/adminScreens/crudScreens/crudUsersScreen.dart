import 'package:flutter/material.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';

class crudUsersScreen extends StatefulWidget {
  final String? token;
  final User? userData;
  final Repository repository;

  const crudUsersScreen(
      {Key? key,
      required this.token,
      required this.userData,
      required this.repository})
      : super(key: key);
  @override
  _crudUsersScreenState createState() => _crudUsersScreenState();
}

class _crudUsersScreenState extends State<crudUsersScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
