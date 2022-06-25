import 'package:flutter/material.dart';
import 'package:cbatracker/domain/viewhelper.dart';
import 'package:cbatracker/model/resultset.dart';
import 'package:cbatracker/model/wagerate.dart';
import 'package:collection/collection.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cbatracker/model/coordinates.dart';
import 'package:intl/intl.dart';

import 'artutil.dart';

class GradeController extends StatefulWidget {
  GradeController({this.parentEntity,this.parentEntityList});
  final int parentEntity;
  final List<WageRateResultSet> parentEntityList;
  @override
  _GradeControllerState createState() => _GradeControllerState(parentEntity:this.parentEntity,parentEntityList:this.parentEntityList);
}

class _GradeControllerState extends State<GradeController> {
  _GradeControllerState({this.parentEntity,this.parentEntityList});
  final int parentEntity;
  final List<WageRateResultSet> parentEntityList;
  List<Coordinates> _coordinates = new List<Coordinates>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {

    super.initState();
  }


    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Grade Wage Rate',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
            key:_scaffoldKey,
            appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                centerTitle: true,
                title: Text("Grade : ${parentEntity}",textAlign: TextAlign.center),
                bottom: TabBar(tabs: <Widget>[
                  Tab(icon: Icon(Icons.bar_chart), text: ArtUtil.CARAVAGIO),
                  Tab(icon: Icon(Icons.calendar_today_sharp), text: ArtUtil.MONET),
                  Tab(icon: Icon(Icons.people), text: ArtUtil.VANGOGH),
                ])),
            body: TabBarView(children: <Widget>[
              Container(
                  child: _buildBarChart(),
                  ),
              Container(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _buildAnnualList(),
                          ]))),
              Container(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _buildOccupationGroupList(),
                          ]))),
            ]),
            backgroundColor: Colors.grey,
          ),
        ),
      );
    }

  void ReadAll()
  {

    parentEntityList.forEach((element) {
      _coordinates.add(Coordinates(element.amount,element.finYear,element.cpiIndex));
    });


  }

  Widget _buildBarChart()
  {
    ReadAll();
    List<charts.Series<Coordinates,String>> series =
    [
      charts.Series(
        id:'Hourly Rate By Year',
        data: _coordinates,
        domainFn: (Coordinates series,_)=>series.series.toString(),
        measureFn:  (Coordinates series,_)=>series.category,
        measureLowerBoundFn:  (Coordinates series,_)=>series.value,
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
                    child: charts.BarChart(series,
                        animate: true,
                    ))
              ],
            ),
          ),
        )

    );
  }
  Widget _buildOccupationGroupList() {
    if (parentEntityList == null) {
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
      final groups = groupBy(parentEntityList, (WageRateResultSet e) {
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
                        var occupationList = ViewHelper.GenerateOccupationList(
                            parentEntityList.where((element) => element.occupationGroup == record).toList(),null);
                        var displayText = record + ' (' + occupationList.length.toString() + ')';
                        tabs.add(Tab(
                          child: Text(
                            displayText,
                            style: TextStyle(color: Colors.white),
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
                                        return new Card(
                                            color: Colors.white,
                                            elevation: 2.0,
                                            child: _buildOccupationList(parentEntityList.where((element) => element.occupationGroup== dynamicContent).toList())
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
  SingleChildScrollView  _buildOccupationList(List<WageRateResultSet> resultSet){

    var occupationList = ViewHelper.GenerateOccupationList(resultSet,null);
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child:  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                          dataRowHeight: 40,
                          dividerThickness: 3,
                           sortColumnIndex: 0,
                          sortAscending: false,
                          columns: [
                            DataColumn(
                              label: Text(
                                'Occupation',
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

                                    child: Text(
                                      entity.title,
                                            overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).toList())));
  }
  SingleChildScrollView  _buildAnnualList(){

    var annualList = ViewHelper.GenerateFinYearList(parentEntityList);
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child:
        new Card(
        color: Colors.white,
        elevation: 2.0,
        child:DataTable(
                          dataRowHeight: 40,
                          dividerThickness: 3,
                          showCheckboxColumn: false,
                          sortColumnIndex: 0,
                          sortAscending: true,
                          columns: [
                            DataColumn(

                              label: Text(
                                'Year',
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
                            DataColumn(
                              label: Text(
                                'CPI Index (%)',
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),

                          ],
                          rows: annualList
                              .map(
                                (entity) => DataRow(

                              cells: [
                                DataCell(

                                  Container(

                                    child: Text(
                                      entity.series.toString(),
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(

                                    child: Text(
                                      'R ' + entity.category.toStringAsFixed(2),
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(

                                    child: Text(
                                      entity.value.toStringAsFixed(2),
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).toList()))));
  }


}
