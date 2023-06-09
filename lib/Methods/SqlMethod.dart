import 'package:sqflite/sqflite.dart';

class SqlMethod {
  Database? database;

  getDB() async {
    database ??= await openDatabase("db.db", version: 1, onCreate: (db, version) {
      db.execute(
          "CREATE TABLE article(id INTEGER PRIMARY KEY,articleJsonText TEXT,commentJsonText TEXT)");
    });
    return database;
  }

  insert(id,articleJsonText,commentJsonText) async{
    var db=getDB();
    db.execute("INSERT INTO article(id,articleJsonText,commentJsonText) VALUES($id,'$articleJsonText','$commentJsonText')");
  }

  getAll() async{
    var db=getDB();
    return await db!.rawQuery("SELECT * FROM article");
  }

  check(id) {
    var db=getDB();
    try{
      db!.rawQuery("SELECT * FROM article WHERE id=$id");
      return true;
    }catch(ex){
      return false;
    }
  }
}
