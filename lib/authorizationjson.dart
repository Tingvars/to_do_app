import 'dart:convert';

List<User> userFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  User({
    this.Id,
    this.token,
    required this.username,
    required this.email,
    required this.password,
  });

  dynamic Id;
  String? token;
  String username;
  String email;
  String password;

  factory User.fromJson(Map<String, dynamic> json) => User(
    Id: json["Id"],
    username: json["username"],
    email: json["email"],
   password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "Id": Id,
    "username": username,
    "email": email,
    "password": password
  };
}
