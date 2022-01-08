import 'package:cbatracker/domain/widgetbuilder.dart';
import 'package:cbatracker/view/disclaimercontroller.dart';
import 'package:cbatracker/view/placeholdercontroller.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:cbatracker/domain/todo.dart';
import 'package:cbatracker/database/databasehelper.dart';
import 'package:cbatracker/view/occupationcontroller.dart';
import 'package:cbatracker/view/subsectorcontroller.dart';

class DashBoardController extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CBA Tracker',
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
          ]),
      bottomNavigationBar: _buildBottomNavigationBar(),
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
      return
        SingleChildScrollView(
          scrollDirection: Axis.vertical,

          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
          Expanded(
          child:
            ListView.builder(
        itemCount:taskList.length,
        itemBuilder: (context,index) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            margin: EdgeInsets.fromLTRB(0,2,5,5),
            child:  ListTile(
                title: taskList ==null
                    ?Text("Issue Retrieving Subsectors!")
                    :Text("No Subsectors!") ,
                onTap: () {
                  if(taskList ==null) {
                    //navigateToLogin();
                  }
                },
            ),
          );

        } ))]),
      );
    }
    else {
      return Expanded(
        child:
      ListView.builder(
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
      ),
      );
    }
  }

  Widget _bodyRowList(Todo entity) {
    return DataTable(
      dividerThickness: 1,
      columnSpacing: 2,
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
                  navigateToWageRate(entity)
                },
                child:Text('Wage Rates'),
              ),
            ),
            DataCell(
              ElevatedButton(
                onPressed: () =>
                {
                  navigateToOccupation(entity)
                },
                child:Text('Task Grades'),
              ),
            ),
          ],
        ),
        DataRow(
          cells: [
            DataCell(
              ElevatedButton(
                onPressed: () =>
                {
                  navigatePlaceHolder('Labour Conditions')
                },
                child:Text('Labour Conditions'),
              ),
            ),
            DataCell(
              ElevatedButton(

                onPressed: () =>
                {
                  navigatePlaceHolder('Compliance')
                },
                child:Text('Compliance'),
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

  void navigatePlaceHolder(String target) async{
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => PlaceHolderController(pageTitle:target))
    );
  }
  void navigateDisclaimer() async{
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => DiscliamerController())
    );
  }

  void ReadAll(List<Map<String,dynamic>> entityList)
  {
         entityList.forEach((element){
          taskList.add(Todo(id:element['id'],
              title:element['title']));
    });
  }

  Widget _buildBottomNavigationBar(){
    return BottomAppBar(

      child: RaisedButton(
        color: Colors.blueAccent,
        textColor: Colors.white,
        child: Text('Disclaimer'),
        onPressed: (){
          navigateDisclaimer();
        },
      ),

    );
  }
}

