import 'package:flutter/material.dart';
import 'package:sectorworkingcondition/domain/todo.dart';
import 'package:sectorworkingcondition/database/databasehelper.dart';

class SubSectorLegacyController extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Working Conditions',
      theme:ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      home:SubSectorLegacyPage(title:'Listify')
    );
  }
}

class SubSectorLegacyPage extends StatefulWidget {
  SubSectorLegacyPage ({Key key,this.title}) : super(key: key);

  final String title;

  @override
  _SubSectorLegacyPage createState() => _SubSectorLegacyPage();
}

class _SubSectorLegacyPage extends State<SubSectorLegacyPage> {
  TextEditingController textController = new TextEditingController();
  List<Todo> taskList = new List();
  final dbHelper = DatabaseHelper.instance;
  @override
  void initState()
  {
    super.initState();
    ReadAll();
  }

  @override
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

  void ReadAll()
  {
    dbHelper.getAllSubSectors().then((value){
      setState((){
        value.forEach((element){
          taskList.add(Todo(id:element['id'],
              title:element['title']));
        });
      });
    }).catchError((error){
      print(error);
    });
  }

  void _addToDb() async{
    String task = textController.text;
    var id = await dbHelper.insert(Todo(title:task));

    setState((){
      taskList.insert(0,Todo(id:id,title:task));
    });
  }

  void _deleteTask(int id)async{
    await dbHelper.delete(id);
    setState((){
      taskList.removeWhere((element)=> element.id == id);
    });
  }
}

