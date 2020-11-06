import 'dart:async';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../services/internet_connection_service.dart';
import '../services/qr_service.dart';
import '../services/shared_preferences_service.dart';
import '../widgets/widgets/circular_progress_indicator_widget.dart';
import '../widgets/widgets/human_image_widget.dart';
import '../widgets/widgets/localizations.dart';
import '../widgets/widgets/nointernet_widget.dart';
import '../widgets/widgets/top_bar_image.dart';
import '../widgets/widgets/top_bar_text.dart';

// ignore: must_be_immutable
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
    final size = MediaQuery.of(context).size;
    final SharedPref sPref = SharedPref();
    Future<String> _loadSharedPref() async {
      //SharedPreferences preferences = await SharedPreferences.getInstance();
      final id = await sPref.readTID();
      return Future<String>.value(id);
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              TopBarImage(size: size),
              Positioned(
                top: size.height * .07,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    //dispose();
                    Navigator.pushReplacementNamed(context,'/app'
                     
                    );
                  },
                ),
              ),
              AppBarText(size: size, text: 'Qr-Code'),
            ],
          ),
          StreamBuilder<bool>(
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
                        serviceConection ? HumanImage() : NoInternetWidget(),
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
          Stack(
            children: [
              Container(
                child: SvgPicture.asset(
                  'assets/icons/bottom.svg',
                  width: size.width,
                  height: size.height * .18,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                left: size.width * .1,
                bottom: size.height * .035,
                child: Container(
                  width: size.width * .8,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        'Prezentati acest cod casierului',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Codul se modifica la fiecare 10 sec.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class QrImageWidget extends StatelessWidget {
  const QrImageWidget({
    Key key,
    @required this.function,
    @required this.size,
    @required StreamController<double> progressController,
  })  : _progressController = progressController,
        super(key: key);
  final Future<String> function;
  final Size size;
  final StreamController<double> _progressController;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Container(
          width: size.width * .8,
          height: size.width * .8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: FutureBuilder(
                    future: function,
                    builder: (context, snapshot) => snapshot.hasData
                        ? ShaderMask(
                            blendMode: BlendMode.srcATop,
                            shaderCallback: (rect) => LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black,
                                Colors.green,
                              ],
                            ).createShader(rect),
                            child: QrImage(
                              data: snapshot.data,
                              size: size.width * .6,
                            ),
                          )
                        : CircularProgresIndicatorWidget(),
                  ),
                ),
              ),
              StreamBuilder<double>(
                initialData: 1,
                stream: _progressController.stream,
                builder: (context, snapshot) {
                  return LinearProgressIndicator(
                    value: snapshot.data,
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation(Colors.green),
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
