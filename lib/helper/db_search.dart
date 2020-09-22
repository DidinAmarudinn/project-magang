import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'dart:io' as io;

class DbSearch {
  static final DbSearch _instance = new DbSearch.internal();
  DbSearch.internal();
  factory DbSearch() {
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
    String path = join(directory.path, "DbSearch");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database database, int version) async {
    await database.execute(
        "CREATE TABLE db_search(id INTEGER PRIMARY KEY, riwayatSearch TEXT, createDate TEXT)");
    print("dbSearch created");
  }
}
