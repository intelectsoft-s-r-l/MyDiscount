class Profile {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String photoUrl;
  final String pushToken;
  final int registerMode;

  Profile({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.photoUrl = '',
    this.registerMode,
    this.pushToken,
  }) : assert(photoUrl != null);

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'],
      phone:json['phone'],
      photoUrl: json['photoUrl'] ?? '',
      registerMode: json['registerMode'],
      pushToken: json['pushToken'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phone":phone,
      "photoUrl": photoUrl,
      "registerMode": registerMode,
      "pushToken": pushToken,
    };
  }
}
