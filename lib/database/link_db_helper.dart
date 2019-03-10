import 'package:anchr_android/database/database_helper.dart';
import 'package:anchr_android/models/link.dart';
import 'package:sqflite/sqflite.dart';

class LinkDbHelper extends DatabaseHelper {
  static final LinkDbHelper _helper = new LinkDbHelper._internal();
  static const int _schemaVersion = 1;
  static const String tableName = 'link';
  static const String columnId = '_id';
  static const String columnUrl = 'url';
  static const String columnDescription = 'description';
  static const String columnDate = 'date';
  static const String columnCollectionId = 'collectionId';

  factory LinkDbHelper() {
    return _helper;
  }

  LinkDbHelper._internal();

  @override
  onCreate(Database db, int version) async {
    await db.execute('''
        create table $tableName ( 
          $columnId text primary key, 
          $columnUrl text not null,
          $columnDescription text,
          $columnDate text not null,
          $columnCollectionId text not null
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

  Future insert(Link link, String collectionId) async {
    Map<String, dynamic> linkMap = link.toJson();
    linkMap[columnCollectionId] = collectionId;
    await db.insert(tableName, linkMap, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future insertBatch(List<Link> links, String collectionId) async {
    final batch = db.batch();
    links.forEach((l) {
      Map<String, dynamic> linkMap = l.toJson();
      linkMap[columnCollectionId] = collectionId;
      batch.insert(tableName, linkMap, conflictAlgorithm: ConflictAlgorithm.replace);
    });
    await batch.commit();
  }

  Future<List<Link>> findAll() async {
    List<Map> maps = await db.query(tableName, columns: [columnId, columnUrl, columnDescription, columnDate, columnCollectionId]);
    return maps.map((l) => Link.fromJson(l)).toList();
  }

  Future<List<Link>> findAllByCollection(String collectionId) async {
    List<Map> maps = await db.query(tableName,
        columns: [columnId, columnUrl, columnDescription, columnDate],
        where: '$columnCollectionId = ?',
        whereArgs: [collectionId]);
    return maps.map((l) => Link.fromJson(l)).toList();
  }

  Future deleteAllByCollection(String collectionId) async {
    await db.delete(tableName, where: '$columnCollectionId = ?', whereArgs: [collectionId]);
  }

  Future deleteById(String id) async {
    await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future deleteAll() async {
    await db.delete(tableName);
  }

  @override
  int get schemaVersion => _schemaVersion;
}
