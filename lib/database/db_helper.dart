import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DBHelper {
  static Database? _db;

  static const int _version = 1;
  static const String _tableName = "task";

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String path = '${await getDatabasesPath()}$_tableName.db';

      _db = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE $_tableName("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "title STRING, note TEXT, date STRING, "
            "startTime STRING, endTime STRING, "
            "remind INTEGER, repeat STRING, "
            "color INTEGER, "
            "isCompleted INTEGER)",
          );
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<int> insert(Task task) async {
    debugPrint("insert method called");
    return await _db!.insert(_tableName, task.toJson());
  }

  static Future<List<Map<String, dynamic>>> query() async {
    debugPrint("query method called");
    return await _db!.query(_tableName);
  }

  static delete(Task task) async {
    debugPrint("delete method called");
    await _db!.delete(_tableName, where: "id = ?", whereArgs: [task.id]);
  }

  static update(int id) async {
    debugPrint("update method called");
    return await _db!.rawUpdate('''
      UPDATE $_tableName
      SET isCompleted = ?
      WHERE id = ?
    ''', [1, id]);
  }
}
