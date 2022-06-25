import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../database/wageratetable.dart';
import '../domain/todo.dart';
import '../domain/viewhelper.dart';
import '../helpers/DecimalTextInputFormatter.dart';
import '../model/myrategenerate.dart';
import '../model/wagerate.dart';
import '../service/myrateservice.dart';
import 'myrateresultcontroller.dart';
import "package:collection/collection.dart";
class MyRateController extends StatefulWidget {
  MyRateController({this.parentEntity,this.entityList});
  final Todo parentEntity;
  final List<Map<String,dynamic>> entityList;
  @override
  _MyRateControllerState createState() => _MyRateControllerState(parentEntity:this.parentEntity,entityList:entityList);
}



class _MyRateControllerState extends State<MyRateController> {
  _MyRateControllerState({this.parentEntity,this.entityList});
  final Todo parentEntity;
  final List<Map<String,dynamic>> entityList;
  MyRateService repo = MyRateService();

  List<String> _states = ["Choose occupation group"];
  List<String> _lgas = ["Choose occupation.."];
  String _selectedState = "Choose occupation group";
  String _selectedLGA = "Choose occupation..";
  bool _isInAsyncCall = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  List<WageRateResultSet> _taskList = new  List<WageRateResultSet>();
  List<int> _gradeSet = [];
  final dbHelper = WageRateTable.instance;
  MyRateGenerate newEntity = new MyRateGenerate('',0,0,'','',0,0,0,0,0);
  @override
  void initState() {
    newEntity.sector =parentEntity.title;

    _states.addAll(ViewHelper.GenerateOccupationGroupList(entityList));

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key:_scaffoldKey,
      appBar: new AppBar(
        title: new Text('Sector: '+parentEntity.title),
        leading: Icon(Icons.filter_vintage),
      ),
      body:_buildBody(context)


    //bottomNavigationBar: _buildBottomNavigationBarItem(),
    );
  }


  SingleChildScrollView  _buildClaimByMilestoneGrid(List<Map<String,dynamic>> entityList,BuildContext context){

    ReadAll(entityList);
    if (_taskList == null) {
      return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ListView.builder(
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
                        "No Data"),
                    onTap: () {
                      // navigateToLogin();
                    },
                  ),
                ),
              );
            },
          ));
    }
    else {

      _taskList.sortBy((element) =>  element.occupationGroup);
      final groups = groupBy(_taskList, (WageRateResultSet e) {
        return e.occupationGroup;
      });

      return  _buildBody(context);


    }
  }



  void  FetchOccupationList(List<Map<String,dynamic>> entityList){

    ReadAll(entityList);
    if (_taskList != null) {
      _taskList.sortBy((element) =>  element.occupationGroup);
      final groups = groupBy(_taskList, (WageRateResultSet e) {
        return e.occupationGroup;
      });

      groups.entries.forEach((element) {
        _states.add(element.key);
      });

    }
  }

  void ReadAll(List<Map<String,dynamic>> entityList)
  {
    _taskList = entityList.map((model)=> WageRateResultSet.fromDatabase(model)).toList();
  }

  SingleChildScrollView _buildBody(BuildContext context)
  {


    return  SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Form(
        key: _loginFormKey,
        child: Column(
          children: <Widget>[
            Text(
              "Calculate My Rate ",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            //styling
            DropdownButton<String>(
              isExpanded: true,
              items: _states.map((String dropDownStringItem) {
                return DropdownMenuItem<String>(
                  value: dropDownStringItem,
                  child: Text(dropDownStringItem),
                );
              }).toList(),
              onChanged: (value) => _onSelectedState(value),
              value: _selectedState,
            ),
            DropdownButton<String>(
              isExpanded: true,
              items: _lgas.map((String dropDownStringItem) {
                return DropdownMenuItem<String>(
                  value: dropDownStringItem,
                  child: Text(dropDownStringItem),
                );
              }).toList(),
              // onChanged: (value) => print(value),
              onChanged: (value) => _onSelectedLGA(value),
              value: _selectedLGA,
            ),
            //styling
            TextFormField(
              decoration: InputDecoration(labelText: 'How many days a week do you work?'),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onFieldSubmitted: (value) {
                //Validator
              },
              onSaved: (val)=> newEntity.dayCount =int.tryParse(val),
              validator: weekValidator
            ),

            TextFormField(
                decoration: InputDecoration(labelText: 'How many hours a day you work?'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onFieldSubmitted: (value) {
                  //Validator
                },
                onSaved: (val)=> newEntity.hourCount =int.tryParse(val),
                validator: hourValidator
            ),
            TextFormField(
                decoration: InputDecoration(labelText: 'What is your rate in (Rands) per hour?'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters:[DecimalTextInputFormatter(decimalRange: 2)],
                onFieldSubmitted: (value) {
                  //Validator
                },
                onSaved: (val)=> newEntity.currentRate =num.tryParse(val),
                validator: rateValidator
            ),
            Padding(
                padding: const EdgeInsets.all(32.0),
                child:
                Row(children: <Widget>[

                  Expanded(
                    child: RaisedButton(
                      onPressed: () {
                        if (_loginFormKey.currentState.validate()) {
                          _loginFormKey.currentState.save();
                          _submit();
                        }
                      },
                      child: Text('Generate'),
                      color: Colors.blue,
                      textColor: Colors.white,
                      splashColor: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child:RaisedButton(
                      onPressed: () {
                        setState(() {
                          _loginFormKey.currentState.reset();
                        });
                      },
                      child: Text('Refresh'),
                      color: Colors.white,
                      textColor: Colors.black,
                      splashColor: Colors.grey,
                    ),
                  ),
                ],
                )
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    bool isValid = true;
    if (newEntity.occupationGroup == null) {
      showMessage("select occupation group",Colors.red);
      isValid = false;
    }

    if (newEntity.occupation == null) {
      showMessage("select occupation",Colors.red);
      isValid = false;
    }

    if (newEntity.currentRate < num.tryParse('1') || newEntity.currentRate > num.tryParse('500')) {
      showMessage("must be between 1 and 500",Colors.red);
      isValid = false;
    }
    if (newEntity.dayCount < 1 || newEntity.dayCount > 7) {
      showMessage("must be between 1 and 7",Colors.red);
      isValid = false;
    }
    if (newEntity.hourCount < 1 || newEntity.hourCount > 24) {
      showMessage("must be between 1 and 24",Colors.red);
      isValid = false;
    }

    if (isValid)
    {   //_loginFormKey.currentState?.validate();
      if (_loginFormKey.currentState.validate()) {
        _loginFormKey.currentState.save();

        // dismiss keyboard during async call
        FocusScope.of(context).requestFocus(new FocusNode());

        // start the modal progress HUD
        setState(() {
          _isInAsyncCall = true;
        });

        // Simulate a service call
        Future.delayed(Duration(seconds: 1), () {
          //save to rest
          setState(() {

            _navNext(context, newEntity);


            _isInAsyncCall = false;
          });
        });
      }
    }
  }

  void _navNext(BuildContext context,MyRateGenerate newEntity)
  {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MyRateResultController(parentEntity:newEntity))
    );

  }
  void showMessage(String message,[MaterialColor color = Colors.red])
  {
    if(message == null)
      message="Error during save, please try again!!";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );

  }
  String rateValidator(String value) {
    if(value == null) {
      return null;
    }
    final n = num.tryParse(value);
    if(n == null) {
      return '"$value" is not a valid number';
    }else{
      if (n < 1 || n >500) {
        return 'must be between 1 and 500';
      }
    }
    return null;
  }
  String hourValidator(String value) {
    if(value == null) {
      return null;
    }
    final n = int.tryParse(value);
    if(n == null) {
      return '"$value" is not a valid number';
    }else{
      if (n < 1 || n >24) {
        return 'must be between 1 and 24';
      }
    }
    return null;
  }
  String weekValidator(String value) {
    if(value == null) {
      return null;
    }
    final n = int.tryParse(value);
    if(n == null) {
      return '"$value" is not a valid number';
    }else{
        if (n < 1 || n >7) {
          return 'must be between 1 and 7';
        }
      }
    return null;
  }

  void _onSelectedState(String value) {
    setState(() {
      _selectedLGA = "Choose ..";
      _lgas = ["Choose .."];
      _selectedState = value;

      var record = _states.firstWhere((element) => element == value);

      _lgas.addAll(ViewHelper.GetOccupationList(entityList,record));

      newEntity.occupationGroup = record;

    });
  }

  void _onSelectedLGA(String value) {
    setState(() => _selectedLGA = value);
    var record = _lgas.firstWhere((element)=>element == value);
    var occupation = ViewHelper.GetOccupation(entityList,record);
    newEntity.occupation = record;
    newEntity.finYear =occupation.finYear;
    newEntity.amount =occupation.amount;
  }
}

