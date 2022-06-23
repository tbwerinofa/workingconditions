import 'package:path/path.dart';
import 'package:cbatracker/database/wageratetable.dart';
import 'package:cbatracker/domain/todo.dart';
import 'package:cbatracker/service/dashboarditemservice.dart';
import 'package:cbatracker/service/wagerateservice.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DatabaseHelper{
static final _databaseName = "todo.db";
static final _databaseVersion =1;

static final table='todo';
static final columnId='id';
static final columnTitle='title';

static final wageratetable='wagerate';
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

DatabaseHelper._privateConstructor();
static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

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

  //fetch data
}

//SQL Code to create the database table
Future _onCreate(Database db,int version)async{
  await db.execute('''
        CREATE TABLE $table(
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTitle FLOAT NOT NULL
        )
        ''');

  await db.execute('''
        CREATE TABLE $wageratetable(
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
        $columnCpiIndex  REAL NOT NULL
        )
        ''');
}

Future<int> insert(Todo todo) async{
  Database db = await instance.database;
  var res = await db.insert(table,todo.toMap());
  return res;
}
Future<List<Map<String,dynamic>>> queryAllRows() async{
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

  Future<List<Map<String,dynamic>>> getAllSubSectors() async {

    List<int> subSectorIds = new List<int>();
    var resultSet = await queryAllRows();
    if(resultSet.length == 0) {
      await loadSubSectors(subSectorIds);
    }

    resultSet = await queryAllRows();
    if(subSectorIds.length >0)
      {
        await loadWageRates(subSectorIds);
      }

    return resultSet;
  }

  Future<void> loadSubSectors(List<int> entityList)async
  {
    DashBoardItemService modelSrv = new DashBoardItemService();
    var subsetList = await modelSrv.fetchEntityList();

    (subsetList).map((record) {
      Todo entity = new Todo(id:record.id,title:record.name);
      insert(entity);
      entityList.add(record.id);

    }).toList();
  }

  Future<void> loadWageRates(List<int> entityList)async
  {
    final dbHelper = WageRateTable.instance;
     await entityList.forEach((element){
      dbHelper.getWageRateByParentId(element);
    });
  }

}