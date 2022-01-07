import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sectorworkingcondition/database/wageratetable.dart';
import 'package:sectorworkingcondition/domain/todo.dart';
import 'package:sectorworkingcondition/model/coordinates.dart';
import 'package:sectorworkingcondition/model/occupation.dart';
import 'package:sectorworkingcondition/model/resultset.dart';
import 'package:sectorworkingcondition/model/wagerate.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import "package:collection/collection.dart";
import 'dart:convert';

import 'gradecontroller.dart';

class OccupationController extends StatefulWidget {
  OccupationController({this.parentEntity});
  final Todo parentEntity;
  @override
  _OccupationControllerState createState() => _OccupationControllerState(parentEntity:this.parentEntity);
}



class _OccupationControllerState extends State<OccupationController> {
  _OccupationControllerState({this.parentEntity});
  final Todo parentEntity;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<WageRateResultSet> _taskList = new  List<WageRateResultSet>();
  List<int> _gradeSet = [];
  List<Coordinates> _coordinates = new List<Coordinates>();
  final dbHelper = WageRateTable.instance;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key:_scaffoldKey,
        appBar: new AppBar(
          title: new Text(parentEntity.title + ' Occupations'),
        ),
        body: GetRequestList(),
    );
  }

  //In future builder, it calls the future function to wait for the result, and as soon as it produces the result it calls the builder function where we build the widget.
  Widget GetRequestList() {

    return FutureBuilder(
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return new Text('Input a URL to start');
          case ConnectionState.waiting:
            return new Center(child: new CircularProgressIndicator());
          case ConnectionState.active:
            return new Text('');
          case ConnectionState.done:
            if (snapshot.hasError) {
              return new Text(
                '${snapshot.error}',
                style: TextStyle(color: Colors.red),
              );
            } else {

              return _buildClaimByMilestoneGrid(snapshot.data);
            }
        }},


      future: dbHelper.getWageRateByParentId(parentEntity.id),
    );
  }




  SingleChildScrollView  _buildClaimByMilestoneGrid(List<Map<String,dynamic>> entityList){

    ReadAll(entityList);
    if (_taskList == null) {
      return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 1,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: ListTile(
                title: Text(
                    "Session Expired, Click to login"),
                onTap: () {
                  // navigateToLogin();
                },
              ),
            ),
          );
        },
      ));
    }
    else {

      _taskList.sortBy((element) =>  element.occupationGroup);
      final groups = groupBy(_taskList, (WageRateResultSet e) {
        return e.occupationGroup;
      });

      return

        SingleChildScrollView(
            child:Wrap(
                direction: Axis.horizontal,
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 4.0,
                children: <Widget>[
                  FutureBuilder<List<WageRateResultSet>>(
                    builder: (c, s) {

                      List<Tab> tabs = new List<Tab>();

                      for(var record in groups.keys) {
                       var occupationList = GenerateOccupationList(_taskList.where((element) => element.occupationGroup == record).toList());
                        var displayText = record + ' (' + occupationList.length.toString() + ')';
                        tabs.add(Tab(
                          child: Text(
                            displayText,
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ));
                      }


                      return DefaultTabController(
                          length: groups.keys.length,
                          child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                  child: TabBar(
                                    labelColor: Colors.green,
                                    unselectedLabelColor: Colors.black,
                                    isScrollable: true,
                                    tabs: tabs,
                                  ),
                                ),
                                Container(
                                    height: 500, //height of TabBarView
                                    decoration: BoxDecoration(
                                        border: Border(top: BorderSide(color: Colors.grey, width: 0.5))
                                    ),
                                    child: TabBarView(
                                      children:groups.keys.map((dynamicContent) {

                                        var resultset = _taskList.where((element) => element.occupationGroup== dynamicContent).toList();
                                        return new Card(
                                            child:_buildOccupationList(resultset)
                                        );
                                      }).toList(),
                                    )
                                )
                              ])
                      );

                    },
                  )]));
    }
  }



  Widget  _buildOccupationList(List<WageRateResultSet> resultSet){
   var occupationList = GenerateOccupationList(resultSet);

    return Row(
        children: <Widget>[Expanded(
    child:
    SingleChildScrollView(
        scrollDirection: Axis.vertical,
            child: DataTable(
                dividerThickness: 1,
                sortColumnIndex: 0,
                sortAscending: false,
                columnSpacing: 1,
                columns: [
                  DataColumn(
                  label:Text(
                      'Name',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 16.0,
                      )),
                       ),
                  DataColumn(
                    label: Text(
                      'Grade',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 16.0,
                      ),
                    ),

                  ),
                  DataColumn(
                    label: Text(
                      'Rate/hr',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 16.0,
                      ),
                    ),
                  ),

                ],
                rows: occupationList
                    .map(
                      (entity) => DataRow(
                    cells: [
                      DataCell(
                      Container(
                      width: 120,
                        child:
                        Text(
                            entity.title,
                            maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )),
                      DataCell(
                         Text(
                            entity.grade,
                        ),
                      ),
                      DataCell(
                      Text(
                          'R '+  entity.amount.toString(),
                          ),
                      ),
                    ],
                  ),
                ).toList())))]);
  }


  List<Occupation> GenerateOccupationList(List<WageRateResultSet> entityList)
  {

    int maxFinYear =0;
    Set<String> _ids = new Set<String>();
    List<Occupation> resultList = [];
    entityList.forEach((element) {
       if(element.finYear > maxFinYear)
          maxFinYear = element.finYear;
    });

    var output = entityList.where((element) => element.finYear == maxFinYear);

    output.toList().forEach((element) {
      if(!_ids.contains(element.occupation))
      {
        _ids.add(element.occupation);
        resultList.add(Occupation(
            id:1,
            title:element.occupation,
            grade:element.ordinal.toString(),
            amount:element.amount));
      }

    });

    resultList.sortBy((element) => element.title);

    return resultList.toList();
  }

  void ReadAll(List<Map<String,dynamic>> entityList)
  {

    _taskList = entityList.map((model)=> WageRateResultSet.fromDatabase(model)).toList();

    Set<int> _localGrades = new Set<int>();
    _gradeSet =[];
    _coordinates =[];
    Set<int> _tempCoordinates = new Set<int>();
    _taskList.forEach((element) {

      if(!_localGrades.contains(element.ordinal)) {
        _localGrades.add(element.ordinal);
        _gradeSet.add(element.ordinal);
      }
      if(!_tempCoordinates.contains(element.finYear)) {
        _tempCoordinates.add(element.finYear);
        _coordinates.add(
            Coordinates(element.propertyValue, element.finYear));
      }

    });



    _gradeSet.sort();

    _localGrades.forEach((element) {
     print(element);

    });
  }



  void navigateToNext(int entity) async{

      await Navigator.push(context,
        MaterialPageRoute(
            builder: (context)
                  => GradeController(
                   parentEntity: entity,
                      parentEntityList:_taskList.where((element) => element.ordinal == entity).toList())));

  }


}
