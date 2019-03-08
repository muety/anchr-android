import 'package:anchr_android/models/link.dart';
import 'package:sqflite/sqflite.dart';

class LinkDbHelper {
  static final LinkDbHelper _helper = new LinkDbHelper._internal();
  static const String tableName = 'link';
  static const String columnId = '_id';
  static const String columnUrl = 'url';
  static const String columnDescription = 'description';
  static const String columnDate = 'date';
  static const String columnCollectionId = 'collectionId';

  Database db;

  factory LinkDbHelper() {
    return _helper;
  }

  LinkDbHelper._internal();

  _onCreate(Database db, int version) async {
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

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    switch (oldVersion) {
      case 1:
        break;
    }
  }

  Future open(String path) async {
    db = await openDatabase(path, version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future<void> insert(Link link, String collectionId) async {
    Map<String, dynamic> linkMap = link.toJson();
    linkMap[columnCollectionId] = collectionId;
    await db.insert(tableName, linkMap, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertBatch(List<Link> links, String collectionId) async {
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

  Future<void> deleteAllByCollection(String collectionId) async {
    await db.delete(tableName, where: '$columnCollectionId = ?', whereArgs: [collectionId]);
  }

  Future<void> deleteById(String id) async {
    await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }
}
