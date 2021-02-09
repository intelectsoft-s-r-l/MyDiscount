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
      firstName: json['firstName']as String ?? '',
      lastName: json['lastName']as String ?? '',
      email: json['email']as String,
      phone:json['phone']as String,
      photoUrl: json['photoUrl']as String ?? '',
      registerMode: json['registerMode']as int,
      pushToken: json['pushToken']as String,
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
