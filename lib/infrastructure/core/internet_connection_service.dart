import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
/// Check internet connection of device
abstract class NetworkConnection {
  Future<bool> get isConnected;
}

@LazySingleton(as: NetworkConnection)
class NetworkConnectionImpl implements NetworkConnection {
  final InternetConnectionChecker connectionChecker;

  NetworkConnectionImpl({required this.connectionChecker});

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
