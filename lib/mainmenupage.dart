import 'package:flutter/material.dart';
import 'todaystodospage.dart';
import 'addnewtodopage.dart';
import 'settingspage.dart';
import 'remote_service.dart';
import 'settingsjson.dart';
import 'firstpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'Components/navButton.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key, required this.token})
      : super(key: key);

  //final String userId;
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
    //The following, userId, is the all-important userid. Need to pass it to all screens.
    userId = claims['Id'];

    settings = await RemoteService().getSettings(token);
    if (settings != null) {
      setState(() {
        isLoaded = true;
      });
      listedSettings = settings!
          .where((element) => element.userId == userId)
          .toList();
      maxLength = listedSettings[0].numToDos;
    } else {}
  }

  logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("jwtString");

    Navigator.push(context, MaterialPageRoute(builder: (context) => FirstPage()));
  }

  navigateToPage(Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
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
              )
          ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                decoration: BoxDecoration(
                    color: color3,
                    borderRadius: BorderRadius.all(Radius.circular(100))
                ),
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
                buttonString: "To do today", function:
                (TodaysTodos(
                    userId: userId,
                    maxLength: maxLength,
                    token: token)
                )
            ),
            navButton(buttonString: "Add new todo", function:
                AddNewTodoPage(userId: userId, token: token)),
            navButton(buttonString: "Settings", function:
                SettingsPage(userId: userId, token: token)),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                width: 200,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    backgroundColor: Colors.orange,
                    primary: Colors.black,
                    textStyle: const TextStyle(fontSize: 15),
                  ),
                  onPressed: () {
                    logOut();
                  },
                  child: Text("Log out"),
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

}
