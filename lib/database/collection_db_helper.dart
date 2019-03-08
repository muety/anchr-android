import 'package:anchr_android/models/link_collection.dart';
import 'package:sqflite/sqflite.dart';

class CollectionDbHelper {
  static final CollectionDbHelper _helper = new CollectionDbHelper._internal();
  static const String tableName = 'collection';
  static const String columnId = '_id';
  static const String columnName = 'name';
  static const String columnOwnerId = 'owner';
  static const String columnShared = 'shared';

  Database db;

  factory CollectionDbHelper() {
    return _helper;
  }

  CollectionDbHelper._internal();

  _onCreate(Database db, int version) async {
    await db.execute('''
        create table $tableName ( 
          $columnId text primary key, 
          $columnName text not null,
          $columnOwnerId text,
          $columnShared bool
         )
        ''');
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    switch (oldVersion) {
      case 1:
        break;
    }
  }

  Future open(String path) async {
    db = await openDatabase(path, version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future<void> insert(LinkCollection collection) async {
    Map<String, dynamic> collectionMap = collection.toJson();
    await db.insert(tableName, collectionMap, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertBatch(List<LinkCollection> collections) async {
    final batch = db.batch();
    collections.forEach((c) {
      Map<String, dynamic> collectionMap = c.toJson();
      collectionMap.remove('links');
      batch.insert(tableName, collectionMap, conflictAlgorithm: ConflictAlgorithm.replace);
    });
    await batch.commit();
  }

  Future<List<LinkCollection>> findAll() async {
    List<Map> maps = await db.query(tableName, columns: [columnId, columnName, columnOwnerId, columnShared]);
    return maps.map((c) => LinkCollection.fromJson(c)).toList();
  }

  Future<LinkCollection> findOne(String id) async {
    List<Map> maps = await db.query(tableName,
        columns: [columnId, columnName, columnOwnerId, columnShared],
        where: '$columnId = ?',
        whereArgs: [id]);

    if (maps.length > 0) {
      return LinkCollection.fromJson(maps.first);
    }
    return null;
  }

  Future<void> deleteAll() async {
    await db.delete(tableName);
  }
}