import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();

    return sql.openDatabase(path.join(dbPath, 'taskMaster.db'),
        onCreate: (db, version) {
      return db.execute('''
           CREATE TABLE USERTASK (
           id varchar(255),
           title varchar(255),
           desc varchar(255),
           stDate varchar(255),
           image varchar(255),
           isDone int);
           ''');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<void> delete(String id) async {
    final db = await DBHelper.database();

    db.rawDelete('DELETE FROM USERTASK WHERE id = ?', [id]);
  }

  static Future<void> update(String id, int isDone) async {
    final db = await DBHelper.database();
    db.rawUpdate('UPDATE USERTASK SET isDone = ? WHERE id = ?', [isDone, id]);
  }

  static Future<void> close(String table) async {
    final db = await DBHelper.database();
    db.rawDelete('DELETE FROM USERTASK');
    db.close();
  }
}
