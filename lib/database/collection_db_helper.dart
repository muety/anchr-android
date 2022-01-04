import 'package:anchr_android/database/database_helper.dart';
import 'package:anchr_android/models/link_collection.dart';
import 'package:sqflite/sqflite.dart';

class CollectionDbHelper extends DatabaseHelper {
  static final CollectionDbHelper _helper = CollectionDbHelper._internal();
  static const int _schemaVersion = 1;
  static const String tableName = 'collection';
  static const String columnId = '_id';
  static const String columnName = 'name';
  static const String columnOwnerId = 'owner';
  static const String columnShared = 'shared';

  factory CollectionDbHelper() {
    return _helper;
  }

  CollectionDbHelper._internal();

  @override
  onCreate(Database db, int version) async {
    await db.execute('''
        create table if not exists $tableName ( 
          $columnId text primary key, 
          $columnName text not null,
          $columnOwnerId text,
          $columnShared bool
         )
        ''');
  }

  @override
  onUpgrade(Database db, int oldVersion, int newVersion) async {
    switch (oldVersion) {
      case 1:
        break;
    }
  }

  Future<void> insert(LinkCollection collection) async {
    Map<String, dynamic> collectionMap = collection.toJson();
    collectionMap.remove('links');
    await db.insert(tableName, collectionMap, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertBatch(List<LinkCollection> collections) async {
    final batch = db.batch();
    for (var c in collections) {
      Map<String, dynamic> collectionMap = c.toJson();
      collectionMap.remove('links');
      batch.insert(tableName, collectionMap, conflictAlgorithm: ConflictAlgorithm.replace);
    }
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

    if (maps.isNotEmpty) {
      return LinkCollection.fromJson(maps.first);
    }
    return null;
  }

  Future<dynamic> deleteById(String id) async {
    await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<dynamic> deleteAll() async {
    await db.delete(tableName);
  }

  @override
  int get schemaVersion => _schemaVersion;

  @override
  String get table => tableName;
}