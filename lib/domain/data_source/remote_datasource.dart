import 'package:is_service/service_client_response.dart';

///[RemoteDataSource] is a interface to work with is_service library
abstract class RemoteDataSource {
  Future<IsResponse> getRequest(String urlFragment);
  Future<IsResponse> postRequest({
    required Map<String, dynamic> json,
    required String urlFragment,
  });
}
