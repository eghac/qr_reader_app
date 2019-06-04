import 'package:flutter/material.dart';
import 'package:qr_reader_app/src/models/scan_model.dart';
import 'package:flutter_map/flutter_map.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final mapController = new MapController();

  String typeMap = 'satellite';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.my_location),
              onPressed: () => mapController.move(scan.getLatLng(), 15))
        ],
      ),
      body: Center(
        child: _createFlutterMap(scan),
      ),
      floatingActionButton: _floatingActionButton(context),
    );
  }

  Widget _createFlutterMap(ScanModel scan) {
    return FlutterMap(
        options: MapOptions(center: scan.getLatLng(), zoom: 15),
        layers: [
          _buildMap(),
          _buildMarkers(scan),
        ],
        mapController: mapController);
  }

  _buildMap() {
    return TileLayerOptions(
        urlTemplate: 'https://api.mapbox.com/v4/'
            '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
        additionalOptions: {
          'accessToken':
              'pk.eyJ1IjoiZWxpb3RkZXYiLCJhIjoiY2p3OXNqcnM1MDA1YjQ5cWt6Mmt0Nmx4ZyJ9.RWzSMHtxfdte7ELcgrOa2Q',
          'id': 'mapbox.$typeMap'
          // streets, dark, light, outdoors, satellite
        });
  }

  _buildMarkers(ScanModel scan) {
    return MarkerLayerOptions(markers: [
      Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: (BuildContext context) => Container(
                child: Icon(Icons.location_on,
                    size: 70.0, color: Theme.of(context).primaryColor),
              )),
    ]);
  }

  _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.repeat),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          if (typeMap == 'streets')
            typeMap = 'dark';
          else if (typeMap == 'dark')
            typeMap = 'light';
          else if (typeMap == 'light')
            typeMap = 'outdoors';
          else if (typeMap == 'outdoors')
            typeMap = 'satellite';
          else if (typeMap == 'satellite')
            typeMap = 'streets';
          else
            typeMap = 'streets';
          setState(() {});
        });
  }
}
