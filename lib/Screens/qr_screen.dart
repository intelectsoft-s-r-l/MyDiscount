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
  StreamController<bool> _imageController = StreamController.broadcast();
  StreamController<double> _progressController = StreamController.broadcast();
  static QrService _qrService = QrService();
  final InternetConnection internetConnection = InternetConnection();

  int countTID = 0;
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
    _imageController.sink.add(false);
  }

  void startTimer() {
    countTID++;
    print('Count:$countTID');
    _counter = 7;
    _timer = Timer.periodic(Duration(seconds: 1), (_timer) {
      if (_counter > 0) {
        _counter--;
        _progress -= 0.1428;
        _progressController.sink.add(_progress);
        debugPrint('$_counter');
      } else if (_counter == 0) {
        if (countTID < 3) {
          getAuthorization();
          _progress = 1;
          _timer?.cancel();
        } else {
          changeImages();
          _progress = 1;
          _timer?.cancel();
        }
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _imageController.sink.add(true);
        print('resumed');
        _timer?.cancel();
        getAuthorization();
        countTID = 0;
        _counter = 7;
        _progress = 1;
        _progressController.sink.add(_progress);
        break;

      case AppLifecycleState.inactive:
        _timer?.cancel();
        print('inactive');
        break;
      case AppLifecycleState.paused:
        print('paused');
        _timer?.cancel();
        break;
      case AppLifecycleState.detached:
        print('detached');
        _timer?.cancel();
        break;
      default:
        // ignore: null_aware_in_condition
        if (_timer?.isActive) _timer?.cancel();
        break;
    }
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
            _imageController.sink.add(false);
            setState(() {
              serviceConection = true;
            });

            // ignore: null_aware_in_condition
            if (_timer?.isActive) _timer?.cancel();
          } else {
            startTimer();
          }

          if (service.isNotEmpty) {
            setState(() {
              serviceConection = true;
            });
          } else {
            changeImages();
            setState(() {
              serviceConection = false;
            });

            // ignore: null_aware_in_condition
            if (_timer?.isActive) _timer?.cancel();
          }
        } catch (e) {
          // ignore: null_aware_in_condition
          if (_timer?.isActive) _timer?.cancel();

          print(e);
        }
        break;
      case DataConnectionStatus.disconnected:
        _imageController.add(false);
        setState(() {
          serviceConection = false;
        });
    }
  }

  @override
  void dispose() {
    _imageController.close();
    _progressController.close();
    super.dispose();
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
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
            const EdgeInsets.only(top: 50, bottom: 50, left: 30, right: 30),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 1),
                blurRadius: 2,
              )
            ],
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
                StreamBuilder<bool>(
                  stream: _imageController.stream,
                  initialData: true,
                  builder: (context, snapshot) {
                    return snapshot.data
                        ? QrImageWidget(
                            _loadSharedPref(), _progressController.stream)
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              serviceConection
                                  ? HumanImage()
                                  : NoInternetWidget(),
                              const SizedBox(height: 10.0),
                              RaisedButton(
                                onPressed: () {
                                  _imageController.add(true);
                                  setState(() {
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
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
