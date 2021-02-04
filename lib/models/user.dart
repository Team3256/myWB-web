import 'dart:convert';

class User {
  String id = "";
  String firstName = "";
  String lastName = "";
  String email = "";
  String phone = "";
  int grade = 404;
  String role = "";
  bool varsity = false;
  String shirtSize = "";
  String jacketSize = "";
  String discordID = "";
  String discordAuthToken = "";

  List<String> subteams = new List();
  List<String> perms = new List();

  User();

  User.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    firstName = json["firstName"];
    lastName = json["lastName"];
    email = json["email"];
    phone = json["phone"];
    grade = json["grade"];
    role = json["role"];
    varsity = json["varsity"];
    shirtSize = json["shirtSize"];
    jacketSize = json["jacketSize"];
    discordID = json["discordID"];
    discordAuthToken = json["discordAuthToken"];

    for (int i = 0; i < json["subteams"].length; i++) {
      subteams.add(json["subteams"][i]);
    }

    for (int i = 0; i < json["perms"].length; i++) {
      perms.add(json["perms"][i]);
    }
  }

  Map toJson() {
    Map json = new Map();
    json["id"] = id;
    json["firstName"] = firstName;
    json["lastName"] = lastName;
    json["email"] = email;
    json["phone"] = phone;
    json["grade"] = grade;
    json["role"] = role;
    json["varsity"] = varsity;
    json["shirtSize"] = shirtSize;
    json["jacketSize"] = jacketSize;
    json["discordID"] = discordID;
    json["discordAuthToken"] = discordAuthToken;
    json["perms"] = perms;
    json["subteams"] = subteams;
    return json;
  }

}