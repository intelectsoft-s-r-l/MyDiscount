

/* class ServiceImpl {
  ServiceClient client = ServiceClient(Credentials.encoded);

  Future<List<Map<String, dynamic>>> getCompanyList() async {
    String id = await getUserId();
    String serviceName = await getServiceName();
    final uri = "$serviceName/json/GetCompany?ID=$id";
    final response = await client.get(uri);
    return response['Companies'];
  }

  Future<String> getTID() async {
    String serviceName = await getServiceName();
    final _body = await getBodyData();
    final uri = '$serviceName/json/GetTID';
    final response = await client.post(uri, body: _body);
    return response['TID'];
  }
} */
