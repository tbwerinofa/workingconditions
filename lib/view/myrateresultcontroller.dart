import 'package:flutter/material.dart';
import 'package:cbatracker/model/coordinates.dart';
import '../model/myrategenerate.dart';
import 'controllerhelper.dart';

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
  bool isNegative = false;
  @override
  void initState() {
   isNegative = parentEntity.currentRate > parentEntity.amount;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'My Calculated Rate',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home:Scaffold(
      key:_scaffoldKey,
      appBar: new AppBar(
        title: new Text('My Calculated Rate'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:Column(
          children: [
            _buildMyRateSummary(),
            _buildMyRateDetail()

          ]),
          bottomNavigationBar: ControllerHelper.buildBottomNavigationBar(context),
          backgroundColor: Colors.grey,
    ));
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
        itemCount: 3,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            elevation: 2.0,

            child:
            Column(
                children: [
                  _BuildMyRateTile(index),
                  _BuildMyRate(index)
                ]),

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
            DataCell(TextStyleFormat( parentEntity.amount> parentEntity.currentRate
                ?'You earn below agreed wage rate'
                :'Your wage rate is compliant')),
          ],
        ),
      ],
    );
  }

  Widget  _BuildMyRateTile(index){
    if(index == 0)
    {
      return RowStyleFormat('Wage per Hour','R ' + parentEntity.currentRate.toStringAsFixed(2) +'/per hour');
    }
    else if(index == 1)
    {
      return RowStyleFormat('Wage per day',parentEntity.hourCount.toString() +' hour day');
    }
    else
    {
      return RowStyleFormat('Wage per week',parentEntity.hourCount.toString() +' day week');

    }
  }
  Widget  _BuildMyRate(index){
    if(index == 0)
      {

        return _buildRateGriRate('R '+ parentEntity.currentRate.toStringAsFixed(2)
                                  ,'R '+ parentEntity.amount.toStringAsFixed(2)
                                  , 'R '+  (parentEntity.currentRate - parentEntity.amount).toStringAsFixed(2));
       }
    else if(index == 1)
    {
   return  _buildRateGriRate('R '+ (parentEntity.hourCount *  parentEntity.currentRate).toStringAsFixed(2)
    ,'R '+ (parentEntity.hourCount *  parentEntity.amount).toStringAsFixed(2)
    ,'R '+ (parentEntity.hourCount *  parentEntity.currentRate
    -parentEntity.hourCount *  parentEntity.amount).toStringAsFixed(2));
    }
    else
    {
      return  _buildRateGriRate('R '+ (parentEntity.hourCount *parentEntity.dayCount *  parentEntity.currentRate).toStringAsFixed(2)
          ,'R '+ (parentEntity.hourCount * parentEntity.dayCount *  parentEntity.amount).toStringAsFixed(2)
          ,'R '+ (parentEntity.hourCount  * parentEntity.dayCount *  parentEntity.currentRate
              -parentEntity.hourCount  * parentEntity.dayCount *  parentEntity.amount).toStringAsFixed(2));
    }
  }

 Widget TextStyleFormat(value)
 {
   var _isNegative = parentEntity.currentRate < parentEntity.amount;
   return Text(value,
       style: TextStyle(
         color:_isNegative? Colors.red.shade700: Colors.green.shade700,
         fontSize: 16.0,
       ));
 }

  Widget  _buildRateGriRate(value,expected,variance){
       return  Row(
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
                            '',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 16.0,
                            )),
                      ),
                      DataColumn(
                        label: Text(
                          '',
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
                                  'My Rate',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )),
                          DataCell(
                            Text(
                             value
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                              Container(
                                child:
                                Text(
                                  'Expected',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )),
                          DataCell(
                            Text(
                             expected
                            ),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                              Container(
                                child:
                                Text(
                                  'Variance',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )),
                          DataCell(
                            TextStyleFormat(
                              variance
                            ),
                          ),
                        ],
                      ),
                    ],
                  )))]);

  }


 Widget RowStyleFormat(header,subtitle)
 {
   return Row(
       children: <Widget>[Expanded(
           child:
           SingleChildScrollView(
               scrollDirection: Axis.vertical,
               child:ListTile(
                   leading: const Icon(Icons.add),
                   title: Text(
                     header,
                     textScaleFactor: 1.5,
                   ),
                   trailing: const Icon(Icons.done),
                   subtitle: TextStyleFormat(subtitle),
                   selected: true,
                   onTap: () {
                     setState(() {

                     });
                   }
               )
           ))]);
 }
}
