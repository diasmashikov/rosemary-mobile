import 'package:rosemary/data/models/user.dart';

class Login {
  User? user;
  String token;

  Login({required this.user, required this.token});

  Login.fromJson(Map<String, dynamic> json)
      : user = User.fromJson(json["user"]),
        token = json["token"];
}
