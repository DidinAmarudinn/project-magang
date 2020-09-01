import 'package:nabung_beramal/data/tabungan_harian_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DbTabHarain {
  static final DbTabHarain _instance = DbTabHarain.internal();
  DbTabHarain.internal();
  factory DbTabHarain() {
    return _instance;
  }

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await setDb();
    return _db;
  }

  setDb() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "dbHarian");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database database, int version) async {
    await database.execute(
        "CREATE TABLE db_harian(id integer PRIMARY KEY, nominal INTEGER, desk TEXT, dateTime TEXT,color INTEGER,foriegnCelengan INTEGER,tgl TEXT)");
    print("dbharian created");
  }

  Future<int> saveData(TabunganHarainModel harian) async {
    var dbClient = await db;
    int res = await dbClient.insert("db_harian", harian.toMap());
    print("data inserted");
    return res;
  }

  Future<List<TabunganHarainModel>> getList(int id) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
        "SELECT * FROM db_harian where foriegnCelengan=$id ORDER BY id DESC");
    List<TabunganHarainModel> listData = new List();
    for (int i = 0; i < list.length; i++) {
      var harian = new TabunganHarainModel(
          list[i]['nominal'],
          list[i]['desk'],
          list[i]['dateTime'],
          list[i]['color'],
          list[i]['foriegnCelengan'],
          list[i]['tgl']);
      harian.setId(list[i]['id']);
      listData.add(harian);
    }
    if (listData.length > 0) {
      print("udah ada tabungab");
    } else {
      print("belum ada tabungan");
    }
    return listData;
  }

  Future<List> calculateTotal(String time) async {
    var dbClient = await db;
    var result = await dbClient.query("db_harian",
        columns: ['SUM(nominal) as total'],
        where: 'tgl = ?',
        whereArgs: [time]);
    print("today saved" + result.toString());
    return result;
  }

  Future<List> calculateTotalAll() async {
    var dbClient = await db;
    var result =
        await dbClient.rawQuery("SELECT SUM(nominal)as total from db_harian");
    print("total saved" + result.toString());
    return result;
  }

  Future<int> deleteHarain(int foriegnKey) async {
    var dbClient = await db;
    var res = await dbClient.rawDelete(
        "DELETE FROM db_harian WHERE foriegnCelengan = ?", <int>[foriegnKey]);
    print("deleted db harian");
    return res;
  }

  Future<List> calculateTotalPerCelengan(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        "SELECT sum(nominal) as total FROM db_harian WHERE foriegnCelengan= ?",
        <int>[id]);
    return result;
  }
}
