import 'dart:convert';
import 'package:http/http.dart' as http;
import 'todojson.dart';
import 'settingsjson.dart';

class RemoteService {
  String decodedToken = "";

  Future<List<Todo>?> getTodos(String token) async {
    var client = http.Client();

    var uri = Uri.parse("https://localhost:7019/api/ToDos");
    var _headers = {
      'Authorization': 'Bearer $token',
    };
    var response = await client.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      var json = response.body;
      return todoFromJson(json);
    } {
      throw Future.error("Unable to retrieve todos");
    }
  }

  Future<dynamic> createTodo(dynamic object, String token) async {
    var client = http.Client();
    var url = Uri.parse("https://localhost:7019/api/ToDos");
    var _payload = json.encode(object);
    var _headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var response = await client.post(url, body: _payload, headers: _headers);

    if (response.statusCode == 201) {
      return response.body;
    } {
      throw Future.error("Unable to create todo");
    }
  }

  Future<dynamic> editTodo(int id, dynamic object, String token) async {
    var client = http.Client();
    var url = Uri.parse("https://localhost:7019/api/ToDos/$id");
    var _payload = json.encode(object);
    var _headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var response = await client.put(url, body: _payload, headers: _headers);
    if (response.statusCode == 200) {
      return response.body;
    } {
      throw Future.error("Unable to edit todo");
    }
  }

  Future<dynamic> deleteTodo(int? id, dynamic object, String token) async {
    var client = http.Client();
    var url = Uri.parse("https://localhost:7019/api/ToDos/$id");
    var _payload = json.encode(object);
    var _headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var response = await client.delete(url, body: _payload, headers: _headers);
    if (response.statusCode == 200) {
      return response.body;
    } {
      throw Future.error("Unable to delete todo");
    }
  }

  Future<List<Settings>?> getSettings(String token) async {
    var client = http.Client();

    var uri = Uri.parse("https://localhost:7019/api/Settings");
    var _headers = {
      'Authorization': 'Bearer $token',
    };
    var response = await client.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      var json = response.body;
      return settingsFromJson(json);
    } else {
      throw Future.error("Unable to get settings");
    }
  }

  Future<dynamic> createSettings(dynamic object) async {
    var client = http.Client();
    var url = Uri.parse("https://localhost:7019/api/Settings");
    var _payload = json.encode(object);
    var _headers = {
      'Content-Type': 'application/json',
    };
    var response = await client.post(url, body: _payload, headers: _headers);

    if (response.statusCode == 201) {
      return response.body;
    } else {
      throw Future.error("Unable to initialize settings");
    }
  }

  Future<dynamic> editSettings(int id, dynamic object, String token) async {
    var client = http.Client();
    var url = Uri.parse("https://localhost:7019/api/Settings/$id");
    var _payload = json.encode(object);
    var _headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var response = await client.put(url, body: _payload, headers: _headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Future.error("Unable to update settings");
    }
  }

  Future<dynamic> registerUser(dynamic object) async {
    var client = http.Client();
    var url = Uri.parse("https://localhost:7019/api/authManagement/Register");
    var _payload = json.encode(object);
    var _headers = {
      'Content-Type': 'application/json',
    };

    var response = await client.post(url, body: _payload, headers: _headers);

    if (response.statusCode == 200) {
      decodedToken = json.decode(response.body)['token'];

      return decodedToken;
    } else {
      return Future.error("invalid user");
    }
  }

  Future<dynamic> loginUser(dynamic object) async {
    var client = http.Client();
    var url = Uri.parse("https://localhost:7019/api/authManagement/Login");
    var _payload = json.encode(object);
    print("loginUser line 127");
    var _headers = {
      'Content-Type': 'application/json',
    };
    var response = await client.post(url, body: _payload, headers: _headers);

    if (response.statusCode == 200) {
      decodedToken = json.decode(response.body)['token'];

      return decodedToken;
    } else {
      throw Future.error("invalid user");
    }
  }
}
