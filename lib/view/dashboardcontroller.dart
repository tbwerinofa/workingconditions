import 'package:flutter/material.dart';
import 'package:sectorworkingcondition/domain/todo.dart';
import 'package:sectorworkingcondition/database/databasehelper.dart';
import 'package:sectorworkingcondition/view/subsectorcontroller.dart';

class DashBoardController extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Working Conditions',
      theme:ThemeData(
        primarySwatch: Colors.blue,
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
  List<Todo> taskList = new List();
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
          title: new Text('Sub Sector'),
        ),
        body: GetRequestList()
    );
  }

  /*
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(widget.title),
      ),
      body:Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.all(16),
        child:Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    child: TextFormField(
                      decoration:InputDecoration(hintText: "Enter a task"),
                      controller: textController,

                    )),
                IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _addToDb)
              ],
            ),
            SizedBox(height:20),
            Expanded(
                child: Container(
                  child: taskList.isEmpty
                      ?Container()
                      :ListView.builder(itemBuilder: (ctx,index){
                        if(index == taskList.length)return null;
                        return ListTile(
                          title: Text(taskList[index].title),
                          leading: Text(taskList[index].id.toString()),
                          trailing:IconButton(
                            icon:Icon(Icons.delete),
                            onPressed:()=>_deleteTask(taskList[index].id),
                          )
                        );
                  }
                  )
                ))
          ],
        )
      )
    );
  }
*/
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
        itemCount:1,
        itemBuilder: (context,index) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
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
        itemCount: entityList.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: ListTile(
               // leading: _displayByStyle(),
                trailing: Icon(Icons.arrow_forward_ios),
                title: Text(
                    taskList[index].title),
                onTap: () {
                  print('navigate');


                  navigateToRequest(taskList[index]);
                },
              ),
              //subtitle: Text('Request No: ${entityList[index].requestNo}'),
            ),
          );
        },
      );
    }
  }

  void navigateToRequest(Todo entity) async{
    print('about to navigate');
    print(entity.id);

    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => SubSectorController(parentEntity: entity))
    );
  }


  void ReadAll(List<Map<String,dynamic>> entityList)
  {
        entityList.forEach((element){
          taskList.add(Todo(id:element['id'],
              title:element['title']));
    });
  }
}

