import 'package:path/path.dart';
import 'package:sectorworkingcondition/database/wageratetable.dart';
import 'package:sectorworkingcondition/domain/todo.dart';
import 'package:sectorworkingcondition/service/dashboarditemservice.dart';
import 'package:sectorworkingcondition/service/wagerateservice.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DatabaseHelper{
static final _databaseName = "todo.db";
static final _databaseVersion =1;

static final table='todo';
static final columnId='id';
static final columnTitle='title';

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
}

//SQL Code to create the database table
Future _onCreate(Database db,int version)async{
  await db.execute('''
        CREATE TABLE $table(
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTitle FLOAT NOT NULL
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

    await clearTable();
    List<int> subSectorIds = new List<int>();
    var resultSet = await queryAllRows();
    print(resultSet.length);
    if(resultSet.length == 0) {
      DashBoardItemService modelSrv = new DashBoardItemService();
      var subsectorList = await modelSrv.fetchEntityList();

      await (subsectorList).map((subsector) {
        Todo entity = new Todo(id:subsector.id,title:subsector.name);
         insert(entity);
        subSectorIds.add(subsector.id);

      }).toList();
    }

    resultSet = await queryAllRows();
    if(subSectorIds.length >0)
      {
        await LoadWageRates(subSectorIds);
      }

    return resultSet;
  }

  void LoadWageRates(List<int> entityList)async
  {
    final dbHelper = WageRateTable.instance;
    await entityList.forEach((element){
      dbHelper.getWageRateByParentId(element);
    });
  }

}