import 'dart:convert';

import 'package:sqflite/sqflite.dart';

class SmSqlTable{
  static const String playInfoNormal="playInfoNormal";
  static const String playInfoB="playInfoB";
  static const String newPlayInfoB="newPlayInfoB";
  static const String cashTaskB="cashTaskB";
  static const String cashTaskB2="cashTaskB2";
  static const String tba="tba";
}

class SmSqlUtils{
  factory SmSqlUtils()=>_getInstance();
  static SmSqlUtils get instance => _getInstance();
  static SmSqlUtils? _instance;
  static SmSqlUtils _getInstance(){
    _instance??=SmSqlUtils._internal();
    return _instance!;
  }

  SmSqlUtils._internal();

  Future<Database> openDB() async => await openDatabase(
    "scratchMagic.db",
    version: 4,
    onCreate: (db,version)async{
      print("kk====onCreate====${version}");
      db.execute('CREATE TABLE ${SmSqlTable.playInfoNormal} (id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT, currentPro INTEGER, playedNum INTEGER, unlock INTEGER, time INTEGER)');

      _createVersion2DB(db);
      _createVersion3DB(db);
      _createVersion4DB(db);
    },
    onUpgrade: (db,oldVersion,newVersion){
      if(newVersion==2){
        _createVersion2DB(db);
      }
      if(newVersion==3){
        _createVersion3DB(db);
      }
      print("kk====newVersion====${newVersion}");
      // if(newVersion==4){
      //   _createVersion4DB(db);
      // }
    }
  );

  _createVersion2DB(db){
    db.execute('CREATE TABLE ${SmSqlTable.playInfoB} (id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT, currentPro INTEGER, playedNum INTEGER, unlock INTEGER, time INTEGER)');
    db.execute('CREATE TABLE ${SmSqlTable.cashTaskB} (id INTEGER PRIMARY KEY AUTOINCREMENT, taskType INTEGER, cashType INTEGER, cashMoney INTEGER, currentPro INTEGER, maxPro INTEGER, completeStatus INTEGER,maxDays INTEGER,timer TEXT,account TEXT)');
    db.execute('CREATE TABLE ${SmSqlTable.tba} (id INTEGER PRIMARY KEY AUTOINCREMENT, dataMap TEXT)');
  }

  _createVersion3DB(db){
    db.execute('CREATE TABLE ${SmSqlTable.cashTaskB2} (id INTEGER PRIMARY KEY AUTOINCREMENT, taskType INTEGER,taskKey TEXT, cashType INTEGER, cashMoney INTEGER, currentPro INTEGER, maxPro INTEGER, completeStatus INTEGER, account TEXT)');
  }

  _createVersion4DB(db){
    db.execute('CREATE TABLE ${SmSqlTable.newPlayInfoB} (id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT, currentPro INTEGER, playedNum INTEGER, unlock INTEGER, time INTEGER)');
  }

  insertTbaMap(Map<String,dynamic> map)async{
    var db = await openDB();
    db.insert(SmSqlTable.tba, {"dataMap":jsonEncode(map)});
  }

  Future<List<Map<String, Object?>>> queryTbaMap()async{
    var db = await openDB();
    return await db.query(SmSqlTable.tba);
  }

  removeTbaMap()async{
    var db = await openDB();
    db.delete(SmSqlTable.tba);
  }
}