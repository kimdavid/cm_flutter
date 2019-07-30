import 'dart:convert';

Competition competitionFromJson(String str) => Competition.fromMap(json.decode(str));

String competitionToJson(Competition data) => json.encode(data.toMap());

class Competition {
    String id;
    String name;
    String organizer;
    String location;
    String date;

    Competition({
        this.id,
        this.name,
        this.organizer,
        this.location,
        this.date,
    });

    factory Competition.fromMap(Map<String, dynamic> json) => Competition(
        id: json["id"],
        name: json["name"],
        organizer: json["organizer"],
        location: json["location"],
        date: json["date"]
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "organizer": organizer,
        "location": location,
        "date": date
    };

    String toString() {
      String output = '';
      output += 'Competition Object: {\n\t';
      output += 'id: $id\n';
      output += 'name: $name\n\t';
      output += 'organizer: $organizer\n';
      output += 'location: $location\n';
      output += 'date: $date\n';
      output += '}\n';
      return output;
    }
}