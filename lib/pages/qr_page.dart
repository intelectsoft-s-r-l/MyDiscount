import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../core/failure.dart';
import '../core/localization/localizations.dart';
import '../services/internet_connection_service.dart';
import '../services/qr_service.dart';
import '../services/shared_preferences_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/nointernet_widget.dart';
import '../widgets/qr_page_widgets/human_image_widget.dart';
import '../widgets/qr_page_widgets/qr-widget.dart';

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
        _progress = 1.1;
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
    _imageController.sink?.add(false);
  }

  double _progress = 1.1;

  void _startTimer() {
    if (mounted) {
      double _counter = 11;

      countTID++;

      _timer = Timer.periodic(Duration(seconds: 1), (_timer) {
        if (_counter > 0) {
          _counter--;
          _showProgress();
          debugPrint('$_counter');
        } else if (_counter == 0) {
          if (countTID < 3) {
            _getAuthorization();
            _progress = 1.1;
            _timer?.cancel();
          } else {
            _changeImages();
            _timer?.cancel();
          }
        } else {
          _timer?.cancel();
        }
      });
    }

    debugPrint('Count:$countTID');
  }

  _showProgress() {
    _progress -= .1;
    print('progress: ${_progress.toStringAsFixed(2)}');
    if (mounted) _progressController.sink?.add(_progress);
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
        if (mounted) {
          _changeImages();
          setState(() {
            serviceConection = false;
          });
        }
      }
    } else {
      if (mounted) {
        _changeImages();
        setState(() {
          serviceConection = netConnection;
        });
      }
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
      final jsonMap = await sPref.readTID();
      if (jsonMap != null) {
        final Map<String, dynamic> map = json.decode(jsonMap);
        if (map['ErrorCode'] == 0) {
          final String id = map['TID'];
          print('id is:$id');
          return Future<String>.value(id);
        } else {
          throw NoInternetConection();
        }
      } else {
        return null;
      }
    }

    return CustomAppBar(
      title: AppLocalizations.of(context).translate('qr'),
      child: Container(
        color: Colors.white,
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
                                  _progress = 1.1;
                                },
                                child: serviceConection
                                    ? Text(
                                        AppLocalizations.of(context)
                                            .translate('generate'),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : Text(
                                        AppLocalizations.of(context)
                                            .translate('retry'),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
