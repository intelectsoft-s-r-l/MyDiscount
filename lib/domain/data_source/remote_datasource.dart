import 'package:is_service/service_client_response.dart';

abstract class RemoteDataSource {
  Future<IsResponse> getRequest(String urlFragment);
  Future<IsResponse> postRequest({required Map<String,dynamic>json,required String urlFragment});
}
