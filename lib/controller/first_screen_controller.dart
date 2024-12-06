import 'dart:async';
import 'dart:developer';
import 'package:sqflite/sqflite.dart';

class FirstScreenController {
  static late Database database;

  /// Initialize the database
  static Future<void> initialiseDatabase() async {
    database = await openDatabase(
      "todo.db",
      version: 1,
      onCreate: (db, version) async => await db.execute(
        'CREATE TABLE Todo (id INTEGER PRIMARY KEY, task TEXT, isDone INTEGER)',
      ),
    );
  }
  static Future<void> addTodo(String task, int isDone) async {
    await database.rawInsert(
      'INSERT INTO Todo(task, isDone) VALUES(?, ?)',
      [task, isDone],
    );
    await getTodo();
  }

  static Future<List<Map<String, dynamic>>> getTodo() async {
    List<Map<String, dynamic>> list =
        await database.rawQuery('SELECT * FROM Todo');
    log(list.toString());
    return list;
  }

  static Future<void> deleteTodo(int id) async {
    await database.rawDelete('DELETE FROM Todo WHERE id = ?', [id]);
  }

  static Future<void> toggleTodo(int id, int isDone) async {
    await database.rawUpdate(
      'UPDATE Todo SET isDone = ? WHERE id = ?',
      [isDone, id],
    );
    await getTodo();
  }
}
