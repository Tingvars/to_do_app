// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';
//
// Future<TodoMap> fetchTodoMap() async {
//   final response = await http
//       .get(Uri.parse('https://localhost:7019/api/ToDos'));
//
//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     return TodoMap.fromJson(jsonDecode(response.body));
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load todo');
//   }
// }
//
// class TodoMap {
//   final int ToDoId;
//   final int Importance;
//   final String Title;
//
//   const TodoMap({
//     required this.ToDoId,
//     required this.Importance,
//     required this.Title,
//   });
//
//   factory TodoMap.fromJson(Map<String, dynamic> json) {
//     return TodoMap(
//       ToDoId: json['toDoId'],
//       Importance: json['importance'],
//       Title: json['title'],
//     );
//   }
// }
