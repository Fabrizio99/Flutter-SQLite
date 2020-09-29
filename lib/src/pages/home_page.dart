import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:qrreaderapp/src/pages/direcciones_page.dart';
import 'package:qrreaderapp/src/pages/mapas_page.dart';
import '../models/scan_model.dart';
import '../bloc/scans_bloc.dart';
import 'dart:io';
import '../util/utils.dart' as utils;


class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScansBloc scansBloc = ScansBloc();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: [
          IconButton(icon: Icon(Icons.delete_forever), onPressed: (){
            scansBloc.borrarScanTodos();
          })
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>_scanQR(context),
        child: Icon(Icons.filter_center_focus),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void _scanQR(BuildContext context)async{
    //https://www.google.com.pe/
    //geo:40.7481662272785,-73.86586561640628

    dynamic futureString = '';
    
    try {
      futureString = await BarcodeScanner.scan();
    } catch (e) {
      futureString = e.toString();
    }
    
    if(futureString != null){
      final scan = ScanModel(valor: futureString);
      scansBloc.agregarScan(scan);

      if(Platform.isIOS){
        Future.delayed(Duration(milliseconds: 750),(){
          utils.abrirScan(context,scan);
        });
      }else{
        utils.abrirScan(context,scan);
      }
    }
  }

  Widget _callPage(int paginaActual){
    switch (paginaActual) {
      case 0: return MapasPage();
      case 1: return DireccionesPage();

      default: return MapasPage();
    }
  }

  Widget _crearBottomNavigationBar(){
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index){
        currentIndex = index;
        setState(() {
          
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Direcciones')
        ),
      ],
    );
  }
}