import 'dart:async';
import 'dart:convert';

import 'package:MyDiscount/core/failure.dart';
import 'package:flutter/material.dart';

import '../core/localization/localizations.dart';
import '../services/internet_connection_service.dart';
import '../services/qr_service.dart';
import '../services/shared_preferences_service.dart';
import '../widgets/human_image_widget.dart';
import '../widgets/nointernet_widget.dart';
import '../widgets/qr-widget.dart';

class QrPage extends StatefulWidget {
  QrPage({
    Key key,
  }) : super(key: key);

  @override
  _QrPageState createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> with WidgetsBindingObserver {
  StreamController<bool> _imageController = StreamController.broadcast();
  StreamController<double> _progressController = StreamController.broadcast();
  final QrService qrService = QrService();
  final NetworkConnectionImpl internetConnection = NetworkConnectionImpl();

  int countTID = 0;
  bool serviceConection;

  Timer _timer;
  int index = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) _getAuthorization();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _imageController.sink.add(true);
        debugPrint('resumed');
        _timer?.cancel();
        _getAuthorization();
        countTID = 0;
        break;

      case AppLifecycleState.inactive:
        _timer?.cancel();
        debugPrint('inactive');
        break;
      case AppLifecycleState.paused:
        debugPrint('paused');
        _timer?.cancel();
        break;
      case AppLifecycleState.detached:
        debugPrint('detached');
        _timer?.cancel();
        break;
      default:
        if (_timer.isActive) _timer?.cancel();
        break;
    }
  }

  _changeImages() {
    _imageController.sink.add(false);
  }

  void _startTimer() {
    double _counter = 7;
    double _progress = 1;

    countTID++;
    if (mounted)
      _timer = Timer.periodic(Duration(seconds: 1), (_timer) {
        if (_counter > 0) {
          _counter--;
          _progress -= 0.1428;
          _progressController.sink.add(_progress);
          debugPrint('$_counter');
        } else if (_counter == 0) {
          if (countTID < 3) {
            _getAuthorization();
            _progress = 1;
            _timer?.cancel();
          } else {
            _changeImages();
            _timer?.cancel();
          }
        } else {
          _timer?.cancel();
        }
      });
    debugPrint('Count:$countTID');
  }

  _getAuthorization() async {
    bool netConnection = await internetConnection.isConnected;
    if (netConnection) {
      final response = await qrService.getTID(false);
      if (response['ErrorCode'] == 0 || response.isNotEmpty) {
        if (mounted)
          setState(() {
            serviceConection = netConnection;
          });
        if (countTID == 3) {
          _changeImages();
          if (_timer.isActive) _timer?.cancel();
        } else {
          _startTimer();
        }
      } else {
        _changeImages();
        if (mounted)
          setState(() {
            serviceConection = false;
          });
      }
    } else {
      _changeImages();
      if (mounted)
        setState(() {
          serviceConection = netConnection;
        });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (mounted) _imageController?.close();
    if (mounted) _progressController?.close();
    if (mounted) _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final SharedPref sPref = SharedPref();

    Future<String> _loadSharedPref() async {
      //final data = await sPref.instance;
      final jsonMap = await sPref.readTID();
      final Map<String, dynamic> map = json.decode(jsonMap);
      if (map['ErrorCode'] == 0) {
        final String id = map['TID'];
        //data.remove('Tid');
        return Future<String>.value(id);
      } else {
        throw NoInternetConection();
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context).translate('qr')),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Container(
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: StreamBuilder<bool>(
                      stream: _imageController.stream,
                      initialData: true,
                      builder: (context, snapshot) {
                        return snapshot.data
                            ? QrImageWidget(
                                function: _loadSharedPref(),
                                size: size,
                                progressController: _progressController)
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
                                      _getAuthorization();
                                      countTID = 0;
                                    },
                                    child: serviceConection
                                        ? Text(
                                            AppLocalizations.of(context)
                                                .translate('text5'),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ), //textScaleFactor: 1,
                                          )
                                        : Text(
                                            AppLocalizations.of(context)
                                                .translate('text8'),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ), //textScaleFactor: 1,
                                          ),
                                    color: Colors.green,
                                  ),
                                ],
                              );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
