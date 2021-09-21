import 'dart:convert';
import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'profile_model.g.dart';
/// Dart object for Profile data provided by back service
///
/// Utilize this class for manage user profile data and display it on profile 
/// page
/// Obtain it on login or is added by user  

@HiveType(typeId: 0)
class Profile {
  ///User first name
  @HiveField(0)
  final String firstName;
  ///User last name
  @HiveField(1)
  final String lastName;
  ///User email
  @HiveField(2)
  final String email;
  ///User phone number 
  ///added on ProfilePage after SMS verification 
  @HiveField(3)
  final String phone;
  ///User Profile photo from login account 
  ///may by changed in ProfilePage 
  @HiveField(4)
  final Uint8List photo;
  ///Firebase Cloud Messaging token 
  @HiveField(5)
  final String? pushToken;
  @HiveField(6)
  ///Service register mode 
  /// 1-Google
  /// 2-Facebook
  /// 3-Apple
  final int? registerMode;

  Profile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.photo,
    required this.pushToken,
    required this.registerMode,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['Email']??'',
      phone: json['phone']??'',
      photo: json['Photo'],
      pushToken: json['PushToken']??'',
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
  ///JSON representation of all user data required to create a new User in 
  ///MyDiscount service
  Map<String, dynamic> toCreateUser() {
    return {
      'DisplayName': '$firstName $lastName',
      'Email': email,
      'ID': '',
      'phone': phone,
      'PhotoUrl': base64Encode(photo.toList()),
      'PushToken': pushToken,
      'RegisterMode': registerMode,
      'access_token': '',
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
      registerMode: -1,
    );
  }
  
  Profile copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    Uint8List? photo,
    String? pushToken,
    int? registerMode,
  }) {
    return Profile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      pushToken: pushToken ?? this.pushToken,
      registerMode: registerMode ?? this.registerMode,
    );
  }

  bool get isEmpty =>
      registerMode == -1 &&
      firstName == '' &&
      lastName == '' &&
      email == '' &&
      phone == '' &&
      pushToken == '';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Profile &&
            firstName == other.firstName &&
            lastName == other.lastName &&
            email == other.email &&
            phone == other.phone &&
            pushToken == other.pushToken &&
            photo == other.photo &&
            registerMode == other.registerMode;
  }

  @override
  int get hashCode => super.hashCode;
}
