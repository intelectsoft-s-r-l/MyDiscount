import 'dart:async';

import 'package:flutter/material.dart';

import 'package:data_connection_checker/data_connection_checker.dart';

import '../widgets/nointernet_widget.dart';
import '../widgets/Qr_Image_widget.dart';
import '../widgets/human_image_widget.dart';
import '../services/internet_connection_service.dart';
import '../services/qr_service.dart';
import '../services/shared_preferences_service.dart';
import '../widgets/localizations.dart';

class QrScreen extends StatefulWidget {
  @override
  _QrScreenState createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> with WidgetsBindingObserver {
  static QrService _qrService = QrService();
  final InternetConnection internetConnection = InternetConnection();

  int countTID = 0;
  bool chengeImage = true;
  bool serviceConection = true;
  double _counter;
  Timer _timer;
  int index = 1;
  double _progress = 1;

  @override
  void initState() {
    getAuthorization();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  changeImages() {
    setState(() {
      chengeImage = false;
    });
  }

  void startTimer() {
    countTID++;
    print('Count:$countTID');
    _counter = 7;
    _timer = Timer.periodic(Duration(seconds: 1), (_timer) {
      if (_counter > 0) {
        _counter--;
        setState(() {
          _progress -= 0.1428;
        });

        print(_counter);
      } else if (_counter == 0) {
        if (countTID < 3) {
          getAuthorization();
          _progress = 1;
          _timer.cancel();
        } else {
          changeImages();
          _progress = 1;
          _timer.cancel();
        }
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (chengeImage && serviceConection) {
      switch (state) {
        case AppLifecycleState.resumed:
          print('resumed');
          _timer.cancel();
          getAuthorization();
          countTID = 0;
          _counter = 7;
          _progress = 1;
          break;

        case AppLifecycleState.inactive:
          print('inactive');
          setState(() {
            _timer.cancel();
            _counter = 7;
          });

          break;
        case AppLifecycleState.paused:
          print('paused');
          setState(() {
            _timer.cancel();
            _counter = 7;
          });
          break;
        case AppLifecycleState.detached:
          print('detached');
          setState(() {
            _timer.cancel();
            _counter = 7;
          });

          break;
        default:
          _timer.cancel();
          break;
      }
    }

    if (!chengeImage) {
      print('object else');
      _timer.cancel();
      setState(() {
        _counter = 7;
        countTID = 0;
        chengeImage = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (chengeImage) _timer.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }

  getAuthorization() async {
    DataConnectionStatus status =
        await internetConnection.verifyInternetConection();
    _counter = 7;
    switch (status) {
      case DataConnectionStatus.connected:
        try {
          var service = await _qrService.attemptSignIn();
          if (countTID == 3) {
            setState(() {
              chengeImage = false;
              serviceConection = true;
              if (_timer.isActive) {
                _timer.cancel();
              }
            });
          } else {
            startTimer();
          }

          if (service) {
            setState(() {
              serviceConection = true;
            });
          } else {
            changeImages();
            setState(() {
              serviceConection = false;
            });

            if (_timer.isActive) {
              _timer.cancel();
            }
          }
        } catch (e) {
          if (_timer.isActive) {
            _timer.cancel();
          }
          print(e);
        }
        break;
      case DataConnectionStatus.disconnected:
        setState(
          () {
            chengeImage = false;
            serviceConection = false;
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final SharedPref sPref = SharedPref();
    Future<String> _loadSharedPref() async {
      final id = await sPref.readTID();
      return id;
    }

    return Container(
      decoration: const BoxDecoration(
        color: const Color.fromRGBO(240, 242, 241, 1),
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 70, bottom: 70, left: 30, right: 30),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                chengeImage
                    ? QrImageWidget(_loadSharedPref(), _progress)
                    : Column(
                        children: <Widget>[
                          serviceConection ? HumanImage() : NoInternetWidget(),
                          const SizedBox(height: 10.0),
                          RaisedButton(
                            onPressed: () {
                              setState(() {
                                chengeImage = true;
                                serviceConection = true;
                              });
                              getAuthorization();
                              countTID = 0;
                            },
                            child: serviceConection
                                ? Text(
                                    AppLocalizations.of(context)
                                        .translate('text5'),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : Text(
                                    AppLocalizations.of(context)
                                        .translate('text8'),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            color: Colors.green,
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
