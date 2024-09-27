// ignore_for_file: depend_on_referenced_packages, unused_element, prefer_final_fields, avoid_print

import 'package:flutter_yazar_proje/model/book.dart';
import 'package:flutter_yazar_proje/model/part.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class YerelVeriTabani {
  YerelVeriTabani._privateConstructor();

  static final _object = YerelVeriTabani._privateConstructor();

  factory YerelVeriTabani() {
    return _object;
  }

  Database? _database;

  String _dbName = "TableName";
  String _dbBookName = "name";
  String _dbID = "id";
  String _dbCreateionDate = "creationDate";
  String _dbCategoryBooks = "category";

  String _dbPartName = "parts";
  String _dbPartID = "id";
  String _dbPartBookID = "bookID";
  String _dbPartTitle = "title";
  String _dbPartContent = "content";
  String _dbPartCreationDate = "creationDate";

  Future<Database?> _fetchDatabase() async {
    if (_database == null) {
      String filePath = await getDatabasesPath();
      String _databasePath = join(filePath, "yazarProje.db");
      _database = await openDatabase(_databasePath,
          version: 2, onCreate: _createDatabase, onUpgrade: _updateDatabase);
    }

    return _database;
  }

  Future<void> _updateDatabase(
      Database db, int oldVersion, int newVersion) async {
    List<String> updateCommands = [
      "ALTER TABLE $_dbName ADD COLUMN $_dbCategoryBooks INTEGER DEFAULT 0",
      "ALTER TABLE $_dbName ADD COLUMN test INTEGER DEFAULT 0"
    ];

    for (int i = oldVersion - 1; i < newVersion; i++) {
      await db.execute(updateCommands[i]);
    }
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute("""
      CREATE TABLE $_dbName (
      $_dbID	INTEGER NOT NULL UNIQUE PRIMARY KEY AUTOINCREMENT,
      $_dbBookName	TEXT NOT NULL,
      $_dbCreateionDate	INTEGER,
      $_dbCategoryBooks	INTEGER DEFAULT 0

      );
      """);
    await db.execute("""
      CREATE TABLE $_dbPartName (
      $_dbPartID	INTEGER NOT NULL UNIQUE PRIMARY KEY AUTOINCREMENT,
      $_dbPartBookID	INTEGER NOT NULL,
      $_dbPartTitle	TEXT NOT NULL,
      $_dbPartContent	TEXT,
      $_dbPartCreationDate TEXT DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY("$_dbPartBookID") REFERENCES "$_dbName" ("$_dbID") ON UPDATE CASCADE ON DELETE CASCADE
      );
      """);
  }

  Future<int> createBook(Book book) async {
    Database? db = await _fetchDatabase();
    if (db != null) {


      return await db.insert(_dbName, _bookToMap(book));
    } else {
      print("HATAAAA");
      return -1;
    }
  }

  Future<List<Book>> readBooks(int categoryID) async {
    Database? db = await _fetchDatabase();
    List<Book> books = [];

    if (db != null) {

      String? filter;
      List<int> filterArgs = [];

      if(categoryID >= 0)
      {
        filter = "$_dbCategoryBooks = ?";
        filterArgs.add(categoryID);
      }

      List<Map<String, dynamic>> allBooks = await db.query(
        _dbName,
        where: filter ,
        whereArgs: filterArgs,
        orderBy: _dbID,
      );
      for (Map<String, dynamic> book in allBooks) {
        Book newBook = _mapToBook(book);
        books.add(newBook);
      }
    }

    print("kotu");

    return books;
  }

  Future<int> updateBook(Book book) async {
    Database? db = await _fetchDatabase();
    if (db != null) {
      print("aaaaa");
      return await db.update(_dbName, _bookToMap(book),
          where: "$_dbID = ?", whereArgs: [book.id]);
    } else {
      print("HATAAAA");
      return 0;
    }
  }

  Future<int> deleteBook(Book book) async {
    Database? db = await _fetchDatabase();
    if (db != null) {
      print("aaaaa");
      return await db
          .delete(_dbName, where: "$_dbID = ?", whereArgs: [book.id]);
    } else {
      print("HATAAAA");
      return 0;
    }
  }

  Future<int> deleteBooks(List<int> bookIDs) async {
    Database? db = await _fetchDatabase();
    if (db != null && bookIDs.isNotEmpty) {

      String filter = "$_dbID in (";

      for(int i = 0; i < bookIDs.length; i++)
      {
        if(i != bookIDs.length -1)
        {
          filter += "?,";
        }
        else
        {
          filter += "?)";
        }
      } 


      print("aaaaa");
      return await db
          .delete(_dbName, where: filter, whereArgs: bookIDs);
    } else {
      print("HATAAAA");
      return 0;
    }
  }

  Future<int> createPart(Part part) async {
    Database? db = await _fetchDatabase();
    if (db != null) {
      print("aaaaa");
      return await db.insert(_dbPartName, part.toMap());
    } else {
      print("HATAAAA");
      return -1;
    }
  }

  Future<List<Part>> readParts(int _bookID) async {
    Database? db = await _fetchDatabase();
    List<Part> parts = [];

    if (db != null) {
      List<Map<String, dynamic>> allParts = await db.query(_dbPartName,
          where: "$_dbPartBookID = ?", whereArgs: [_bookID]);
      
      for (Map<String, dynamic> part in allParts) {
        print(" Book data from DB : $part");
        Part newPart = Part.fromMap(part);
        parts.add(newPart);
      }
    }

    return parts;
  }

  Future<int> updatePart(Part part) async {
    Database? db = await _fetchDatabase();
    if (db != null) {
      print("aaaaa");
      return await db.update(_dbPartName, part.toMap(),
          where: "$_dbPartID = ?", whereArgs: [part.id]);
    } else {
      print("HATAAAA");
      return 0;
    }
  }

  Future<int> deletePart(Part part) async {
    Database? db = await _fetchDatabase();
    if (db != null) {
      print("aaaaa");
      return await db
          .delete(_dbPartName, where: "$_dbPartID = ?", whereArgs: [part.id]);
    } else {
      print("HATAAAA");
      return 0;
    }
  }


  Map<String, dynamic>_bookToMap(Book book)
  {
      Map<String, dynamic> bookMap = book.toMap();
      DateTime? creationDate = bookMap["creationDate"];
      if(creationDate != null)
      {
        bookMap["creationDate"] = creationDate.millisecondsSinceEpoch;
      }

      return bookMap;


  }

  Book _mapToBook(Map<String, dynamic> m)
  {
    Map<String, dynamic> bookMap = Map.from(m);
    int creationDate = bookMap["creationDate"];
    if(creationDate != null)
      {
        bookMap["creationDate"] = DateTime.fromMillisecondsSinceEpoch(creationDate);
      }

      return Book.fromMap(bookMap);

  }
}
