import 'dart:convert';

import 'package:http/http.dart' as http;
import 'todojson.dart';
import 'settingsjson.dart';
import"authorizationjson.dart";

class RemoteService {
  String decodedToken = "";
  String loggedInUserId = "";

  Future<List<Todo>?> getTodos() async
  {
    var client = http.Client();

    var uri = Uri.parse("https://localhost:7019/api/ToDos");
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      return todoFromJson(json);
    }
  }

  Future<dynamic> createTodo(dynamic object) async {
    var client = http.Client();
    var url = Uri.parse("https://localhost:7019/api/ToDos");
    var _payload = json.encode(object);
    var _headers = {
      'Content-Type': 'application/json',
    };

    var response = await client.post(url, body: _payload, headers: _headers);

    if (response.statusCode == 201) {
      return response.body;
    } else {}
  }

  Future<dynamic> editTodo(int id, dynamic object) async {
    var client = http.Client();
    var url = Uri.parse("https://localhost:7019/api/ToDos/$id");
    var _payload = json.encode(object);
    var _headers = {
      'Content-Type': 'application/json',
    };

    var response = await client.put(url, body: _payload, headers: _headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
    }
  }

  Future<dynamic> deleteTodo(int? id, dynamic object) async {
    var client = http.Client();
    var url = Uri.parse("https://localhost:7019/api/ToDos/$id");
    var _payload = json.encode(object);
    var _headers = {
      'Content-Type': 'application/json',
    };

    var response = await client.delete(url, body: _payload, headers: _headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
    }
  }

  Future<List<Settings>?> getSettings() async
  {
    var client = http.Client();

    var uri = Uri.parse("https://localhost:7019/api/Settings");
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      return settingsFromJson(json);
    }
  }

  Future<dynamic> createSettings(dynamic object) async {
    print("running createSettings");
    var client = http.Client();
    print("got createSettings client");
    var url = Uri.parse("https://localhost:7019/api/Settings");
    print("got createSettings url");
    var _payload = json.encode(object);
    print("got createSettings payload:");
    print("payload:");
    print(_payload);
    var _headers = {
      'Content-Type': 'application/json',
    };
    print("got createSettings headers");

    var response = await client.post(url, body: _payload, headers: _headers);
    print("got createSettings response:");
    print(response.body);

    if (response.statusCode == 201) {
      return response.body;
    } else {
print("createsettings error");
    }
  }

  Future<dynamic> editSettings(int id, dynamic object) async {
    var client = http.Client();
    var url = Uri.parse("https://localhost:7019/api/Settings/$id");
    var _payload = json.encode(object);
    var _headers = {
      'Content-Type': 'application/json',
    };

    var response = await client.put(url, body: _payload, headers: _headers);
    if (response.statusCode == 200) {

      return response.body;
    } else {
    }
  }

  String getToken() {
    return decodedToken;
  }

  String getUserId() {
    return loggedInUserId;
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
      print("got to line 133");
      //loggedInUserId = json.decode(response.body)['id'];
      //print(loggedInUserId);

      //loginList = [decodedToken];

      print(decodedToken);

      return decodedToken;
    } else {
      throw Future.error("invalid user");
    }
  }

  Future<dynamic> loginUser(dynamic object) async {
    print("starting loginUser line 122");
    //List<dynamic> loginList = [];
    var client = http.Client();
    var url = Uri.parse("https://localhost:7019/api/authManagement/Login");
    var _payload = json.encode(object);
    print("loginUser line 127");
    var _headers = {
      'Content-Type': 'application/json',
    };
  print("payload: " + _payload);

    var response = await client.post(url, body: _payload, headers: _headers);
    print("response: " + response.body);

    if (response.statusCode == 200) {

      decodedToken = json.decode(response.body)['token'];
      print("got to line 139");
      //loggedInUserId = json.decode(response.body)['id'];
      //print(loggedInUserId);

      //loginList = [decodedToken];

      print(decodedToken);

      return decodedToken;

    } else {
      throw Future.error("invalid user");
    }


  }


}