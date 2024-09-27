// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_yazar_proje/viewModel/part_detail_view_model.dart';
import 'package:provider/provider.dart';


class PartDetailPage extends StatelessWidget {

TextEditingController _controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    //_controller.text = part.content;
    return Scaffold(
      appBar: _buildAppbar(context),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppbar(BuildContext context) {

    PartDetailViewModel viewModel = Provider.of<PartDetailViewModel>(context, listen: false);

    return AppBar(
      title: Text(viewModel.part.title),
      actions: [
        IconButton(
          icon: Icon(Icons.save),
          onPressed: (){viewModel.saveContent(_controller.text);} ,
        )
      ],
    );
  }

  Widget _buildBody(BuildContext context) {

    PartDetailViewModel viewModel = Provider.of<PartDetailViewModel>(context, listen: false);

    _controller.text = viewModel.part.content;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _controller,
        maxLines: 1000,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      ),
    );
  }
}
