import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:injectable/injectable.dart';

abstract class NetworkConnection {
  Future<bool> get isConnected;
}
@injectable
class NetworkConnectionImpl implements NetworkConnection {
  final DataConnectionChecker connectionChecker;

  NetworkConnectionImpl({this.connectionChecker});

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
