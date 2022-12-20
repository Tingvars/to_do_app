import 'package:flutter/material.dart';
import 'todaystodospage.dart';
import 'addnewtodopage.dart';
import 'settingspage.dart';
import 'remote_service.dart';
import 'settingsjson.dart';

class MainMenu extends StatefulWidget {

  const MainMenu({Key? key, required this.userId, required this.token}) : super(key: key);

  final String userId;
  final String token;

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  List<Settings>? settings;
  List<Settings> listedSettings = [];
  bool isLoaded = false;
  int maxLength = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    settings = await RemoteService().getSettings(widget.token);
    if (settings != null) {
      setState(() {
        isLoaded = true;
      });
      listedSettings = settings!.where((element) => element.userId == widget.userId).toList();
      maxLength = listedSettings?[0].numToDos;
    } else {}
  }

  navigateToPage(Widget widget) {

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => widget
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            navButton("To do today", (TodaysTodos(userId: widget.userId, maxLength: maxLength, token: widget.token))),
            navButton("Add new todo", AddNewTodoPage(userId: widget.userId, token: widget.token)),
            //navButton("Add new ongoing", AddNewOngoingPage()),
            navButton("Settings", SettingsPage(userId: widget.userId, token: widget.token)),
          ],
        ),
      ),
    );
  }

  Padding navButton(String buttonString, Widget function ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child:
      SizedBox(
        width: 200,
        child:
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(16.0),
            backgroundColor: Colors.orange,
            primary: Colors.black,
            textStyle: const TextStyle(fontSize: 15),
          ),
          onPressed: () {
            navigateToPage(function);
          },
          child: Text(buttonString),
        ),),
    );
  }
}