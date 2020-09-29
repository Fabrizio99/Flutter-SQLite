import 'package:flutter/material.dart';
import '../models/scan_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  MapController map = MapController();
  String tipoMapa = 'streets';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){
              map.move(scan.getLatLng(), 10);
            },
          )
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _crearBotonFlotante(context)
    );
  }

  Widget _crearBotonFlotante(BuildContext context){
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(
        Icons.repeat,
      ),
      onPressed: (){
        print('entra aca');
        if(tipoMapa == 'streets'){
          tipoMapa = 'dark';
        }else if(tipoMapa == 'dark'){
          tipoMapa = 'light';
        }else if(tipoMapa == 'light'){
          tipoMapa = 'outdoors';
        }else if(tipoMapa == 'outdoors'){
          tipoMapa = 'satellite';
        }else{
          tipoMapa = 'streets';
        }
        
        setState(() {
          
        });
      }
    );
  }
  Widget _crearFlutterMap(ScanModel scan){
    return FlutterMap(
      mapController: map,
      options: new MapOptions(
        center: scan.getLatLng(),
        zoom: 10.0,
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores(scan)
      ]
    );
  }

  _crearMapa(){
    return TileLayerOptions(
        urlTemplate: 'https://api.mapbox.com/v4/'
            '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
        additionalOptions: {
	  //provide your own toek api from mapbox
          'accessToken': '',
          //streets,dark,light,outdoors
          'id': 'mapbox.$tipoMapa'
        }
    );
  }
  _crearMarcadores(ScanModel scan){
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 120.0,
          height: 120.0,
          point: scan.getLatLng(),
          builder: (BuildContext context){
            return Container(
              child: Icon(
                Icons.location_on,
                size: 69.0,
                color: Theme.of(context).primaryColor,
              ),
            );
          }
        )
      ]
    );
  }
}
