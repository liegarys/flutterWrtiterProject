// ignore_for_file: prefer_const_constructors, prefer_final_fields, no_leading_underscores_for_local_identifiers, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_yazar_proje/model/part.dart';
import 'package:flutter_yazar_proje/viewModel/part_view_model.dart';
import 'package:provider/provider.dart';

class PartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(context),
      body: _buildBody(),
      floatingActionButton: _buildAddPart_FAB(context),
    );
  }

  AppBar _buildAppbar(BuildContext context) {
    PartViewModel viewModel = Provider.of<PartViewModel>(
      context,
      listen: false,
    );
    return AppBar(
      title: Text(viewModel.book.name),
    );
  }

  Widget _buildBody() {
    return Consumer<PartViewModel>(builder: (context, viewModel, child) {
      return ListView.builder(
        itemCount: viewModel.parts.length,
        itemBuilder: (BuildContext context, int index) {
          return ChangeNotifierProvider.value(
            value: viewModel.parts[index],
            child: _lwBuilder(context, index),
          );
        },
      );
    });
  }

  Widget? _lwBuilder(BuildContext context, int index) {
    
    PartViewModel viewModel = Provider.of<PartViewModel>(
      context,
      listen: false,
    );

    return Consumer<Part>(builder: (context, part, child){
      return ListTile(
        leading: CircleAvatar(child: Text(part.id.toString())),
        title: Text(part.title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () {
                  viewModel.updatePart(context, index);
                },
                icon: Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  viewModel.deletePart(index);
                },
                icon: Icon(Icons.delete))
          ],
        ),
        onTap: () {
          viewModel.goToPartDetailPage(context, index);
        },
      );
    });
  }

  Widget _buildAddPart_FAB(BuildContext context) {

    PartViewModel viewModel = Provider.of<PartViewModel>(
      context,
      listen: false,
    );

    return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          viewModel.addPart(context);
        });
  }
}
