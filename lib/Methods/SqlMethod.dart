import 'package:sqflite/sqflite.dart';

class ArticleSqlMethod {
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

class FriendSqlMethod{
  Database? database2;
  getDB()async{
    database2 ??= await openDatabase("db.db",version: 1,onCreate: (db,version){
        db.execute("CREATE TABLE friends(id TEXT PRIMARY KEY)");
      });
    try{
      database2!.execute("CREATE TABLE friends(id TEXT PRIMARY KEY)");
    }catch(ex){}
    return database2;
  }

  toggleFriendState(id)async{
    var db=await getDB();
    var getFriend=await db.rawQuery("SELECT * FROM friends WHERE id='$id'");
    if(getFriend.isEmpty){
      await db.execute("INSERT INTO friends(id) VALUES('$id')");
    }else{
      await db.execute("DELETE FROM friends WHERE id='$id'");
    }
  }

  getFriendState(id)async{
    var db=await getDB();
    var getFriend=await db.rawQuery("SELECT * FROM friends WHERE id='$id'");
    return getFriend.isNotEmpty;
  }
}

class UserSqlMethod{
  Database? database;
  
  getDB()async{
    database??=await openDatabase("db.db",version: 1,onCreate: (db,version){
      db.execute("CREATE TABLE user(email TEXT PRIMARY KEY,password TEXT,nick TEXT,gender TEXT)");
    });
    try{
      database!.execute("CREATE TABLE user(email TEXT PRIMARY KEY,password TEXT,nick TEXT,gender TEXT)");
    }catch(ex){}
    return database;
  }

  insert(email,password,nick,gender)async{
    var db=await getDB();
    try{
      db.excuate("INSERT INTO user(email,password,nick,gender) VALUES ('$email','$password','$nick','$gender')");
      return true;
    }catch(ex){
      print(ex);
      return false;
    }
  }

  login(email,password)async{
    Database db=await getDB();
    try{
      var res=await db.rawQuery("SELECT password FROM user WHERE email='$email'");
      print(res.length);
      return res[0]["password"]==password;
    }catch(ex){
      return false;
    }
  }
}
