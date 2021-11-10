class Contact {
  List<String> phoneNumbers;
  List<String> socialMedias;
  String workingSchedule;
  String id;
  Contact.fromJson(Map<String, dynamic> json)
      : phoneNumbers = List<String>.from(json['phoneNumbers']),
        socialMedias = List<String>.from(json['socialMedias']),
        workingSchedule = json['workingSchedule'],
        id = json['id'];
}
