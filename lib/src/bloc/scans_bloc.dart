import 'dart:async';

import 'package:qr_reader_app/src/bloc/validators.dart';
import 'package:qr_reader_app/src/providers/db_provider.dart';

class ScansBloc with Validators {
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal() {
    // Obtener la data de la db
    getScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream =>
      _scansController.stream.transform(validateGeo);

  Stream<List<ScanModel>> get scansStreamHttp =>
      _scansController.stream.transform(validateHttp);

  // Para cerrar el controller
  dispose() {
    _scansController?.close();
  }

  getScans() async => _scansController.sink.add(await DBProvider.db.getScans());

  addScan(ScanModel newScan) async {
    await DBProvider.db.createScan(newScan);
    getScans();
  }

  deleteScans(int id) async {
    await DBProvider.db.deleteScan(id);
    getScans();
  }

  deleteAllScans() async {
    await DBProvider.db.deleteScanAll();
//    _scansController.sink.add([]);
    getScans();
  }
}
