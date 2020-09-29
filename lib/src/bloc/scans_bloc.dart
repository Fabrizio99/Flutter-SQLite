import 'dart:async';

import '../models/scan_model.dart';
import '../providers/db_provider.dart';
import 'package:qrreaderapp/src/bloc/validator.dart';

class ScansBloc with Validators{
  static final ScansBloc _singleton = ScansBloc._internal();
  factory ScansBloc(){
    return _singleton;
  }

  ScansBloc._internal(){
    obtenerScans();

  }

  StreamController<List<ScanModel>> _scanController = StreamController<List<ScanModel>>.broadcast();
  Stream<List<ScanModel>> get scansStream => _scanController.stream.transform(super.validarGeo);
  Stream<List<ScanModel>> get scansStreamHttp => _scanController.stream.transform(super.validarHttp);

  void dispose(){
    _scanController?.close();
  }

  void obtenerScans()async{
    _scanController.sink.add(await DBProvider.db.getTodosScan());
  }

  void agregarScan(ScanModel scan)async{
    await DBProvider.db.nuevoScan(scan);
    obtenerScans();
  }

  void borrarScan(int id)async{
    await DBProvider.db.deleteScan(id);
    obtenerScans();
  }

  void borrarScanTodos()async{
    DBProvider.db.deleteAll();
    obtenerScans();
  }
}