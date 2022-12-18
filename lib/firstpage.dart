import "package:flutter/material.dart";
import 'firstpage.dart';
import 'mainmenupage.dart';
import 'authorizationjson.dart';
import 'settingsjson.dart';
import 'remote_service.dart';
import 'dart:convert';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  String enteredUsername = "";
  String enteredPassword = "";
  String enteredEmail = "";
  String decodedToken = "";

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                "TODOS APP 1",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Viking', fontSize: 29, color: Colors.brown[700]),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                primary: Colors.black,
                textStyle: const TextStyle(fontSize: 15),
              ),
              onPressed: () async {

    return showDialog<void>(

    context: context,

    builder: (BuildContext context) {

    return AlertDialog(

    title: const Text('AlertDialog Title'),
        content: SingleChildScrollView(
        child: Container(
        width: 300.0,
      color: Colors.deepPurpleAccent,
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(children: [Text("Username:"), SizedBox(height: 35, width: 200, child:
        TextFormField(decoration:
        InputDecoration(
          filled: true,
          fillColor: Colors.white,
        ),
            onChanged: (usernametext) {
              enteredUsername = usernametext;
            },
            initialValue: "")
        )
        ],
        ),
        Column(children: [Text("Email:"), SizedBox(height: 35, width: 200, child:
        TextFormField(decoration:
        InputDecoration(
          filled: true,
          fillColor: Colors.white,
        ),
            onChanged: (emailtext) {
              enteredEmail = emailtext;
            },
            initialValue: "")
        )
        ],
        ),
        Column(children: [Text("Password:"), SizedBox(height: 35, width: 200, child:
        TextFormField(decoration:
        InputDecoration(
          filled: true,
          fillColor: Colors.white,
        ),
            onChanged: (passwordtext) {
              enteredPassword = passwordtext;
            },
            initialValue: "")
        )
        ],
        ),
        ],
      ),

        ),
        ),
      actions: <Widget>[
        TextButton(

          child: const Text('Close (and register)'),
          onPressed: () async {
            print("line 111 " + enteredUsername + " " + enteredEmail + " " + enteredPassword);
              User newUser = User(username: enteredUsername, email: enteredEmail, password: enteredPassword
              );
              print("new user created 114:");
              print(newUser);
              var response = await RemoteService().registerUser(newUser).catchError((err) {
                print("hitting registration error");
                return;
              });

            if (response != null) {

              List<String> parts = response.split('.');
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
              Map<String, dynamic> claims =
              jsonDecode(jsonId);
              //The following, userId, is the all-important userid. Need to pass it to all screens.
              String userId = claims['Id'];

    Settings newSettings = Settings(userId: userId, numToDos: 5,
    );
    print("mest line is newSettings:");
    print(newSettings);
    var response1 = await RemoteService().createSettings(newSettings).catchError((err) {
    print("hitting error getting response");
    return;
    });
    if (response1 != null) {
print("created new settings:");
print(response1);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FirstPage(),
                  ));};
            };
          },
        ),
      ],
    );
    },
    );
              },
              child: const Text('Register'),
            ),

            //test
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                primary: Colors.black,
                textStyle: const TextStyle(fontSize: 15),
              ),
              onPressed: () async {

                            return showDialog<void>(
                              context: context,

                              builder: (BuildContext context) {
                                return AlertDialog(

                                  title: const Text('AlertDialog Title'),
                                  content: SingleChildScrollView(
                                    child: Container(
                                      width: 300.0,
                                      color: Colors.deepPurpleAccent,
                                      child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Column(children: [Text("Username:"), SizedBox(height: 35, width: 200, child:
                                          TextFormField(decoration:
                                          InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                          ),
                                              onChanged: (usernametext) {
                                                enteredUsername = usernametext;
                                              },
                                              initialValue: "")
                                          )
                                          ],
                                          ),
                                          Column(children: [Text("Email:"), SizedBox(height: 35, width: 200, child:
                                          TextFormField(decoration:
                                          InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                          ),
                                              onChanged: (emailtext) {
                                                enteredEmail = emailtext;
                                              },
                                              initialValue: "")
                                          )
                                          ],
                                          ),
                                          Column(children: [Text("Password:"), SizedBox(height: 35, width: 200, child:
                                          TextFormField(decoration:
                                          InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                          ),
                                              onChanged: (passwordtext) {
                                                enteredPassword = passwordtext;
                                              },
                                              initialValue: "")
                                          )
                                          ],
                                          ),
                                        ],
                                      ),

                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Log in'),
                                      onPressed: () async {
                                        User newUser = User(username: enteredUsername, email: enteredEmail, password: enteredPassword
                                        );
                                        //"response" below is the jwt token as a string:
                                        var response = await RemoteService().loginUser(newUser).catchError((err) {
                                          print("hitting error getting response");
                                          return;
                                        });
                                        if (response != null) {

                                          List<String> parts = response.split('.');
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
                                          Map<String, dynamic> claims =
                                          jsonDecode(jsonId);
                                          //The following, userId, is the all-important userid. Need to pass it to all screens.
                                          String userId = claims['Id'];

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => MainMenu(userId: userId,),
                                              ));
                                        };

                                      },
                                    ),
                                  ],
                                );
                              },
                            );
              },
              child: const Text('Login'),
            )

          ],
        ),

      ),
    );
  }
}