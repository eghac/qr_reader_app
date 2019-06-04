import 'dart:io';

import 'package:path/path.dart';
import 'package:qr_reader_app/src/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
export 'package:qr_reader_app/src/models/scan_model.dart';

class DBProvider {
  // Singleton
  static Database _database;
  static final DBProvider db = DBProvider._();

  // Constructor privado
  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // Nombre del archivo
    final path = join(documentsDirectory.path, 'ScansDB.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Scans('
          'id INTEGER PRIMARY KEY,'
          'type TEXT,'
          'value TEXT'
          ')');
    });
  }

  // CRUD - CREATE
  createScanRaw(ScanModel newScan) async {
    // Verificar si la db está lista para escribir en ella
    final db = await database;
    final result = await db.rawInsert("INSERT INTO Scans (id, type, value) "
        "VALUES (${newScan.id},'${newScan.type}','${newScan.value}')");
    return result;
  }

  createScan(ScanModel newScan) async {
    final db = await database;
    final result = await db.insert('Scans', newScan.toJson());
    return result;
  }

  // CRUD - READ
  Future<ScanModel> getScan(int id) async {
    final db = await database;
    final result = await db.query('Scans', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? ScanModel.fromJson(result.first) : null;
  }

  Future<List<ScanModel>> getScans() async {
    final db = await database;
    final result = await db.rawQuery("SELECT * FROM Scans");
    List<ScanModel> list = result.isNotEmpty
        ? result.map((item) => ScanModel.fromJson(item)).toList()
        : [];
    return list;
  }

  Future<List<ScanModel>> getScansForType(String type) async {
    final db = await database;
    final result = await db.rawQuery("SELECT * FROM Scans WHERE type = '$type'");
    List<ScanModel> list = result.isNotEmpty
        ? result.map((item) => ScanModel.fromJson(item)).toList()
        : [];
    return list;
  }

  // CRUD - UPDATE
  Future<int> updateScan(ScanModel scanUpdated) async {
    final db = await database;
    final result = await db.update('Scans', scanUpdated.toJson(),
        where: 'id = ?', whereArgs: [scanUpdated.id]);
    return result;
  }

  // CRUD - DELETE
  Future<int> deleteScan(int id) async {
    final db = await database;
    final result = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return result;
  }

  Future<int> deleteScanAll() async {
    final db = await database;
    final result = await db.rawDelete('DELETE FROM Scans');
    // result entrega la cantidad de registros eliminados
    return result;
  }
}
