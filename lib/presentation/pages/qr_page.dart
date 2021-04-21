import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_discount/presentation/widgets/circular_progress_indicator_widget.dart';

import '../../core/internet_connection_service.dart';
import '../../core/localization/localizations.dart';
import '../../domain/repositories/is_service_repository.dart';
import '../../injectable.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/nointernet_widget.dart';
import '../widgets/qr_page_widgets/human_image_widget.dart';
import '../widgets/qr_page_widgets/qr-widget.dart';

class QrPage extends StatefulWidget {
  const QrPage({Key? key}) : super(key: key);

  @override
  _QrPageState createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> with WidgetsBindingObserver {
  final StreamController<bool> _imageController = StreamController.broadcast();
  final StreamController<double> _progressController =
      StreamController.broadcast();

  int countTID = 0;
  late bool serviceConection;
  late String tempId = '';
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    getIt<IsService>().getClientInfo();
    getIt<IsService>().getCompanyList();
    if (mounted) _getAuthorization();

    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _imageController.sink.add(true);
        debugPrint('resumed');
        _timer.cancel();
        _getAuthorization();
        countTID = 0;
        _progress = 1.1;
        break;

      case AppLifecycleState.inactive:
        _timer.cancel();
        debugPrint('inactive');
        break;
      case AppLifecycleState.paused:
        debugPrint('paused');
        _timer.cancel();
        break;
      case AppLifecycleState.detached:
        debugPrint('detached');
        _timer.cancel();
        break;
      default:
        if (_timer.isActive) _timer.cancel();
        break;
    }
  }

  void _changeImages() {
    _imageController.sink.add(false);
  }

  double _progress = 1.1;

  void _startTimer() {
    if (mounted) {
      var _counter = 11;

      countTID++;

      _timer = Timer.periodic(const Duration(seconds: 1), (_timer) {
        if (_counter > 0) {
          _counter--;
          _showProgress();
          debugPrint('$_counter');
        } else if (_counter == 0) {
          if (countTID < 3) {
            _getAuthorization();
            _progress = 1.1;
            _timer.cancel();
          } else {
            _changeImages();
            _timer.cancel();
          }
        } else {
          _timer.cancel();
        }
      });
    }

    debugPrint('Count:$countTID');
  }

  void _showProgress() {
    _progress -= .1;
    print('progress: ${_progress.toStringAsFixed(2)}');
    if (mounted) _progressController.sink.add(_progress);
  }

  void _getAuthorization() async {
    try {
      final netConnection = await getIt<NetworkConnection>().isConnected;
      if (netConnection) {
        try {
          tempId = await getIt<IsService>().getTempId();
          if (mounted) {
            setState(() {
              serviceConection = netConnection;
            });
          }
          if (countTID == 3) {
            _changeImages();
            if (_timer.isActive) _timer.cancel();
          } else {
            _startTimer();
          }
        } catch (e) {
          rethrow;
        }
      } else {
        if (mounted) {
          _changeImages();
          setState(() {
            serviceConection = netConnection;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        _changeImages();
        setState(() {
          serviceConection = false;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (mounted) _imageController.close();
    if (mounted) _progressController.close();
    if (mounted) _timer.cancel();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return CustomAppBar(
      title: AppLocalizations.of(context)!.translate('qr'),
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
                    return snapshot.data as bool
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            //mainAxisSize:MainAxisSize.min,
                            children: [
                              Text(
                                  AppLocalizations.of(context)!
                                      .translate('showqr')!,
                                  style: const TextStyle(
                                      //fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              Text(
                                  AppLocalizations.of(context)!
                                      .translate('qrtime')!,
                                  style: const TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              SizedBox(
                                height: size.height * .06,
                              ),
                              tempId != ''
                                  ? QrImageWidget(
                                      size: size,
                                      progressController: _progressController,
                                      future: Future.value(tempId),
                                    )
                                  : Container(
                                      width: size.width * .8,
                                      height: size.width * .8,
                                      child: CircularProgresIndicatorWidget(),
                                    )
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              serviceConection
                                  ? const HumanImage()
                                  : const NoInternetWidget(),
                              const SizedBox(height: 10.0),
                              ElevatedButton(
                                onPressed: () {
                                  _imageController.add(true);
                                  _getAuthorization();
                                  countTID = 0;
                                  _progress = 1.1;
                                },
                                child: serviceConection
                                    ? Text(
                                        AppLocalizations.of(context)!
                                            .translate('generate')!,
                                        style: const TextStyle(
                                          // color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : Text(
                                        AppLocalizations.of(context)!
                                            .translate('retry')!,
                                        style: const TextStyle(
                                          //color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
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
/* edx  (G74,Jr:hL2QNX&V) */
