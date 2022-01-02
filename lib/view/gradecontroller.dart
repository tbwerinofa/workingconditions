import 'package:flutter/material.dart';
import 'package:sectorworkingcondition/model/resultset.dart';
import 'package:sectorworkingcondition/model/wagerate.dart';
import 'package:collection/collection.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:sectorworkingcondition/model/coordinates.dart';
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
          primarySwatch: Colors.yellow,
        ),
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
            key:_scaffoldKey,
            appBar: AppBar(
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
          ),
        ),
      );
    }
    /*
    return new Scaffold(
      key:_scaffoldKey,
      appBar: _buildAppBar(),
      body: _buildClaimByMilestoneGrid(),

    );
    */


  Widget _buildAppBar(){
    return AppBar(

        title: Text("Grade : ${parentEntity}"));
  }

  void ReadAll()
  {

    parentEntityList.forEach((element) {
      _coordinates.add(Coordinates(element.amount,element.finYear));
    });


  }
  SingleChildScrollView  _buildClaimByMilestoneGrid(){
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildBarChart(),
              _buildAnnualList(),
             _buildOccupationGroupList(),
            ]));
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

                        var displayText = record + ' (' + parentEntityList.where((element) => element.occupationGroup == record).length.toString() + ')';
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

                                       var resultset = parentEntityList.where((element) => element.occupationGroup== dynamicContent).toList();
                                        return new Card(
                                            child: _buildOccupationList(resultset)
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
                                'Name',
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),

                          ],
                          rows: resultSet
                              .map(
                                (entity) => DataRow(
                              cells: [
                                DataCell(
                                  Container(

                                    child: Text(
                                      entity.occupation,
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
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                          dataRowHeight: 40,
                          dividerThickness: 3,
                          showCheckboxColumn: false,
                          columnSpacing: 10.0,
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
                                'Amount',
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),

                          ],
                          rows: parentEntityList
                              .map(
                                (entity) => DataRow(

                              cells: [
                                DataCell(

                                  Container(

                                    child: Text(
                                      entity.finYear.toString(),
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(

                                    child: Text(
                                      'R ' + entity.amount.toStringAsFixed(2),
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


}
