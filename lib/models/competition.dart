import 'dart:convert';

Competition competitionFromJson(String str) =>
    Competition.fromMap(json.decode(str));

String competitionToJson(Competition data) => json.encode(data.toMap());

class Competition {
  String id;
  String name;
  String organizer;
  String location;
  DateTime date;
  String description;
  String imageUrl;
  List<dynamic> admins;
  List<dynamic> savedUsers;
  

  Competition({
    this.id,
    this.name,
    this.organizer,
    this.location,
    this.date,
    this.description,
    this.imageUrl,
    this.admins,
    this.savedUsers,
  });

  factory Competition.fromMap(Map<String, dynamic> json) {
    return Competition(
      id: json["id"],
      name: json["name"],
      organizer: json["organizer"],
      location: json["location"],
      date: json["date"].toDate(),
      description: json["description"],
      imageUrl: json["imageUrl"],
      admins: json["admins"],
      savedUsers: json["savedUsers"],
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "organizer": organizer,
        "location": location,
        "date": date,
        "description": description,
        "imageUrl": imageUrl,
        "admins": admins,
        "savedUsers": savedUsers,
      };

  String toString() {
    String output = '';
    output += 'Competition Object: {\n\t';
    output += 'id: $id\n\t';
    output += 'name: $name\n\t';
    output += 'organizer: $organizer\n\t';
    output += 'location: $location\n\t';
    output += 'date: $date\n\t';
    output += 'description: $description\n\t';
    output += 'imageUrl: $imageUrl\n\t';
    output += 'admins: $admins\n\t';
    output += 'savedUsers: $savedUsers\n';
    output += '}\n';
    return output;
  }
}
