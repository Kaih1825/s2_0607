import 'dart:convert';

import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class SqlMethod {
  Database? database;

  getDB() async {
    database ??=
        await openDatabase("db.db", version: 1, onCreate: (db, version) {
      db.execute(
          "CREATE TABLE article(id INTEGER PRIMARY KEY,articleJsonText TEXT,commentJsonText TEXT)");
    });
    return database;
  }

  insert(id, articleJsonText, commentJsonText) async {
    var db = await getDB();
    db.execute(
        "INSERT INTO article(id,articleJsonText,commentJsonText) VALUES($id,'${articleJsonText.toString().replaceAll("'", "''")}','${commentJsonText.toString().replaceAll("'", "''")}')");
  }

  remove(id) async {
    Database db = await getDB();
    await db.execute("DELETE FROM article WHERE id=$id");
  }

  getAll() async {
    var db = await getDB();
    return await db!.rawQuery("SELECT * FROM article");
  }

  check(id) async {
    var db = await getDB();
    var res = await db!.rawQuery("SELECT * FROM article WHERE id=$id") as List;
    return res.isNotEmpty;
  }
}
