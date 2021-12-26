import 'package:flutter/material.dart';
import 'package:sectorworkingcondition/database/wageratetable.dart';
import 'package:sectorworkingcondition/domain/todo.dart';
import 'package:sectorworkingcondition/model/wagerate.dart';



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
  final dbHelper = WageRateTable.instance;
  @override
  Widget build(BuildContext context) {

    print('before scaffold');
    print(parentEntity);
    return new Scaffold(
      key:_scaffoldKey,
        appBar: new AppBar(
          title: new Text(parentEntity.title + ' Rates'),
        ),
        body: GetRequestList(),
      bottomNavigationBar: _buildBottomNavigationBar(),
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

              return _buildResultList(snapshot.data);
            }
        }},


      future: dbHelper.getWageRateByParentId(parentEntity.id),
    );
  }


  Widget _buildResultList(List<Map<String,dynamic>> entityList) {

    ReadAll(entityList);
    if(_taskList ==null || _taskList.length == 0){
      return ListView.builder(
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
      return ListView.builder(
        itemCount: _taskList.length,
        itemBuilder: (context, index) {
          return Card(
            //color: _toggleColor(entityList[index].isCompliant),
            elevation: 2.0,
            child: ListTile(
              title: ListTile(
              //  leading: _displayByStyle(entityList[index].isCompliant),
                trailing: Icon(Icons.arrow_forward_ios),
                title: Text(
                    'Stand No: ${_taskList[index].gradingSystem}'),
                onTap: () {
                 // navigateToMilestone(entityList, entityList[index]);
                },

              ),
              //subtitle: InspectionSubtitle(entityList[index].hasInspection),
            ),
          );
        },
      );
    }
  }

  Widget _buildBottomNavigationBar(){
    return BottomAppBar(

      child: RaisedButton(
        color: Colors.blueAccent,
        textColor: Colors.white,
        child: Text('Finalise'),
        onPressed: (){
          //FinaliseRequest();
        },
      ),

    );
  }

  Text InspectionSubtitle(bool hasInspection)
  {
    return hasInspection ? Text(

        'Status:Inspected.',
        style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.green))
        :
    Text(
      'Status:New',
      style: TextStyle(
          fontStyle: FontStyle.italic),
    );

  }


  void ReadAll(List<Map<String,dynamic>> entityList)
  {

    _taskList = entityList.map((model)=> WageRateResultSet.fromDatabase(model)).toList();

   }

  Color _toggleColor(bool isCompliant){
    return Colors.white;
  }

  Widget _displayByStyle(bool isCompliant){
    return isCompliant ?Icon(Icons.check_circle):Icon(Icons.account_balance);
  }

  void showMessage(String message,[MaterialColor color = Colors.red])
  {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(
        backgroundColor: color,
        content: new Text(message)));
  }

}
