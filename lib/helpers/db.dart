import 'package:sqflite/sqflite.dart';

class DB {
  static const String dbName = 'app.db';
  static Future<Database> connectToDabase() async {
    var databasesPath = await getDatabasesPath();
    String path = "$databasesPath/$dbName";
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE logins (id INTEGER PRIMARY KEY, uid TEXT, created_at TEXT)');
      await db.execute(
          'CREATE TABLE last_location (id INTEGER PRIMARY KEY, uid TEXT, latitude TEXT, longitude TEXT, created_at TEXT)');
    });
    return database;
  }
}
