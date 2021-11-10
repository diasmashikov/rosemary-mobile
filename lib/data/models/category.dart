class Category {
  String name;
  String image;
  String id;

  Category(
      {required this.id, required this.image, required this.name});

  Category.fromJson(Map<String, dynamic>json) : 
  name = json["name"],
  image = json["image"],
  id = json["_id"];


  Map<String, dynamic> toJson() {
    return {
      "name":  name,
      "image": image,
      "id": id,
          };
  }
}
