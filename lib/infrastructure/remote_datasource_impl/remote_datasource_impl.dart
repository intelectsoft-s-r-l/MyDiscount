import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:is_service/service_client.dart';
import 'package:is_service/service_client_response.dart';

import '../../domain/data_source/remote_datasource.dart';
import '../../infrastructure/core/internet_connection_service.dart';
import '../core/failure.dart';

@LazySingleton(as: RemoteDataSource)
class RemoteDataSourceImpl implements RemoteDataSource {
  final ServiceClient _client;
  final NetworkConnection _network;

  static const url = 'https://dev.edi.md/ISMobileDiscountService';

  RemoteDataSourceImpl(this._client, this._network);
  @override
  Future<IsResponse> getRequest(urlFragment) async {
    try {
      if (await _network.isConnected) {
        final _baseUrl = '$url$urlFragment';
        return _client.get(_baseUrl)/* .timeout(const Duration(seconds: 3)) */;
      } else {
        throw NoInternetConection();
      }
    } catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(e, s);
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
        final _url = '$url$urlFragment';
        return _client.post(_url, json)/* .timeout(const Duration(seconds: 3)) */;
      } else {
        throw NoInternetConection();
      }
    } catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(e, s);
      rethrow;
    }
  }
}
