class User {
  String name;
  String email;
  String phone;
  bool isAdmin;
  String street;
  String zip;
  String city;
  String country;
  String region;
  String homeNumber;
  String id;

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        phone = json['phone'],
        isAdmin = json['isAdmin'],
        street = json['street'],
        zip = json['zip'],
        city = json['city'],
        country = json['country'],
        region = json['region'],
        homeNumber = json['homeNumber'],
        id = json['id'];
}
