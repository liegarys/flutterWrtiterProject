// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_yazar_proje/view/books.dart';
import 'package:flutter_yazar_proje/viewModel/book_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: ChangeNotifierProvider(
      create: (context) => BookViewModel(),
      child: Books(),
    ));
  }
}
