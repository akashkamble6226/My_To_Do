import 'package:my_to_do/models/task.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DataBaseHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'Tasks.db'),
        onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE user_tasks(id TEXT PRIMARY KEY, name TEXT, info TEXT)',
      );
    }, version: 1);
  }

  static Future<void> insertData(String table, Map<String, Object> data) async {
    final db = await DataBaseHelper.database();
    db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> fetchData(String table) async {
    final db = await DataBaseHelper.database();
    return db.query(table);
  }

  // static Future<void> updateData(
  //     String table, Map<String, dynamic> data) async {
  //   final db = await DataBaseHelper.database();
  //   db.update(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  // }

  static Future<void> update(Task tsk, Map<String, dynamic> data) async {
    final db = await DataBaseHelper.database();
    db.update('user_tasks', data, where: 'id = ?', whereArgs: [tsk.id]);
  }

  static Future<void> deleteData(String table, String id) async {
    final db = await DataBaseHelper.database();
    db.delete(table, where: "id = ?", whereArgs: [id]);
  }

  Future close() async {
    final db = await DataBaseHelper.database();
    db.close();
  }
}
