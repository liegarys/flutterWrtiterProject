// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_yazar_proje/constants.dart';
import 'package:flutter_yazar_proje/model/book.dart';
import 'package:flutter_yazar_proje/view/part_page.dart';
import 'package:flutter_yazar_proje/viewModel/part_view_model.dart';
import 'package:flutter_yazar_proje/yerel_veri_tabani.dart';
import 'package:provider/provider.dart';

class BookViewModel with ChangeNotifier {
  YerelVeriTabani _localDB = YerelVeriTabani();

  List<Book> books = [];

  List<int> allCategories = [-1];

  int _choosenCategory = -1;
  int get choosenCategory => _choosenCategory;

  set choosenCategory(int value) {
    _choosenCategory = value;
    notifyListeners();
  }

  List<int> deleteBookID = [];

  BookViewModel() {
    allCategories.addAll(Constants.categories.keys);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAllBooks();
    });
    // Fetch books when the screen loads
  }

  void addBook(BuildContext context) async {
    List<dynamic>? result = await _openWindow(context);

    if (result != null && result.length > 1) {
      String _bookName = result[0];
      int category = result[1];

      Book newBook = Book(_bookName, DateTime.now(), category);
      int BookID = await _localDB.createBook(newBook);
      newBook.id = BookID;

      books.add(newBook);
      notifyListeners();

      /*
      setState(() {
        fetchAllBooks();
      });
      */
    }
  }

  void updateBook(BuildContext context, int index) async {
    Book book = books[index];

    List<dynamic>? result = await _openWindow(context,
        currentBookName: book.name, currentCategory: book.category);

    if (result != null && result.length > 1) {
      String _newBookName = result[0];
      int _newCategory = result[1];

      if (_newBookName != book.name || _newCategory != book.category) {
        book.update(_newBookName, _newCategory);

        int updatedLines = await _localDB.updateBook(book);

        if (updatedLines > 0) {
          /* setState(() {});*/
        }
      }
    }
  }

  void deleteBook(int index) async {
    Book book = books[index];
    int deletedLines = await _localDB.deleteBook(book);
    if (deletedLines > 0) {
      books.removeAt(index);
      notifyListeners();
      // setState(() {});
    }
  }

  void deleteChoosenBooks() async {
    int deletedLines = await _localDB.deleteBooks(deleteBookID);
    if (deletedLines > 0) {
      books.removeWhere((book) => deleteBookID.contains(book.id));
      notifyListeners();
      //setState(() {});
    }
  }

  void goToPartPage(BuildContext context, int index) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) {
      return ChangeNotifierProvider(
        create: (context) => PartViewModel(books[index]),
        child:PartPage()); //PartPage();
    });

    Navigator.push(context, route);
  }

  Future<List<dynamic>?> _openWindow(BuildContext context,
      {String currentBookName = "", int currentCategory = 0}) {
    int category = currentCategory;
    TextEditingController _nameController =
        TextEditingController(text: currentBookName);

    return showDialog<List<dynamic>?>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Book Name:"),
            content: StatefulBuilder(builder: (BuildContext context,
                void Function(void Function()) setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Kategori:"),
                      DropdownButton<int>(
                          value: category,
                          items: Constants.categories.keys.map((categoryID) {
                            return DropdownMenuItem<int>(
                              child:
                                  Text(Constants.categories[categoryID] ?? ""),
                              value: categoryID,
                            );
                          }).toList(),
                          onChanged: (int? newValue) {
                            if (newValue != null) {
                              setState(() {
                                category = newValue;
                              });
                            }
                          }),
                    ],
                  )
                ],
              );
            }),
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
                  if (_nameController.text != null) {
                    Navigator.pop(context, [_nameController.text, category]);
                  }
                },
              ),
            ],
          );
        });
  }

  Future<void> fetchAllBooks() async {
    books = await _localDB.readBooks(_choosenCategory);
    notifyListeners();
  }
}
