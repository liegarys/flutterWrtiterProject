// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_yazar_proje/model/part.dart';
import 'package:flutter_yazar_proje/yerel_veri_tabani.dart';

class PartDetailViewModel with ChangeNotifier
{
  final Part part;

  YerelVeriTabani _localDB = YerelVeriTabani();


  PartDetailViewModel(this.part);


  void saveContent(String content) async 
  {
      part.content = content;
      await _localDB.updatePart(part);
  }
}