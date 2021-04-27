import 'package:is_service/service_client.dart';
import 'package:is_service/service_client_response.dart';
import 'package:injectable/injectable.dart';

import '../../core/failure.dart';
import '../../core/internet_connection_service.dart';
import '../../domain/data_source/remote_datasource.dart';
import '../../infrastructure/core/remote_config_service.dart';

@LazySingleton(as: RemoteDataSource)
class RemoteDataSourceImpl implements RemoteDataSource {
  final ServiceClient _client;
  final RemoteConfigService _remoteConfigService;
  final NetworkConnection _network;

  RemoteDataSourceImpl(this._client, this._remoteConfigService, this._network);
  @override
  Future<IsResponse> getRequest(urlFragment) async {
    try {
      if (await _network.isConnected) {
        final serviceName =
            await _remoteConfigService.getServiceNameFromRemoteConfig();
        final _baseUrl = '$serviceName$urlFragment';
        return _client.get(_baseUrl);
      } else {
        throw NoInternetConection();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<IsResponse> postRequest({
    required Map<String, dynamic> json,
    required String urlFragment,
  }) async {
    try {
      if (await _network.isConnected) {
        final serviceName =
            await _remoteConfigService.getServiceNameFromRemoteConfig();
        final _url = '$serviceName$urlFragment';
        return _client.post(_url, json);
      } else {
        throw NoInternetConection();
      }
    } catch (e) {
      rethrow;
    }
  }
}
