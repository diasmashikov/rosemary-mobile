class AskedQuestion {
  String title;
  String description;
  String id;

  AskedQuestion(
      {required this.title, required this.description, required this.id});

  AskedQuestion.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        id = json['id'];
}
