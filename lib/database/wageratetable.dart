import 'package:path/path.dart';
import 'package:cbatracker/domain/todo.dart';
import 'package:cbatracker/model/wagerate.dart';
import 'package:cbatracker/service/dashboarditemservice.dart';
import 'package:cbatracker/service/wagerateservice.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class WageRateTable{
static final _databaseName = "todo.db";
static final _databaseVersion =1;

static final table='wagerate';
static final columnId='id';
static final columnGradingSystem= 'gradingSystem';
static final columnFinYear= 'finYear';
static final columnGrade= 'grade';
static final columnOrdinal= 'ordinal';
static final columnSubSector= 'subSector';
static final columnOccupation= 'occupation';
static final columnOccupationGroup= 'occupationGroup';
static final columnOccupationGroupId= 'occupationGroupId';
static final columnFinYearId= 'finYearId';
static final columnEmploymentCondition= 'employmentCondition';
static final columnAmount= 'amount';
static final columnOccupationId= 'occupationId';
static final columnPropertyValue= 'propertyValue';
static final columnAveragePropertyValue= 'averagePropertyValue';
static final columnIsPrefix= 'isPrefix';
static final columnMeasurementUnit= 'measurementUnit';
static final columnSymbol= 'symbol';
static final columnCpiIndex= 'cpiIndex';



WageRateTable._privateConstructor();
static final WageRateTable instance = WageRateTable._privateConstructor();

static Database _database;
Future<Database> get database async{

  if(_database!=null)return _database;
  _database = await _initDatabase();
  return _database;

}

_initDatabase() async{
  String path= join(await getDatabasesPath(),_databaseName);
  return await openDatabase(path,
  version: _databaseVersion,
  onCreate: _onCreate);
}

//SQL Code to create the database table
Future _onCreate(Database db,int version)async{

}

Future<int> insert(WageRateResultSet todo) async{
  Database db = await instance.database;
  var res = await db.insert(table,todo.toMap());
  return res;
}
Future<List<Map<String,dynamic>>> queryAllRows() async{
  print('get database wagerate');
  Database db = await instance.database;

  var res = await db.query(table,orderBy: columnOrdinal);
  return res;
}
Future<int> delete(int id) async{
  Database db = await instance.database;
  return await db.delete(table,where:'$columnId=?',whereArgs:[id]);
}

Future<void> clearTable()async{
  Database db = await instance.database;
  return await db.rawQuery('DELETE FROM $table');
}

  Future<List<Map<String,dynamic>>> getWageRateByParentId(int parentId) async {


    var resultSet = await queryAllRows();
    print(resultSet.length);
    if(resultSet.length == 0) {
      WageRateService modelSrv = new WageRateService();
      var subsectorList = await modelSrv.fetchEntityList(parentId);
      await (subsectorList).map((employee) {
         insert(employee);
      }).toList();
      resultSet = await queryAllRows();
    }

    return resultSet;
  }
}