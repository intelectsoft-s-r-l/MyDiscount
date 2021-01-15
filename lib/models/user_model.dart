
class User {
  final String id;
  final String accessToken;

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
}
