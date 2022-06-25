import 'package:flutter/material.dart';
import 'package:cbatracker/domain/viewhelper.dart';
import 'package:cbatracker/model/resultset.dart';
import 'package:cbatracker/model/wagerate.dart';
import 'package:collection/collection.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cbatracker/model/coordinates.dart';
import 'package:intl/intl.dart';

import '../model/myrategenerate.dart';
import 'artutil.dart';

class MyRateResultController extends StatefulWidget {
  MyRateResultController({this.parentEntity});
  final MyRateGenerate parentEntity;

  @override
  _MyRateResultControllerState createState() => _MyRateResultControllerState(parentEntity:this.parentEntity);
}

class _MyRateResultControllerState extends State<MyRateResultController> {
  _MyRateResultControllerState({this.parentEntity});
  final MyRateGenerate parentEntity;

  List<Coordinates> _coordinates = new List<Coordinates>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key:_scaffoldKey,
      appBar: new AppBar(
        title: new Text('My Rate: '+ parentEntity.occupation),
        leading: Icon(Icons.filter_vintage),
      ),
      body:Column(
          children: [
            _buildMyRateSummary(),
            _buildMyRateDetail()

          ])
    );
  }
  Widget _buildMyRateSummary(){

      return Expanded(
        child:
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white,
              elevation: 2.0,
              child:
                _bodySummaryRowList(),
            );
          },
        ),
      );
  }
  Widget _buildMyRateDetail(){

    return Expanded(
      child:
      ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 1,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child:  _BuildMyRate(),

          );
        },
      ),
    );
  }
  Widget _bodySummaryRowList() {
    return DataTable(
      dividerThickness: 1,
      columnSpacing: 3,
      columns: [
        DataColumn(label: Text('')),
        DataColumn(label: Text(''))
      ],
      rows: [
        DataRow(
          cells: [
            DataCell(Text('Group')),
            DataCell(Text(parentEntity.occupationGroup)),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text('Occupation')),
            DataCell(Text
              (parentEntity.occupation,
              overflow: TextOverflow.ellipsis,)),
          ],
        ),
        DataRow(
          cells: [

            DataCell(Text('Year')),
            DataCell(Text
              (parentEntity.finYear.toString(),
              overflow: TextOverflow.ellipsis,)),
          ],
        ),
        DataRow(
          cells: [

            DataCell(Text('Rate/per hour')),
            DataCell(Text(  'R '+  parentEntity.amount.toStringAsFixed(2))),
          ],
        ),
        DataRow(
          cells: [

            DataCell(Text('')),
            DataCell(Text( parentEntity.amount> parentEntity.currentRate
                ?'You earn below agreed rate'
                :'Your rate is compliant')),
          ],
        ),
      ],
    );
  }

  Widget  _BuildMyRate(){

    return Row(
        children: <Widget>[Expanded(
            child:
            SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child:DataTable(
                    dividerThickness: 1,
                    sortColumnIndex: 0,
                    sortAscending: false,
                    columnSpacing: 1,
                    columns: [
                      DataColumn(
                        label:Text(
                            'Rate',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 16.0,
                            )),
                      ),
                      DataColumn(
                        label: Text(
                          'Value',
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 16.0,
                          ),
                        ),

                      ),
                      DataColumn(
                        label: Text(
                          'Total',
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Expected',
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 16.0,
                          ),
                        ),
                      ),

                      DataColumn(
                        label: Text(
                          'Variance',
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 16.0,
                          ),
                        ),
                      ),

                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(
                              Container(
                                child:
                                Text(
                                  'Hourly',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )),
                          DataCell(
                            Text(
                              parentEntity.currentRate.toStringAsFixed(2),
                            ),
                          ),
                          DataCell(
                            Text(
                              'R '+  parentEntity.currentRate.toStringAsFixed(2),
                            ),
                          ),
                          DataCell(
                            Text(
                              'R '+  parentEntity.amount.toStringAsFixed(2),
                            ),
                          ),
                          DataCell(
                            Text(
                              'R '+  (parentEntity.currentRate - parentEntity.amount).toStringAsFixed(2),
                            ),
                          )
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                              Container(
                                child:
                                Text(
                                  'Daily',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )),
                          DataCell(
                            Text(
                              parentEntity.hourCount.toString(),
                            ),
                          ),
                          DataCell(
                            Text(
                              'R '+ (parentEntity.hourCount *  parentEntity.currentRate).toStringAsFixed(2),
                            ),
                          ),
                          DataCell(
                            Text(
                              'R '+ (parentEntity.hourCount *  parentEntity.amount).toStringAsFixed(2),
                            ),
                          ),
                          DataCell(
                            Text(
                              'R '+ (parentEntity.hourCount *  parentEntity.currentRate
                                  -parentEntity.hourCount *  parentEntity.amount).toStringAsFixed(2),
                            ),
                          )
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                              Container(
                                child:
                                Text(
                                  'Weekly',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )),
                          DataCell(
                            Text(
                              parentEntity.dayCount.toString(),
                            ),
                          ),
                          DataCell(
                            Text(
                              'R '+   (parentEntity.hourCount * parentEntity.dayCount *  parentEntity.currentRate).toStringAsFixed(2),
                            ),
                          ),
                          DataCell(
                            Text(
                              'R '+ (parentEntity.hourCount * parentEntity.dayCount *  parentEntity.amount).toStringAsFixed(2),
                            ),
                          ),
                          DataCell(
                            Text(
                              'R '+ (parentEntity.hourCount * parentEntity.dayCount *  parentEntity.currentRate
                                      -parentEntity.hourCount * parentEntity.dayCount *  parentEntity.amount).toStringAsFixed(2),
                            ),
                          )
                        ],
                      ),
                  ],
                    )))]);
  }



}
