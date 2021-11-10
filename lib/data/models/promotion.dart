class Promotion {
  String firstLine;
  String secondLine;
  String thirdLine;
  String description;
  String activePeriod;
  String slogan;
  String image;
  String id;

  Promotion(
      {required this.firstLine,
      required this.secondLine,
      required this.thirdLine,
      required this.description,
      required this.activePeriod,
      required this.slogan,
      required this.image,
      required this.id});

  Promotion.fromJson(Map<String, dynamic> json)
      : firstLine = json['firstLine'],
        secondLine = json['secondLine'],
        thirdLine = json['thirdLine'],
        description = json['description'],
        activePeriod = json['activePeriod'],
        slogan = json['slogan'],
        image = json["image"],
        id = json['id'];
}
