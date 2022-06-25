import '../database/wageratetable.dart';
import '../model/wagerate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


import '../domain/todo.dart';
import '../helpers/DecimalTextInputFormatter.dart';


import "package:collection/collection.dart";

class OccupationGroupService{
  final dbHelper = WageRateTable.instance;
  Future<List<WageRateResultSet>> fetchEntityList(parentId) async{
   var resultSet = await dbHelper.getWageRateByParentId(parentId);

   var _taskList = resultSet.map((model)=> WageRateResultSet.fromDatabase(model)).toList();

     _taskList.sortBy((element) =>  element.occupationGroup);

     final groups = groupBy(_taskList, (WageRateResultSet e) {
       return e.occupationGroup;
     });



  }



}