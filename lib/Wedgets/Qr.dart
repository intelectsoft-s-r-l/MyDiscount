import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
class QrGenerator extends StatefulWidget {
  @override
  _QrGeneratorState createState() => _QrGeneratorState();
}

class _QrGeneratorState extends State<QrGenerator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: QrImage(data: null),
    );
  }
}