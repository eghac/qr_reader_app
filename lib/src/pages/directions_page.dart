import 'package:flutter/material.dart';
import 'package:qr_reader_app/src/bloc/scans_bloc.dart';
import 'package:qr_reader_app/src/models/scan_model.dart';

import 'package:qr_reader_app/src/utils/utils.dart' as utils;

class DirectionsPage extends StatelessWidget {

  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {

    scansBloc.getScans();

//    return FutureBuilder<List<ScanModel>>(
    return StreamBuilder<List<ScanModel>>(
//        future: DBProvider.db.getScans(),
        stream:scansBloc.scansStreamHttp,
        builder:
            (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final scans = snapshot.data;

          if (scans.length == 0)
            return Center(
              child: Text('No hay direcciones asignadas'),
            );

          return ListView.builder(
              itemCount: scans.length,
              itemBuilder: (BuildContext context, int index) => Dismissible(
                  key: UniqueKey(),
                  child: ListTile(
                    leading: Icon(Icons.cloud_queue,
                        color: Theme.of(context).primaryColor),
                    title: Text(scans[index].value),
                    subtitle: Text('Cliente asignado ${scans[index].id}'),
                    trailing: Icon(Icons.keyboard_arrow_right,
                        color: Theme.of(context).primaryColor),
                    onTap: () => utils.launchScan(context, scans[index]),
                  ),
                  background: Container(
                      child: Center(
                          child: Text('Eliminar',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0))),
                      color: Colors.red),
                  onDismissed: (DismissDirection dismissDirection) {
//                    DBProvider.db.deleteScan(scans[index].id);
                    scansBloc.deleteScans(scans[index].id);
                  }));
        });
  }
}
