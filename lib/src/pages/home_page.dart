import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_reader_app/src/bloc/scans_bloc.dart';
import 'package:qr_reader_app/src/models/scan_model.dart';
import 'package:qr_reader_app/src/pages/directions_page.dart';
import 'package:qr_reader_app/src/pages/maps_page.dart';
import 'package:qr_reader_app/src/utils/utils.dart' as utils;
import 'package:qrcode_reader/qrcode_reader.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assist Control HUMCORP'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: scansBloc.deleteAllScans)
        ],
      ),
      body: _buildPage(_currentPage),
      bottomNavigationBar: _bottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _floatingActionButton(),
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.map), title: Text('Mapa')),
          BottomNavigationBarItem(
              icon: Icon(Icons.brightness_5), title: Text('Direcciones')),
        ],
        onTap: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        currentIndex: _currentPage);
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: _scanQR,
        child: Icon(
          Icons.fingerprint,
          size: 40.0,
          color: Colors.white,
        ));
  }

  _scanQR() async {
    // https://www.facebook.com -> Enlace
    // geo:40.710701788972194,-73.90981092890627 -> Mapa

//    String futureString = 'geo:40.710701788972194,-73.90981092890627';
//    String futureString = 'https://www.facebook.com';
    String futureString;
    try {
      futureString = await new QRCodeReader().scan();
    } catch (e) {
      futureString = e.toString();
    }

    if (futureString != null) {
      final scan = ScanModel(value: futureString);
      scansBloc.addScan(scan);

//      final scan2 = ScanModel(value: 'geo:40.710701788972194,-73.90981092890627');
//      scansBloc.addScan(scan2);

      if (Platform.isIOS)
        Future.delayed(Duration(milliseconds: 750), () {
          utils.launchScan(context, scan);
        });
      else
        utils.launchScan(context, scan);
    }
  }

  Widget _buildPage(int currentPage) {
    switch (currentPage) {
      case 0:
        return MapsPage();
      case 1:
        return DirectionsPage();
      default:
        return MapsPage();
    }
  }
}
