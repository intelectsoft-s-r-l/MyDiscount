import 'dart:convert';
import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'profile_model.g.dart';

@HiveType(typeId: 0)
class Profile {
  @HiveField(0)
  final String firstName;
  @HiveField(1)
  final String lastName;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String phone;
  @HiveField(4)
  final Uint8List photo;
  @HiveField(5)
  final String pushToken;
  @HiveField(6)
  final int registerMode;

  Profile({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.photo,
    this.pushToken,
    this.registerMode,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['Email'],
      phone: json['phone'],
      photo: json['Photo'], /* ?? Uint8List.fromList([]), */
      pushToken: json['PushToken'],
      registerMode: json['mode'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'Email': email,
      'phone': phone,
      'Photo': photo,
      'PushToken': pushToken,
      'mode': registerMode,
    };
  }

  Map<String, dynamic> toCreateUser() {
    return {
      'DisplayName': '$firstName $lastName',
      'Email': email,
      'ID':null,
      'phone': phone,
      'PhotoUrl': base64Encode(photo.toList()),
      'PushToken': pushToken,
      'RegisterMode': registerMode,
      'access_token':null,
    };
  }

  factory Profile.empty() {
    return Profile(
      firstName: '',
      lastName: '',
      email: '',
      phone: '',
      photo: Uint8List.fromList([]),
      pushToken: '',
    );
  }

  Profile copyWith({
    String firstName,
    String lastName,
    String email,
    String phone,
    Uint8List photo,
  }) {
    return Profile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
    );
  }
}
