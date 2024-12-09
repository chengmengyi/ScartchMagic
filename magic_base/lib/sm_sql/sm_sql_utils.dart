import 'package:sqflite/sqflite.dart';

class SmSqlTable{
  static const String playInfoNormal="playInfoNormal";
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
    version: 1,
    onCreate: (db,version)async{
      db.execute('CREATE TABLE ${SmSqlTable.playInfoNormal} (id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT, currentPro INTEGER, playedNum INTEGER, unlock INTEGER, time INTEGER)');
    },
  );
}