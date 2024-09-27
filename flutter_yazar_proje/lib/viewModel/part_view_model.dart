// ignore_for_file: prefer_final_fields, no_leading_underscores_for_local_identifiers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_yazar_proje/model/book.dart';
import 'package:flutter_yazar_proje/model/part.dart';
import 'package:flutter_yazar_proje/view/part_detail_page.dart';
import 'package:flutter_yazar_proje/viewModel/part_detail_view_model.dart';
import 'package:flutter_yazar_proje/yerel_veri_tabani.dart';
import 'package:provider/provider.dart';

class PartViewModel with ChangeNotifier {
  YerelVeriTabani _localDB = YerelVeriTabani();
  List<Part> parts = [];

  Book book;

  PartViewModel(this.book) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAllParts();
    });
  }

  void addPart(BuildContext context) async {
    String? _partTitle = await _openWindow(context);
    int? _bookID = book.id;

    if (_partTitle != null && _bookID != null) {
      Part newPart = Part(_bookID, _partTitle);
      int partID = await _localDB.createPart(newPart);
      newPart.id = partID;
      parts.add(newPart);
      notifyListeners();
    }

    //setState(() {});
  }

  void updatePart(BuildContext context, int index) async {
    String? _newPartTitle = await _openWindow(context);

    if (_newPartTitle != null) {
      Part part = parts[index];
      part.update(_newPartTitle);

      int updatedLines = await _localDB.updatePart(part);

      if (updatedLines > 0) {
        //setState(() {});
      }
    }
  }

  void deletePart(int index) async {
    Part part = parts[index];
    int deletedLines = await _localDB.deletePart(part);
    if (deletedLines > 0) {
      parts.removeAt(index);
      notifyListeners();
      // setState(() {});
    }
  }

  void goToPartDetailPage(BuildContext context, int index) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) {
      return ChangeNotifierProvider(
        create: (context) => PartDetailViewModel(parts[index]),
        child: PartDetailPage(),
      ); //PartDetailPage();
    });

    Navigator.push(context, route);
  }

  Future<String?> _openWindow(BuildContext context) {
    String? result;

    return showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Part Name:"),
            content: TextField(
              onChanged: (value) {
                result = value;
              },
            ),
            actions: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("Save"),
                onPressed: () {
                  if (result != null) {
                    Navigator.pop(context, result);
                  }
                },
              ),
            ],
          );
        });
  }

  Future<void> fetchAllParts() async {
    int? _bookID = book.id;
    print(_bookID);
    if (_bookID != null) {
      parts = await _localDB.readParts(_bookID);
      notifyListeners();
    }
  }
}
