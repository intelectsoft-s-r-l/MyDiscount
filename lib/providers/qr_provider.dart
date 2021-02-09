import 'dart:async';

import 'package:MyDiscount/services/internet_connection_service.dart';
import 'package:MyDiscount/services/qr_service.dart';
import 'package:flutter/cupertino.dart';

/* class QrProvider with ChangeNotifier {
  QrService _service = QrService();
  final NetworkConnectionImpl internetConnection = NetworkConnectionImpl();

  double _progress = 1;
  int _countTID = 0;
  String _tid = '';
  bool _showImage = false;
  bool _showNoInternet = false;
  get progress => _progress;
  get tid => _tid;
  get showImage => _showImage;
  get showNoInet => _showNoInternet;

  QrProvider() {
    getTID();
    notifyListeners();
  }

  Future<void> getTID() async {
    try {
      if (await internetConnection.isConnected) {
        _countTID++;
        print(_countTID);
        double _counter = 7;
        final _response = await _service.getTID(false);
        _tid = _response['TID'];
        //notifyListeners();
        debugPrint('Tid: $_tid');
        // ignore: unused_local_variable
        Timer _timer = Timer.periodic(Duration(seconds: 1), (_timer) async {
          if (_counter > 0) {
            _counter--;
            _progress -= 0.1428;
            debugPrint('$_counter');
          } else if (_counter == 0 && _countTID < 3) {
            _progress = 1;
            _timer?.cancel();
            getTID();
          } else {
            _timer?.cancel();
          }
        });
        if (_countTID == 3) {}
        return _tid;
      } else {}
    } catch (e) {}
    //notifyListeners();
  }
} */
