import 'dart:async';
import 'package:flutter/material.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

import '../services/internet_connection_service.dart';
import '../services/qr_service.dart';
import '../services/shared_preferences_service.dart';
import '../widgets/localizations.dart';

class QrScreen extends StatefulWidget {
  QrScreen({Key key}) : super(key: key);

  @override
  _QrScreenState createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  static QrService _qrService = QrService();
  InternetConnection internetConnection = InternetConnection();

  int countTID = 0;
  bool chengeImage = true;
  bool isLogin = false;
  bool serviceConection = true;
  double _counter;
  Timer _timer;
  int index = 1;

  @override
  void initState() {
    getAuthorization();
    super.initState();
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
        print(_counter);
      } else if (_counter == 0) {
        if (countTID < 3) {
          getAuthorization();
          _timer.cancel();
        } else {
          changeImages();
          _timer.cancel();
        }
      } else {
        _timer.cancel();
      }
    });
  }

  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  getAuthorization() async {
    DataConnectionStatus status = await internetConnection.internetConection();

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
        setState(() {
          chengeImage = false;
          serviceConection = false;
          /*   if (_timer.isActive) {
            _timer.cancel();
          } */
        });
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
      decoration: BoxDecoration(
        color: Color.fromRGBO(240, 242, 241, 1),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 70, bottom: 70, left: 30, right: 30),
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
                      ? Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              FutureBuilder<String>(
                                future: _loadSharedPref(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return RepaintBoundary(
                                      child: QrImage(
                                        data: '${snapshot.data}',
                                        size:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                      ),
                                    );
                                  } else {
                                    return CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.green),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: <Widget>[
                            serviceConection
                                ? Container(
                                    alignment: Alignment.center,
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          child: Image.asset(
                                            'assets/icons/om.png',
                                            scale: 0.5,
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(
                                          AppLocalizations.of(context)
                                              .translate('text3'),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          AppLocalizations.of(context)
                                              .translate('text4'),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ))
                                : Center(
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            child: Image.asset(
                                                'assets/icons/no internet.png'),
                                          ),
                                          const SizedBox(height: 20.0),
                                          Text(
                                            AppLocalizations.of(context)
                                                .translate('text6'),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            AppLocalizations.of(context)
                                                .translate('text7'),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 10.0),
                            RaisedButton(
                              onPressed: () {
                                setState(() {
                                  isLogin = true;
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
                              color: Colors
                                  .green, //Color.fromRGBO(42, 86, 198, 1),
                            ),
                          ],
                        ),
                ],
              ),
            )),
      ),
    );
  }
}
