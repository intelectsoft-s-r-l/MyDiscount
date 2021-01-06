//import 'package:equatable/equatable.dart';


class User {
  final String id;
  final String accessToken;
  //DateTime _session;
 /*  DateTime get session => _session;
  set session(value) {
    _session = session;
  } */

  User({
     this.id,
     this.accessToken,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['ID'],
      accessToken: json['access_token'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "ID": id,
      "access_token": accessToken,
    };
  }
  /* getAuthState() async {
 /*  final prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('user')) */ 
  if(session) authController.sink.add(true);
} */
}
