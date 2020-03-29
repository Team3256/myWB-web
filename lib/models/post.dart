import 'dart:convert';

class Post {
  String id = "";
  String title = "";
  String authorID = "";
  DateTime date;
  String body = "";

  List<String> tags = new List();

  Post.plain();

  Post(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    authorID = json["authorID"];
    date = DateTime.parse(json["date"]);
    body = json["body"];

    for (int i = 0; i < json["tags"].length; i++) {
      tags.add(json["tags"][i]);
    }
  }
}