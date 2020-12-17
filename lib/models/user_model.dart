//import 'package:equatable/equatable.dart';

import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String accessToken;
 /*  final DateTime session;

 // bool _isLogedIn;
 bool get isLogedIn {
    if(session.isAfter(DateTime.now())){
     return false;
    }else{
     return true;
    }
  } */

  User({
    @required this.id,
    @required this.accessToken,
 /*    @required this.session, */
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['ID'],
        accessToken: json['access_token'],
        //session: json['Session']
        );
  }
  Map<String, dynamic> toJson() {
    return {"ID": id, "access_token": accessToken};
  }
}
