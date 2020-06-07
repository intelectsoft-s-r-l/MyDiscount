

/* Credential credential = Credential(credential.displayName, credential.email,
    credential.userId, credential.accessToken, credential.photoUrl);

Future<void> attemptSignIn(Credential credential) async {
  String credentials = "appuser:frj936epae293e9c6epae29";
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  String encoded = stringToBase64.encode(credentials);
  Map<String, String> headers = {
    'Content-type': 'application/json; charset=utf-8',
    'Authorization': 'Basic ' + encoded,
  };
  final url = 'http://5.181.156.96:8585/AppCardService/json/Register';
  final response = await http.post(url,
      headers: headers,
      body: json.encode({
        "DisplayName": '${credential.displayName}',
        "Email": '${credential.email}',
        "ID": '${credential.userId}',
        "PhotoUrl": '${credential.photoUrl}',
        "RegisterMode": '',
        "access_token": '${credential.accessToken}',
        "pw": "",
        "refresh_token": "",
        "token_type": ""
      }));
  print(response);
} */
