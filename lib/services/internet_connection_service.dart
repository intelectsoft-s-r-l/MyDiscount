import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';

class InternetConnection extends ChangeNotifier {
  internetConection() async {
    //print(" The statement 'this machine is connected to the Internet' is: ");
    //print(await DataConnectionChecker().hasConnection);

    print("Current status: ${await DataConnectionChecker().connectionStatus}");

    //print("Last results: ${DataConnectionChecker().lastTryResults}");

    final listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          print('Data connection is available.');
          break;
        case DataConnectionStatus.disconnected:
          print('You are disconnected from the internet.');
          break;
      }
    });
    listener.cancel();
    await Future.delayed(Duration(seconds: 0));
    return await DataConnectionChecker().connectionStatus;
  }

  //get conectionsStatus => ;
}
