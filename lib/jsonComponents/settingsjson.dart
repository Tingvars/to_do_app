import 'dart:convert';

List<Settings> settingsFromJson(String str) =>
    List<Settings>.from(json.decode(str).map((x) => Settings.fromJson(x)));

String settingsToJson(List<Settings> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Settings {
  Settings({
    this.settingsId,
    required this.numToDos,
    required this.userId,
    required this.language,
  });

  dynamic settingsId;
  dynamic numToDos;
  String userId;
  String language;

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        settingsId: json["settingsId"],
        numToDos: json["numToDos"],
        userId: json["userId"],
      language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "settingsId": settingsId,
        "numToDos": numToDos,
        "userId": userId,
    "language": language,
      };
}
