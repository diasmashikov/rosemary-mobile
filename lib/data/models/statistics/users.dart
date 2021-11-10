class Users {
  int totalUsers;

  Users.fromJson(Map<String, dynamic> json)
      : totalUsers = json["totalUsers"];

  Map<String, dynamic> toJson() {
    return {
      "totalUsers": totalUsers,
    };
  }
}
