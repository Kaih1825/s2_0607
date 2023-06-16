import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class ArticleSqlMethod {
  Database? database;

  getDB() async {
    database ??=
        await openDatabase("db.db", version: 1);
    try{
      database!.execute(
          "CREATE TABLE article(id INTEGER PRIMARY KEY,articleJsonText TEXT,commentJsonText TEXT)");
    }catch(ex){}
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
    Database db=await getDB();
    try{
      var res=await db.rawQuery("SELECT * FROM user WHERE email='$email'");
      if(res.isNotEmpty) return false;
      db.execute("INSERT INTO user(email,password,nick,gender) VALUES ('$email','$password','$nick','$gender')");
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
      print("oo"+res.length.toString());
      if(res.isNotEmpty&&res[0]["password"]==password){
        return true;
      }
      else{
        var res2=await db.rawQuery("SELECT password FROM user WHERE nick='$email'");
        print("ss"+res2.length.toString());
        if(res2[0]["password"]==password){
          return true;
        }else{
          return false;
        }
      }
    }catch(ex){
      return false;
    }
  }

  getUserInfo(email)async{
    Database db=await getDB();
    try{
      var res=await db.rawQuery("SELECT * FROM user WHERE email='$email'");
      if(res.isEmpty){
        res=await db.rawQuery("SELECT * FROM user WHERE nick='$email'");
      }
      return res;
    }catch(ex){
      return false;
    }
  }
}

class TagsSqlMethod{
  Database? _db;
  Future<Database> getDB()async{
    _db??=await openDatabase("db.db");
    try{
      _db!.execute("CREATE TABLE tags(name TEXT PRIMARY KEY)");
    }catch(ex){}
    return _db!;
  }

  insert(tagName)async{
    var db=await getDB();
    if((await db.rawQuery("SELECT * FROM tags WHERE name='$tagName'")).isNotEmpty){
      return false;
    }
    db.execute("INSERT INTO tags VALUES('$tagName')");
    return true;
  }

  getAll()async{
    var db=await getDB();
    return db.rawQuery("SELECT * FROM tags");
  }
}
