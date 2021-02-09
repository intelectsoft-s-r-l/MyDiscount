class User {
  final String id;
  final String accessToken;
  final String expireDate;

  User({
    this.id,
    this.accessToken,
    this.expireDate,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['ID']as String,
      accessToken: json['access_token']as String,
      expireDate: json['expireDate']as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "ID": id,
      "access_token": accessToken,
      "expireDate": expireDate,
    };
  }
}
