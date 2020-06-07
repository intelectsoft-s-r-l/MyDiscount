//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

// @override
// void initState() { 
//   //super.initState();
//   FirebaseAuth.instance;
// }
class User {
  final String id;
  const User(this.id);
}

class AuthResult {
  AuthResult(this._data) : user = DataBaseUser();

  final DataBaseAuthResult _data;

  final DataBaseUser user;

  @override
  String toString() {
    return '$runtimeType($_data)';
  }
}

class DataBaseUser {
  const DataBaseUser({
    final String id,
  });
}

class DataBaseAuthResult {
  const DataBaseAuthResult({@required this.user});
  final DataBaseUser user;
}
