import 'package:flutter/material.dart';
import 'package:sectorworkingcondition/model/wagerate.dart';
import 'package:collection/collection.dart';

class GradeController extends StatefulWidget {
  GradeController({this.parentEntity,this.parentEntityList});
  final WageRateResultSet parentEntity;
  final List<WageRateResultSet> parentEntityList;
  @override
  _GradeControllerState createState() => _GradeControllerState(parentEntity:this.parentEntity,parentEntityList:this.parentEntityList);
}

class _GradeControllerState extends State<GradeController> {
  _GradeControllerState({this.parentEntity,this.parentEntityList});
  final WageRateResultSet parentEntity;
  final List<WageRateResultSet> parentEntityList;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    print('before scaffold');
    print(parentEntity);
    return new Scaffold(
      key:_scaffoldKey,
      appBar: _buildAppBar(),
      body: _buildClaimByMilestoneGrid(),

    );
  }

  Widget _buildAppBar(){
    return AppBar(

        title: Text("Stand No: ${parentEntity.gradingSystem}"));
  }

  SingleChildScrollView  _buildClaimByMilestoneGrid(){
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // _BuildChart(entityList.dashboardItems),
              Padding(
                  padding: EdgeInsets.only(top:10.0
                  ),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                          dataRowHeight: 50,
                          dividerThickness: 5,
                          sortColumnIndex: 0,
                          sortAscending: true,
                          columns: [
                            DataColumn(
                              label: Text(
                                'Grading System',
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ],
                          rows: parentEntityList.take(1)
                              .map(
                                (entity) => DataRow(
                              cells: [
                                DataCell(
                                  Container(
                                    child: Text(
                                      entity.ordinal.toString() + ": " + entity.grade,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).toList()))),
              //_buildMilestoneRuleList(),
             _buildOccupationGroupList(),

            ]));
  }

  Widget _buildMilestoneRuleList(){


    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount:parentEntityList.length,
      itemBuilder: (context,index) {



        return new ListTile(

            title: new Row(
              children: <Widget>[
                new Expanded(child:
                new Text(parentEntityList[index].ordinal.toString() +'. ' +parentEntityList[index].grade)),
              ],
            ));

      },
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
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top:10.0
                  ),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                          dataRowHeight: 40,
                          dividerThickness: 3,
                          showCheckboxColumn: false,
                          columnSpacing: 1.0,
                          sortColumnIndex: 0,
                          sortAscending: true,
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
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).toList())))
            ]));
  }



}
