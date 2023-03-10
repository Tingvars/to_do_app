import 'package:flutter/material.dart';
import 'showtodospage.dart';
import 'addnewtodopage.dart';
import 'settingspage.dart';
import 'jsonComponents/remoteservice.dart';
import 'jsonComponents/settingsjson.dart';
import 'loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'Components/navButton.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key, required this.token}) : super(key: key);

  final String token;

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  List<Settings>? settings;
  List<Settings> listedSettings = [];
  bool isLoaded = false;
  int maxLength = 0;
  String token = "";
  String userId = "";
  String language = "";
  String toToDosButtonString = "";
  String addNewToDoButtonString = "";
  String settingsButtonString = "";
  String logOutButtonString = "";

  Color color1 = Color(0XFF89143B); //dark red
  Color color2 = Color(0XFFFEF3F7); //pale red
  Color color3 = Color(0XFF6A266F); //Pale purple
  Color color4 = Color(0XFFF8F5F8); //dark purple
  Color color5 = Color(0XFFFFE7DF); //pale orange/brown
  Color color6 = Color(0XFFB6360A); //dark orange/brown

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("jwtString")!;
//Getting userId from jwt token in localstorage:
    List<String> parts = token.split('.');
    String payload = parts[1];
    switch (payload.length % 4) {
      case 0:
        break;
      case 2:
        payload += '==';
        break;
      case 3:
        payload += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }
    String jsonId = utf8.decode(base64Url.decode(payload));
    Map<String, dynamic> claims = jsonDecode(jsonId);

    userId = claims['Id'];

    settings = await RemoteService().getSettings(token);
    if (settings != null) {
      setState(() {
        isLoaded = true;
      });
      listedSettings =
          settings!.where((element) => element.userId == userId).toList();
      maxLength = listedSettings[0].numToDos;
      language = listedSettings[0].language;
      setLanguage();
    } else {}
  }

  logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("jwtString");

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  navigateToPage(Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }

  setLanguage() {
    if (language == "is") {
      toToDosButtonString = "G??tlisti";
      addNewToDoButtonString = "B??ta vi??";
      settingsButtonString = "Stillingar";
      logOutButtonString = "??tskr??ning";
    } else {
      toToDosButtonString = "To do list";
      addNewToDoButtonString = "Add new todo";
      settingsButtonString = "Settings";
      logOutButtonString = "Log out";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment(0.5, -0.5),
              colors: [
                color1,
                color2,
              ],
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 170.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: color3,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                          height: 150,
                          width: 150,
                          child: Center(
                            child: Text(
                              "UP Next",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Viking',
                                  fontSize: 29,
                                  color: color4),
                            ),
                          ),
                        ),
                      ),
                      navButton(
                          buttonString: toToDosButtonString,
                          function: (ShowTodos(
                              userId: userId,
                              maxLength: maxLength,
                              token: token))),
                      navButton(
                          buttonString: addNewToDoButtonString,
                          function:
                              AddNewTodoPage(userId: userId, token: token)),
                      navButton(
                          buttonString: settingsButtonString,
                          function: SettingsPage(userId: userId, token: token)),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, right: 20.0),
                  child: TextButton(
                      onPressed: () {
                        logOut();
                      },
                      child: Text(
                        logOutButtonString,
                        style: TextStyle(
                            fontFamily: 'Viking', fontSize: 17, color: color3),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
