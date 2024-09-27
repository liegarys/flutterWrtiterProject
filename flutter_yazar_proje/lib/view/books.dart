// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, use_key_in_widget_constructors, prefer_final_fields, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_yazar_proje/constants.dart';
import 'package:flutter_yazar_proje/model/book.dart';
import 'package:flutter_yazar_proje/viewModel/book_view_model.dart';
import 'package:provider/provider.dart';

class Books extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(context),
      body: _buildBody(),
      floatingActionButton: _buildAddBook_FAB(context),
    );
  }

  AppBar _buildAppbar(BuildContext context) {
    BookViewModel viewModel =
        Provider.of<BookViewModel>(context, listen: false);

    return AppBar(
      title: Text("Books"),
      actions: [
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            viewModel.deleteChoosenBooks();
          },
        )
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildCategoryFilter(),
        Expanded(child:
            Consumer<BookViewModel>(builder: (context, viewModel, child) {
          return ListView.builder(
              itemCount: viewModel.books.length,
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(
                  value: viewModel.books[index],
                  child: _lwBuilder(context, index),
                );
              });
        })),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Kategori:"),
        Consumer<BookViewModel>(
          builder: (context, viewModel, child) {
            return DropdownButton<int>(
                value: viewModel.choosenCategory,
                items: viewModel.allCategories.map((categoryID) {
                  return DropdownMenuItem<int>(
                    child: Text(categoryID == -1
                        ? "All"
                        : Constants.categories[categoryID] ?? ""),
                    value: categoryID,
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    viewModel.choosenCategory = newValue;
                  }
                });
          },
        )
      ],
    );
  }

  Widget? _lwBuilder(BuildContext context, int index) {

    BookViewModel viewModel = Provider.of<BookViewModel>(context, listen: false);

    return Consumer<Book>(
          builder: (context, book, child){
      return ListTile(
        leading: CircleAvatar(child: Text(book.id.toString())),
        title: Text(book.name),
        subtitle: Text(Constants.categories[book.category] ?? ""),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () {
                  viewModel.updateBook(context, index);
                },
                icon: Icon(Icons.edit)),
            Checkbox(
                value: book.isChoosen,
                onChanged: (bool? newValue) {
                  if (newValue != null) {
                    int? _bookID = book.id;
                    if (_bookID != null) {

                        if (newValue) {
                          viewModel.deleteBookID.add(_bookID);
                        } else {
                          viewModel.deleteBookID.remove(_bookID);
                        }

                        book.choose(newValue);

                    }
                  }
                })
          ],
        ),
        onTap: () {
          viewModel.goToPartPage(context, index);
        },
      );
  });
  }

  Widget _buildAddBook_FAB(BuildContext context) {

    BookViewModel viewModel = Provider.of<BookViewModel>(context, listen: false);


    return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          viewModel.addBook(context);
        });
  }
}
