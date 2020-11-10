import 'dart:convert';

import 'package:http/http.dart';

class ServiceClient {

  final String credential;
  BaseClient _client;

  ServiceClient(this.credential, {BaseClient client})
      : _client = client ?? Client();

  Future<dynamic> get(uri) => _send('GET', uri);

  Future<dynamic> post(uri, {Map<String, String> headers, body}) =>
      _send('POST', uri,json: body);

  Future<dynamic> _send(String method, url, {json}) async {
    Uri uri = url is String ? Uri.parse(url) : url;
    var request = Request(method, uri);

    if (credential != null) {
      request.headers['Authorization'] = 'Basic $credential';
    }

    if (json != null) {
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode(json);
    }
    var streamedResponse = await _client.send(request);
    var response = await Response.fromStream(streamedResponse);

    Object bodyJson;
    try {
      bodyJson = jsonDecode(response.body);
    } on FormatException {
      var contentType = response.headers['content-type'];
      if (contentType != null && !contentType.contains('application/json')) {
        throw Exception("Returned value was not JSON.");
      }
      rethrow;
    }
    if (response.statusCode != 200) {
      if (bodyJson is Map) {
        var error = bodyJson['error'];
        if (error != null) {
          throw ServiceClientException(response.statusCode, error.toString());
        }
      }
    }
    throw ServiceClientException(response.statusCode, bodyJson.toString());
  }
}

class ServiceClientException implements Exception {
  final int statusCode;
  final String message;

  ServiceClientException(this.statusCode, this.message);
  @override
  String toString() => '$message ($statusCode)';
}