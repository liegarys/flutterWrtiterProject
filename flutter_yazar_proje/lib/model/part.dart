import 'package:flutter/material.dart';

class Part with ChangeNotifier
{
  dynamic id;
  int bookID;
  String title;
  String content;

  Part(this.bookID, this.title): content = "";

  Part.fromMap(Map<String, dynamic> map)
    :id = map["id"],
    bookID = map["bookID"],
    title = map["title"],
    content = map["content"];


  Map<String, dynamic> toMap()
  {
    return {
      "id": id,
      "bookID": bookID,
      "title": title,
      "content" : content
    };
  }

  void update(String newTitle)
  {
    title = newTitle;
    notifyListeners();
  }

}