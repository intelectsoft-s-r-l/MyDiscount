import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:injectable/injectable.dart';

abstract class NetworkConnection {
  Future<bool> get isConnected;
}
@LazySingleton(as: NetworkConnection)
class NetworkConnectionImpl implements NetworkConnection {
  final InternetConnectionChecker connectionChecker;

  NetworkConnectionImpl({this.connectionChecker});

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
