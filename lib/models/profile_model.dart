//import 'package:flutter/foundation.dart';

class Profile {
  final String firstName;
  final String lastName;
  final String email;
  final String photoUrl;
  final String birthDay;
  final String gender;
  final String phone;
  final String pushToken;
  final int registerMode;

  Profile({
     this.firstName,
     this.lastName,
     this.birthDay,
     this.gender,
     this.phone,
     this.email,
     this.photoUrl,
     this.registerMode,
     this.pushToken,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      birthDay: json['birthDay'],
      gender: json['gender'],
      phone: json['phone'],
      registerMode: json['registerMode'],
      pushToken: json['pushToken'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "photoUrl": photoUrl,
      "birthDay": birthDay,
      "gender": gender,
      "phone": phone,
      "registerMode": registerMode,
      'pushToken': pushToken,
    };
  }
}
