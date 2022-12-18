import 'dart:convert';

List<Todo> todoFromJson(String str) => List<Todo>.from(json.decode(str).map((x) => Todo.fromJson(x)));

String todoToJson(List<Todo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Todo {
  Todo({
    this.toDoId,
    required this.title,
    required this.importance,
    required this.dueBy,
    required this.userId
  });

  dynamic toDoId;
  String title;
  int importance;
  String dueBy;
  String userId;

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    toDoId: json["toDoId"],
    title: json["title"],
    importance: json["importance"],
    dueBy: json["dueBy"],
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "toDoId": toDoId,
    "title": title,
    "importance": importance,
    "dueBy": dueBy,
    "userId": userId,
  };
}
