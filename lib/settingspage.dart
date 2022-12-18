import 'package:flutter/material.dart';
import 'package:to_do_app/todaystodospage.dart';
import 'mainmenupage.dart';
import 'remote_service.dart';
import 'settingsjson.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<Settings>? settings;
  List<Settings> listedSettings = [];
  bool isLoaded = false;
  int enteredNumTodos = 1;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    settings = await RemoteService().getSettings();
    if (settings != null) {
      setState(() {
        isLoaded = true;
      });
      listedSettings = settings!.where((element) => element.userId == widget.userId).toList();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    enteredNumTodos = listedSettings?[0].numToDos;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                "Page to change settings",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Viking', fontSize: 29, color: Colors.brown[700]),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                width: 300.0,
                height: 75.0,
                color: Colors.cyan,
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("Number of todos shown:"), SizedBox(height: 40, width: 40, child:
                    TextFormField(decoration:
                    InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                    ),
                        onChanged: (text) {
                          enteredNumTodos = int.parse(text);
                        },
                        initialValue: enteredNumTodos.toString())
                    )
                    ]
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.red,
                textStyle: const TextStyle(fontSize: 15),
              ),
              onPressed: () async{
print(enteredNumTodos);

               Settings? updatedSettings = Settings(settingsId: listedSettings?[0].settingsId, numToDos: enteredNumTodos, userId: widget.userId
                );
                var response = await RemoteService().editSettings(listedSettings?[0].settingsId, updatedSettings).catchError((err) {});
                if (response == null) return;

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TodaysTodos(userId: widget.userId, maxLength: enteredNumTodos),
                    ));
              },
              child: const Text('Create'),
            ),

            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                primary: Colors.black,
                textStyle: const TextStyle(fontSize: 15),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      //The 0s are values for turnCounter and rightCounter, to reset them when new game starts:
                      builder: (context) => MainMenu(userId: widget.userId,),
                    ));
              },
              child: const Text('Back to main menu'),
            ),

          ],
        ),

      ),
    );
  }
}