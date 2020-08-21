import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrImageWidget extends StatelessWidget {
  const QrImageWidget(this.function,this._progress);
  final Future<String> function;
  final double _progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          FutureBuilder<String>(
            future: function,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    RepaintBoundary(
                      child: QrImage(
                        data: '${snapshot.data}',
                        size: MediaQuery.of(context).size.height * 0.3,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.height * 0.2,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.white,
                        valueColor: AlwaysStoppedAnimation(Colors.green),
                        value: _progress,
                      ),
                    ),
                  ],
                );
              } else {
                return CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.green),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
