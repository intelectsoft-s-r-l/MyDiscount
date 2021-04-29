import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'profile_model.g.dart';

@HiveType(typeId: 0)
class Profile extends Equatable {
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
  final String? pushToken;
  @HiveField(6)
  final int? registerMode;

  Profile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.photo,
    this.pushToken,
    this.registerMode,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['Email'],
      phone: json['phone'],
      photo: json['Photo'],
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
    );
  }

  Profile copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    Uint8List? photo,
  }) {
    return Profile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
    );
  }

  bool get isEmpty =>
      firstName == '' &&
      lastName == '' &&
      email == '' &&
      phone == '' &&
      pushToken == '' &&
      photo == Uint8List.fromList([]);

  @override
  List<Object?> get props => [];
}
