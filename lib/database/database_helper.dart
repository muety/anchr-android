import 'package:sqflite/sqflite.dart';

abstract class DatabaseHelper {
  Database db;

  Future<dynamic> open(String path) async {
    db = await openDatabase(path, version: schemaVersion, onCreate: onCreate, onUpgrade: onUpgrade);
  }

  Future<dynamic> delete() async {
    if (db != null) {
      return db.delete(table);
    }
  }

  int get schemaVersion;

  String get table;

  onCreate(Database db, int version);

  onUpgrade(Database db, int oldVersion, int newVersion);
}