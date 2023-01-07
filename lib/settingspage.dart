import 'package:flutter/material.dart';
import 'package:to_do_app/todaystodospage.dart';
import 'mainmenupage.dart';
import 'jsonComponents/remote_service.dart';
import 'jsonComponents/settingsjson.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Components/navButton.dart';
import 'Components/counterButton.dart';
import 'firstpage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required this.userId, required this.token})
      : super(key: key);

  final String userId;
  final String token;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<Settings>? settings;
  List<Settings> listedSettings = [];
  bool isLoaded = false;
  bool initialPageLoad = true;
  int enteredNumTodos = 1;
  String token = "";

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
    settings = await RemoteService().getSettings(token);
    if (settings != null) {
      setState(() {
        isLoaded = true;
      });
      listedSettings = settings!
          .where((element) => element.userId == widget.userId)
          .toList();
    } else {}
  }



  @override
  Widget build(BuildContext context) {
    if (initialPageLoad) {
      enteredNumTodos = listedSettings?[0].numToDos;
    }

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
            //Title:
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                "Settings",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Viking',
                    fontSize: 29,
                    color: Colors.brown[700]),
              ),
            ),
            //Number of todos:
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                width: 350.0,
                height: 150.0,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment(0.5, -0.5),
                      colors: [
                        color3,
                        color4,
                      ],
                    ),
                    border: Border.all(color: color3),
                    borderRadius: BorderRadius.all(Radius.circular(90)),
                ),
                //color: Colors.cyan,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Number of todos shown: "),
                      SizedBox(
                          height: 50,
                          width: 115,
                          child: CounterButton(
                            loading: false,
                            onChange: (int val) {
                              setState( () {
                                enteredNumTodos = val;
                                initialPageLoad = false;
                              }
                              );
                            },
                            count: enteredNumTodos,
                            countColor: Colors.purple,
                            buttonColor: color3,
                            progressColor: Colors.purpleAccent,
                           // border: Border.all(width: 0.5),
                          //  borderRadius: BorderRadius.circular(4.0),
                          ),
                      )
                    ]
                ),
              ),
            ),
            //Update button:
            TextButton(
              child: Container(
                width: 140,
                decoration: BoxDecoration(
                    border: Border.all(color: color3),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment(-0.1, -0.1),
                      colors: [
                        color6,
                        color5,
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(90))
                ),
                padding: const EdgeInsets.all(16.0),
                child: Text("Update settings",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Viking',
                    fontSize: 15,
                    color: Colors.black,
                  ),),
              ),
              onPressed: () async {
                Settings? updatedSettings = Settings(
                    settingsId: listedSettings?[0].settingsId,
                    numToDos: enteredNumTodos,
                    userId: widget.userId);
                var response = await RemoteService()
                    .editSettings(
                        listedSettings?[0].settingsId, updatedSettings, token)
                    .catchError((err) {});
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TodaysTodos(
                          userId: widget.userId,
                          maxLength: enteredNumTodos,
                          token: token),
                    ));
              },
            ),
            Column(
              children: [
                SizedBox(
                  height: 10,
                )
              ],
            ),

            navButton(buttonString: "Back to main menu", function: MainMenu(token: token)),
          ],
        ),
        ),
      ),
    );
  }
}
