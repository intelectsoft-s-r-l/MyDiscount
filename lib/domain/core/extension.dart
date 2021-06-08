import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

extension AuthorizationCredentialAppleIDX on AuthorizationCredentialAppleID {
  Map<String, dynamic> toMap() {
    return {
      'DisplayName': '$givenName $familyName',
      'Email': email,
      'ID': userIdentifier,
      'PhotoUrl': '',
      'PushToken': '',
      'RegisterMode': 3,
      'access_token': identityToken,
      'phone': '',
    };
  }
}

extension FacebookUserProfileX on FacebookAuth {
  Map<String, dynamic> toCredMap({
    required AccessToken? token,
    required Map<String, dynamic> profile,
  }) {
    return {
      'DisplayName': profile['name'],
      'Email': profile['email'],
      'ID': token!.userId,
      'PhotoUrl': profile['picture']['data']['url'],
      'PushToken': '',
      'RegisterMode': 2,
      'access_token': token.token,
      'phone': '',
    };
  }
}
extension GoogleSignInAccountX on GoogleSignInAccount{
  
 Map<String,dynamic> toMap(String? token){
    return {
      'DisplayName': displayName,
      'Email': email,
      'ID': id,
      'PhotoUrl':photoUrl ,
      'PushToken': '',
      'RegisterMode': 1,
      'access_token': token,
      'phone': '',
    };
 }
}