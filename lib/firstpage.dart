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
  bool isRegisterError = false;
  bool isLoginError = false;

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
                style: TextStyle(fontFamily: 'Viking',
                    fontSize: 29,
                    color: Colors.brown[700]),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                primary: Colors.black,
                textStyle: const TextStyle(fontSize: 15),
              ),
              onPressed: () async {
            isRegisterError = false;
                return await registerShowDialog(context);
              },
              child: const Text('Register'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                primary: Colors.black,
                textStyle: const TextStyle(fontSize: 15),
              ),
              onPressed: () async {
                isLoginError = false;
                return await loginShowDialog(context);
              },
              child: const Text('Login'),
            )

          ],
        ),

      ),
    );
  }

  loginShowDialog(BuildContext context) async {
    showDialog<void>(
                context: context,

                builder: (BuildContext context) {
                  return AlertDialog(

                    title: const Text('Login'),
                    content: SingleChildScrollView(
                      child: Container(
                        width: 300.0,
                        color: Colors.deepPurpleAccent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(children: [
                              Text("Email:"),
                              SizedBox(height: 35, width: 200, child:
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
                            Column(children: [
                              Text("Password:"),
                              SizedBox(height: 35, width: 200, child:
                              TextFormField(decoration:
                              InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                              ),
                                  onChanged: (passwordtext) {
                                    enteredPassword = passwordtext;
                                  },
                                  initialValue: "")
                              ),
                              errorLoginDialog("Email or password incorrect - please try again"),
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
                          User newUser = User(username: "",
                              email: enteredEmail,
                              password: enteredPassword
                          );
                          //"response" below is the jwt token as a string:
                          var response = await RemoteService().loginUser(
                              newUser).catchError((err) {
                              isLoginError = true;
                              Navigator.of(context).pop();
                              loginShowDialog(context);
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
                            String jsonId = utf8.decode(
                                base64Url.decode(payload));
                            Map<String, dynamic> claims =
                            jsonDecode(jsonId);
                            //The following, userId, is the all-important userid. Need to pass it to all screens.
                            String userId = claims['Id'];

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MainMenu(userId: userId, token: response),
                                ));
                          };
                        },
                      ),
                    ],
                  );
                },
              );
  }

  registerShowDialog(BuildContext context) async {
    showDialog (
                context: context,

                builder: (context) {
                  return AlertDialog(

                    title: const Text("Registration"),
                    content: SingleChildScrollView(
                      child: Container(
                        width: 300.0,
                        color: Colors.deepPurpleAccent,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                        Column(children: [Text("Username:"),
                        SizedBox(height: 35, width: 200, child:
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
                      Column(children: [
                        Text("Email:"),Text("-must be a valid email address", style: TextStyle(fontSize: 11)),
                        SizedBox(height: 35, width: 200, child:
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
                      Column(children: [Text("Password:"),Text("-at least 6 characters", style: TextStyle(fontSize: 11)),Text("-must include one lowercase character", style: TextStyle(fontSize: 11)),Text("-must include one uppercase character", style: TextStyle(fontSize: 11)),Text("-must include one number", style: TextStyle(fontSize: 11)),Text("-must include one symbol", style: TextStyle(fontSize: 11)),
                      SizedBox(height: 35, width: 200, child:
                      TextFormField(decoration:
                      InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                      ),
                          onChanged: (passwordtext) {
                            enteredPassword = passwordtext;
                          },
                          initialValue: "")
                      ),

                        errorRegisterDialog("Registration failed. Please check requirements and try again"),
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
                  User newUser = User(username: enteredUsername, email: enteredEmail, password: enteredPassword
                  );
                  var response = await RemoteService().registerUser(newUser).catchError((err) {
                  if (err == "invalid user") {
                  isRegisterError = true;
                  Navigator.of(context).pop();
                  registerShowDialog(context);
                  }
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
                  var response1 = await RemoteService().createSettings(newSettings).catchError((err) {
                  return;
                  });
                  if (response1 != null) {

                  Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => FirstPage(),
                  ));};
                  };
                  },
                  )
                  ,
                  ]
                  ,
                  );
                },
              );
  }

  Padding errorRegisterDialog(String errorText) {
    if (isRegisterError) {
      return Padding(
        padding: const EdgeInsets.only(
            bottom: 10.0, top: 8.0),
        child: SizedBox(
          width: 200.0,
          height: 25.0,
          child: DecoratedBox(
            child: Text(
                errorText, style: TextStyle(fontSize: 11)),
            decoration: const BoxDecoration(
              color: Colors.red,
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(
            bottom: 10.0, top: 8.0),

      );
    }
  }

  Padding errorLoginDialog(String errorText) {
    if (isLoginError) {
      return Padding(
        padding: const EdgeInsets.only(
            bottom: 10.0, top: 8.0),
        child: SizedBox(
          width: 200.0,
          height: 25.0,
          child: DecoratedBox(
            child: Text(
                errorText, style: TextStyle(fontSize: 11)),
            decoration: const BoxDecoration(
              color: Colors.red,
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(
            bottom: 10.0, top: 8.0),

      );
    }
  }

}