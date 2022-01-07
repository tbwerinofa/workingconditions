import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:sectorworkingcondition/domain/todo.dart';
import 'package:sectorworkingcondition/database/databasehelper.dart';
import 'package:sectorworkingcondition/model/coordinates.dart';
import 'package:sectorworkingcondition/view/occupationcontroller.dart';
import 'package:sectorworkingcondition/view/subsectorcontroller.dart';

class DashBoardController extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Working Conditions',
      theme:ThemeData(
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      home:DashBoardPage(title:'Wage Rate By Sub-Sector')
    );
  }
}

class DashBoardPage extends StatefulWidget {
  DashBoardPage ({Key key,this.title}) : super(key: key);

  final String title;

  @override
  _DashBoardPage createState() => _DashBoardPage();
}

class _DashBoardPage extends State<DashBoardPage> {
  TextEditingController textController = new TextEditingController();
  Set<Todo> taskList = new Set();
  final dbHelper = DatabaseHelper.instance;
  @override
  void initState()
  {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Working Condition Dashboard'),
        ),
        drawer: new Drawer(),
        body: Column(
            children: [
              GetRequestList(),
             // BuildFooter()
        ]),
      backgroundColor: Colors.grey,
    );
  }

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

              print('has error');
              return new Text(
                '${snapshot.error}',
                style: TextStyle(color: Colors.red),
              );
            } else {

              return _buildRequestList(snapshot.data);
            }
        }},


      future: dbHelper.getAllSubSectors(),
    );
  }



  Widget _buildRequestList(List<Map<String,dynamic>> entityList){

    ReadAll(entityList);

    if(taskList ==null || taskList.length == 0)
    {
      return ListView.builder(
        itemCount:taskList.length,
        itemBuilder: (context,index) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            margin: EdgeInsets.fromLTRB(0,2,5,5),
            child: ListTile(
              title: ListTile(
                title: taskList ==null
                    ?Text("Issue Retrieving Subsectors!")
                    :Text("No Subsectors!") ,
                onTap: () {
                  if(taskList ==null) {
                    //navigateToLogin();
                  }
                },
              ),
            ),
          );
        },
      );
    }
    else {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: entityList.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child:  _bodyRowList(taskList.elementAt(index)),

          );
        },
      );
    }
  }

  Widget _bodyRowList(Todo entity) {
    return DataTable(
      dividerThickness: 1,
      columnSpacing: 1,
      columns: [
        DataColumn(label: Text('')),
        DataColumn(label: Text(''))
      ],
      rows: [
        DataRow(
          cells: [
            DataCell(Text('Sub-Sector')),
             DataCell(Text(entity.title)),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text('Signatories')),
            DataCell(Text
              ('BCCEI,SAFEC,NUM,BCAWU',
              overflow: TextOverflow.ellipsis,)),
          ],
        ),
        DataRow(
          cells: [
            DataCell(
              ElevatedButton(
                onPressed: () =>
                {
                  navigateToOccupation(entity)
                },
                child:Text('Occupations'),
              ),
            ),
            DataCell(
              ElevatedButton(
                onPressed: () =>
                {
                  navigateToWageRate(entity)
                },
                child:Text('Wage Rates'),
              ),
            ),

          ],
        ),

      ],
    );
  }

  void navigateToWageRate(Todo entity) async{
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => SubSectorController(parentEntity: entity))
    );
  }

  void navigateToOccupation(Todo entity) async{
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => OccupationController(parentEntity: entity))
    );
  }
  void ReadAll(List<Map<String,dynamic>> entityList)
  {
         entityList.forEach((element){
          taskList.add(Todo(id:element['id'],
              title:element['title']));
    });
  }

  Widget BuildFooter()
  {
    return FooterView(
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(top:50,left: 70),
                child: new Text('Scrollable View Section'),
              )
            ],
          ),
        ],
        footer: new Footer(
          child: new Padding(
            padding: EdgeInsets.all(5.0),
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:<Widget>[
                  new Center(
                    child:new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Container(
                            height: 45.0,
                            width: 45.0,
                            child: Center(
                              child:Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0), // half of height and width of Image
                                ),
                                child: IconButton(
                                  icon: new Icon(Icons.audiotrack,size: 20.0,),
                                  color: Color(0xFF162A49),
                                  onPressed: () {},
                                ),
                              ),
                            )
                        ),
                        new Container(
                            height: 45.0,
                            width: 45.0,
                            child: Center(
                              child:Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0), // half of height and width of Image
                                ),
                                child: IconButton(
                                  icon: new Icon(Icons.fingerprint,size: 20.0,),
                                  color: Color(0xFF162A49),
                                  onPressed: () {},
                                ),
                              ),
                            )
                        ),
                        new Container(
                            height: 45.0,
                            width: 45.0,
                            child: Center(
                              child:Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0), // half of height and width of Image
                                ),
                                child: IconButton(
                                  icon: new Icon(Icons.call,size: 20.0,),
                                  color: Color(0xFF162A49),
                                  onPressed: () {},
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  ),

                  Text('Copyright ©2020, All Rights Reserved.',style: TextStyle(fontWeight:FontWeight.w300, fontSize: 12.0, color: Color(0xFF162A49)),),
                  Text('Powered by Nexsport',style: TextStyle(fontWeight:FontWeight.w300, fontSize: 12.0,color: Color(0xFF162A49)),),
                ]
            ),
          ),
        )
    );
  }
}

