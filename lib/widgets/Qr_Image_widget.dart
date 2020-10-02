import 'package:flutter/material.dart';

import 'package:qr_flutter/qr_flutter.dart';

class QrImageWidget extends StatelessWidget {
  const QrImageWidget(this.function, this._progress);
  final Future<String> function;
  final Stream<double> _progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * .7,
      width: MediaQuery.of(context).size.width * 0.8,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        size: MediaQuery.of(context).size.width * 0.65,
                      ),
                    ),
                    StreamBuilder<double>(
                        stream: _progress,
                        initialData: 1,
                        builder: (context, snapshot) {
                          return Container(
                            padding: EdgeInsets.only(
                              left: 8,
                              right: 8,
                            ),
                            width: MediaQuery.of(context).size.width * .65,
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.white,
                              minHeight: 4,
                              valueColor: AlwaysStoppedAnimation(Colors.green),
                              value: snapshot.data,
                            ),
                          );
                        }),
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
