import 'package:nabung_beramal/data/celengan_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'dart:io' as io;

class DbCelengan {
  static final DbCelengan _instance = new DbCelengan.internal();
  DbCelengan.internal();
  factory DbCelengan() {
    return _instance;
  }

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await setDb();
    return _db;
  }

  setDb() async {
    io.Directory directory = await getApplicationSupportDirectory();
    String path = join(directory.path, "DbCelengan");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database database, int version) async {
    await database.execute(
        "CREATE TABLE db_celengan(id INTEGER PRIMARY KEY, namaTarget TEXT, nominalTarget INTEGER, createDate TEXT, namaKategori TEXT, deskripsi TEXT, lamaTarget INTEGER, progress INTEGER, indexKategori INTEGER, pengingat INTEGER,alarmDateTime TEXT)");
    print("dbCelengan created");
  }

  Future<int> saveData(CelenganModel celenganModel) async {
    var dbClient = await db;
    int res = await dbClient.insert("db_celengan", celenganModel.toMap());
    print("data celengan inserted");
    return res;
  }

  Future<List<CelenganModel>> getList() async {
    var dbClient = await db;
    List<Map> list =
        await dbClient.rawQuery("SELECT * FROM db_celengan ORDER BY id DESC");
    List<CelenganModel> listData = new List();
    for (int i = 0; i < list.length; i++) {
      var celengan = new CelenganModel(
          list[i]['namaTarget'],
          list[i]['nominalTarget'],
          list[i]['deskripsi'],
          list[i]['lamaTarget'],
          list[i]['createDate'],
          list[i]["namaKategori"],
          list[i]['progress'],
          list[i]['indexKategori'],
          list[i]['pengingat'],
          list[i]['alarmDateTime']);

      celengan.setId(list[i]['id']);

      listData.add(celengan);
    }
    return listData;
  }

  Future<bool> upadteData(CelenganModel celenganModel) async {
    var dbClient = await db;
    int res = await dbClient.update("db_celengan", celenganModel.toMap(),
        where: "id=?", whereArgs: <int>[celenganModel.id]);
    return res > 0 ? true : false;
  }

  Future<List<CelenganModel>> getListCelengan(int nominal) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
        "SELECT * FROM db_celengan WHERE progress >=?", <int>[nominal]);
    List<CelenganModel> listData = new List();
    for (int i = 0; i < list.length; i++) {
      var celengan = new CelenganModel(
          list[i]['namaTarget'],
          list[i]['nominalTarget'],
          list[i]['deskripsi'],
          list[i]['lamaTarget'],
          list[i]['createDate'],
          list[i]["namaKategori"],
          list[i]['progress'],
          list[i]['indexKategori'],
          list[i]['pengingat'],
          list[i]['alarmDateTime']);
      celengan.setId(list[i]['id']);

      listData.add(celengan);
    }
    return listData;
  }

  Future<int> deleteData(CelenganModel celenganModel) async {
    var dbClient = await db;
    int res = await dbClient
        .rawDelete("DELETE FROM db_celengan WHERE id= ?", [celenganModel.id]);
    return res;
  }

  Future<List<CelenganModel>> getListById(int id) async {
    var dbClient = await db;
    List<Map> list = await dbClient
        .rawQuery("SELECT * FROM db_celengan WHERE id= ?", <int>[id]);
    List<CelenganModel> listData = new List();
    for (int i = 0; i < list.length; i++) {
      var celengan = new CelenganModel(
          list[i]['namaTarget'],
          list[i]['nominalTarget'],
          list[i]['deskripsi'],
          list[i]['lamaTarget'],
          list[i]['createDate'],
          list[i]["namaKategori"],
          list[i]['progress'],
          list[i]['indexKategori'],
          list[i]['pengingat'],
          list[i]['alarmDateTime']);
      celengan.setId(list[i]['id']);

      listData.add(celengan);
    }
    return listData;
  }

  Future<int> deleteAllData() async {
    var dbClient = await db;
    int res = await dbClient.rawDelete("DELETE FROM db_celengan");
    print("all data celengan deleted");
    return res;
  }
}
