import 'package:IsService/service_client.dart';
import 'package:IsService/service_client_response.dart';
import '../../core/failure.dart';
import '../../core/internet_connection_service.dart';
import '../../domain/data_source/remote_datasource.dart';
import '../../services/remote_config_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: RemoteDataSource)
class RemoteDataSourceImpl implements RemoteDataSource {
  final ServiceClient _client;
  final RemoteConfigService _remoteConfigService;
  final NetworkConnection _network;

  RemoteDataSourceImpl(this._client, this._remoteConfigService, this._network);
  @override
  Future<IsResponse> getRequest(urlFragment) async {
    try {
      final serviceName =
          await _remoteConfigService?.getServiceNameFromRemoteConfig();
      final _baseUrl = '$serviceName$urlFragment';
      return _client.get(_baseUrl);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<IsResponse> postRequest(Map<String, dynamic> json) async {
    try {
      if (await _network?.isConnected) {
        final serviceName =
            await _remoteConfigService?.getServiceNameFromRemoteConfig();
        final _url = '$serviceName/json/UpdateClientInfo';
        return _client.post(_url, json);
      } else {
        throw NoInternetConection();
      }
    } catch (e) {
      rethrow;
    }
  }
}
