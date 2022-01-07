import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sectorworkingcondition/database/wageratetable.dart';
import 'package:sectorworkingcondition/domain/todo.dart';
import 'package:sectorworkingcondition/model/coordinates.dart';
import 'package:sectorworkingcondition/model/resultset.dart';
import 'package:sectorworkingcondition/model/wagerate.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import "package:collection/collection.dart";
import 'dart:convert';

import 'gradecontroller.dart';

class SubSectorController extends StatefulWidget {
  SubSectorController({this.parentEntity});
  final Todo parentEntity;
  @override
  _SubSectorControllerState createState() => _SubSectorControllerState(parentEntity:this.parentEntity);
}



class _SubSectorControllerState extends State<SubSectorController> {
  _SubSectorControllerState({this.parentEntity});
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
          title: new Text(parentEntity.title + ' Rates'),
        ),
        body: GetRequestList(),
      backgroundColor: Colors.grey,
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
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              _BuildSummary(),
              _BuildLineChart(),
              _BuildGradeList(),

            ]));
  }

  Widget _BuildSummary()
  {
    return Padding(
        padding: EdgeInsets.only(top:10.0
        ),
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                columns: [
                  DataColumn(label: Text('')),
                  DataColumn(label: Text('')),

                ],
                rows: _taskList.take(1)
                    .map(
                      (entity) => DataRow(
                    cells: [
                      DataCell(
                        Container(
                          child: Text(
                            'Grading System',
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          child: Text(
                            entity.gradingSystem,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ).toList())));
  }
  Widget _BuildGradeList() {

    if(_gradeSet ==null || _gradeSet.length == 0){
      return ListView.builder(
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
      );
    }
    else {
      return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _gradeSet.length,
        itemBuilder: (context, index) {
          return Card(
            //color: _toggleColor(entityList[index].isCompliant),
            elevation: 2.0,
            child: ListTile(
              title: ListTile(
                //  leading: _displayByStyle(entityList[index].isCompliant),
                trailing: Icon(Icons.arrow_forward_ios),
                title: Text(
                    'Grade: ${_gradeSet[index]}'),
                onTap: () {
                  navigateToNext(_gradeSet[index]);
                },

              ),
              //subtitle: InspectionSubtitle(entityList[index].hasInspection),
            ),
          );
        },
      )]));
    }
  }

  Widget _BuildLineChart()
  {

    List<charts.Series<Coordinates,DateTime>> series =
    [
      charts.Series(
        id:'WageRate Per Year',
        data: _coordinates,
        domainFn: (Coordinates series,_)=>DateFormat('dd/MM/yyyy').parse(("01/01/" +series.series.toString())),
        measureFn:  (Coordinates series,_)=>series.category,
      )
    ];

    return Container(
        height:400,
        padding: EdgeInsets.all(20),
        child:Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children:<Widget>[
                Text('Wage Rate Per year'),
                Expanded(
                    child: charts.TimeSeriesChart(series,
                        animate: true,
                    ))
              ],
            ),
          ),
        )

    );
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
            Coordinates(element.propertyValue, element.finYear,element.cpiIndex));
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
