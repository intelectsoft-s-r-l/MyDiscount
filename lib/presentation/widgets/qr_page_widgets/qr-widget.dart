import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrImageWidget extends StatelessWidget {
  const QrImageWidget({
    Key? key,
    required this.future,
    required this.size,
    required StreamController<double> progressController,
  })  : _progressController = progressController,
        super(key: key);
  final Future<String> future;
  final Size size;
  final StreamController<double> _progressController;

  @override
  Widget build(BuildContext context) {
    
    return Container(
      child: Card(
        color: Colors.transparent,
        elevation: 8,
        shape:const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Container(
          width: size.width * .8,
          height: size.width * .8,
          decoration:const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: FutureBuilder<String>(
                  //initialData: '',
                  future: future,
                  builder: (context, snapshot) => snapshot.hasData
                      ? Container(
                          alignment: Alignment.center,
                          child: ShaderMask(
                            blendMode: BlendMode.srcATop,
                            shaderCallback: (rect) =>const LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black,
                                Colors.green,
                              ],
                            ).createShader(rect),
                            child: QrImage(
                              data: snapshot.data as String,
                              size: size.width * .6,
                            ),
                          ),
                        )
                      : Container(),
                ),
              ),
              StreamBuilder<double>(
                initialData: 1,
                stream: _progressController.stream,
                builder: (context, snapshot) {
                  return LinearProgressIndicator(
                    value: snapshot.data,
                    backgroundColor: Colors.white,
                    valueColor:const AlwaysStoppedAnimation(Colors.green),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
