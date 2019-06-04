import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_reader_app/src/models/scan_model.dart';

launchScan(BuildContext context, ScanModel scan) async {
  final url = scan.value;
  if (scan.type == 'http') {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  } else {
    Navigator.pushNamed(context, 'map', arguments: scan);
  }
}
