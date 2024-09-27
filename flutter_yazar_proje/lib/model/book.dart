// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class Book with ChangeNotifier {
  dynamic id;
  String name;
  DateTime creationDate;
  int category;
  bool isChoosen = false;

  Book(this.name, this.creationDate, this.category);

  Book.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"] ?? "Hata",
        creationDate =map["creationDate"],
        category = map["category"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "creationDate": creationDate,
      "category": category
    };
  }

  void update(String newName, int newCategory)
  {
    name = newName;
    category = newCategory;
    notifyListeners();
  }

  void choose(bool newValue)
  {
    isChoosen = newValue;
    notifyListeners();
  }

  @override
  String toString() {
    return 'Book{id: $id, name: $name, creationDate: $creationDate}';
  }
}
