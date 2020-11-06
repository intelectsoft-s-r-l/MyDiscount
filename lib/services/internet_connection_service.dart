import 'package:data_connection_checker/data_connection_checker.dart';

class InternetConnection  {
  verifyInternetConection() async {
   
    print("Current status: ${await DataConnectionChecker().connectionStatus}");

      /* final listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          print('Data connection is available.');
          break;
        case DataConnectionStatus.disconnected:
          print('You are disconnected from the internet.');
          break;
      }
    });
    listener.cancel(); */
    await Future.delayed(Duration(seconds: 0));
    return await DataConnectionChecker().connectionStatus;
  }
}
