import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
//el export expone este modelo(scanmodel) a los archivos que importen este archivo db_provider
export 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider{
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async{
    print('entra a database');
    //print('database $database');
    if(_database != null)  return _database;
    _database = await initDB();
    return _database;
  }

  initDB()async{
    //el path donde se va a encontrar o se encuentra la DB
    //print('entra a init');
    print('llega aca');
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //String documentsDirectory = await getDatabasesPath();
    //print('ruta del directorio de documentos ${documentsDirectory.path}');
    //print('ruta del directorio de documentos ${documentsDirectory.path}/ScansDB.db');
    //join(p1,p2) retorna las partes de las rutas dadas en una sola ruta
    //joint('path','p1') -> 'path/p1'
    String path = join(documentsDirectory.path,'ScanDB.db');


    return await openDatabase(
      path,
      // version -> especifica la version del esquema(describe la estructura de la bd) de la bd que se esta abriendo
      version: 1,
      onOpen: (db){},
      //onCreate es invocado si la db no ha sido creada, puede usarse para crear las tablas requeridas
      onCreate: (Database db, int version)async{
        await db.execute(
            'CREATE TABLE Scans ('
            ' id INTEGER PRIMARY KEY,'
            ' tipo TEXT,'
            ' valor TEXT'
            ')'
        );
      }
    );
  }

  nuevoScanRaw(ScanModel nuevoScan)async{
    final db = await database;
    final res = await db.rawInsert(
      "INSERT INTO Scans (id,tipo,valor) "
      "VALUES (${nuevoScan.id}, '${nuevoScan.tipo}', '${nuevoScan.valor}')"
    );

    return res;
  }

  nuevoScan(ScanModel nuevoScan)async{
    final db = await database;
    final res = await db.insert('Scans', nuevoScan.toJson());
    return res;
  }

  // SELECT - Obtener Información
  Future<ScanModel>getScanId(int id)async{
    final db = await database;
    final res = await db.query('Scans', where: 'id = ?',whereArgs: [id]);
    return res.isNotEmpty
                ?ScanModel.fromJson(res.first)
                :null;
  }

  Future<List<ScanModel>>getTodosScan()async{
    final db = await database;
    print('llego aca');
    final res = await db.query('Scans');
    print('Respuesta: $res');
    return res.isNotEmpty
                ?res.map((c) => ScanModel.fromJson(c)).toList()
                :[];
  }

  Future<List<ScanModel>>getScansPorTipo(String tipo)async{
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Scans WHERE tipo='$tipo'");
    return res.isNotEmpty
                ?res.map((c) => ScanModel.fromJson(c)).toList()
                :[];
  }

  // Actualizar Registros
  Future<int>updateScan(ScanModel nuevoScan)async{
    final db = await database;
    final res = await db.update('Scans', nuevoScan.toJson(),where: 'id = ?',whereArgs: [nuevoScan.id]);
    return res;
  }

  // Eliminar Registros
  Future<int>deleteScan(int id)async{
    final db = await database;
    final res = await db.delete('Scans',where: 'id = ?',whereArgs: [id]);
    return res;
  }
  Future<int>deleteAll()async{
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Scans');
    return res;
  }
}