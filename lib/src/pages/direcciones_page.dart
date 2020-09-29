import 'package:flutter/material.dart';
import '../bloc/scans_bloc.dart';
import '../models/scan_model.dart';
import '../util/utils.dart' as utils;

class DireccionesPage extends StatelessWidget {
  ScansBloc scansBloc = ScansBloc();

  @override
  Widget build(BuildContext context) {
    scansBloc.obtenerScans();
    return StreamBuilder<List<ScanModel>>(
      stream  : scansBloc.scansStreamHttp,
      builder : (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator());
        }
        final scans = snapshot.data;
        if(scans.length == 0){
          return Center(child: Text('No hay información'));
        }
        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context,i)=>Dismissible(
            key: UniqueKey(),
            child: ListTile(
              leading: Icon(Icons.cloud_queue,color: Theme.of(context).primaryColor,),
              title: Text(scans[i].valor),
              subtitle: Text('${scans[i].id}'),
              trailing: Icon(Icons.keyboard_arrow_right,color: Colors.grey),
              onTap: (){
                utils.abrirScan(context,scans[i]);
              },
            ),
            background: Container(color: Colors.red),
            onDismissed: (DismissDirection direction){
              print(direction.index);
              //DBProvider.db.deleteScan(scans[i].id);
              scansBloc.borrarScan(scans[i].id);
            },
          )
        );
      }
    );
    //return Text('hola pto');
  }
}