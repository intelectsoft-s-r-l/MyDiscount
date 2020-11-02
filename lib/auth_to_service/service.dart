import 'package:MyDiscount/auth_to_service/service_client.dart';

 class ServiceFacade implements ServiceClient{
  @override
  Future get(url) {
      // TODO: implement get
      throw UnimplementedError();
    }
  
    @override
    Future post(url, {Map<String, String> headers, body}) {
    // TODO: implement post
    throw UnimplementedError();
  }

  @override
  // TODO: implement credential
  String get credential => throw UnimplementedError();
}
