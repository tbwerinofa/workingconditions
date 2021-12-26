import 'package:path/path.dart';
import 'package:sectorworkingcondition/domain/todo.dart';
import 'package:sectorworkingcondition/model/wagerate.dart';
import 'package:sectorworkingcondition/service/dashboarditemservice.dart';
import 'package:sectorworkingcondition/service/wagerateservice.dart';
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
  await db.execute('''
        CREATE TABLE $table(
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnGradingSystem TEXT NOT NULL,
        $columnFinYear  INTEGER NOT NULL,
        $columnGrade TEXT NOT NULL,
        $columnOrdinal  INTEGER NULL,
        $columnSubSector TEXT NOT NULL,
        $columnOccupation TEXT NULL,
        $columnOccupationGroup TEXT NULL,
        $columnOccupationGroupId  INTEGER NULL,
        $columnFinYearId INTEGER NOT NULL,
        $columnEmploymentCondition TEXT NOT NULL,
        $columnAmount REAL NOT NULL,
        $columnOccupationId  INTEGER NULL,
        $columnPropertyValue REAL NOT NULL,
        $columnAveragePropertyValue REAL NULL,
        $columnIsPrefix INTEGER NOT NULL,
        $columnMeasurementUnit TEXT NOT NULL,
        $columnSymbol TEXT NOT NULL,
        $columnCpiIndex  INTEGER NOT NULL
        )
        ''');
}

Future<int> insert(WageRateResultSet todo) async{
  Database db = await instance.database;
  var res = await db.insert(table,todo.toMap());
  return res;
}
Future<List<Map<String,dynamic>>> queryAllRows() async{
  print('get database wagerate');
  Database db = await instance.database;

  var res = await db.query(table,orderBy:"$columnId DESC");
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
      print('fetch wage rates');
      print(parentId);
      print(subsectorList.length);


      await (subsectorList).map((employee) {
         insert(employee);

      }).toList();
    }
    print('from database');
    print(resultSet);
    resultSet = await queryAllRows();
    return resultSet;
  }
}