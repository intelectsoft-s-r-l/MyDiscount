import 'package:data_connection_checker/data_connection_checker.dart';

abstract class NetworkConnection {
  Future<bool> get isConnected;
}

class NetworkConnectionImpl implements NetworkConnection {
  final DataConnectionChecker connectionChecker;

  NetworkConnectionImpl({this.connectionChecker});

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
