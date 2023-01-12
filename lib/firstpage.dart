import "package:flutter/material.dart";
import 'mainmenupage.dart';
import 'jsonComponents/authorizationjson.dart';
import 'jsonComponents/settingsjson.dart';
import 'jsonComponents/remote_service.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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

  Color color1 = Color(0XFF89143B); //dark red
  Color color2 = Color(0XFFFEF3F7); //pale red
  Color color3 = Color(0XFF6A266F); //Pale purple
  Color color4 = Color(0XFFF8F5F8); //dark purple
  Color color5 = Color(0XFFFFE7DF); //pale orange/brown
  Color color6 = Color(0XFFB6360A); //dark orange/brown

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: Container(
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

      child: Center(
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

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: color3),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment(-0.1, -0.1),
                        colors: [
                          color3,
                          color4,
                        ],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(90))
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: const Text('Register',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Viking',
                        fontSize: 15,
                      color: Colors.black,
                  ),
                ),
                ),
                onPressed: () async {
                  isRegisterError = false;
                  return await registerShowDialog(context);
                },
              ),
            ),
            TextButton(
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                    border: Border.all(color: color3),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment(-0.1, -0.1),
                      colors: [
                        color3,
                        color4,
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(90))
                ),
                padding: const EdgeInsets.all(16.0),
                child: const Text('Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Viking',
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
              onPressed: () async {
                isLoginError = false;
                return await loginShowDialog(context);
              },
            ),
              ],
        ),
      ),
    )
      )
    );
  }

  loginShowDialog(BuildContext context) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            contentPadding: EdgeInsets.all(0),
          content: SingleChildScrollView(
            child: Container(
              width: 350,
              height: 400,
              decoration: BoxDecoration(
                  border: Border.all(color: color3),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment(-0.1, -0.1),
                    colors: [
                      color1,
                      color2,
                    ],
                  ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children:[
                      Container(
                        child: Text('Login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Viking',
                            fontSize: 30,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ]
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text("Email:"),
                      SizedBox(
                          height: 35,
                          width: 200,
                          child: TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                              onChanged: (emailtext) {
                                enteredEmail = emailtext;
                              },
                              initialValue: ""))
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text("Password:"),
                      SizedBox(
                          height: 35,
                          width: 200,
                          child: TextFormField(
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                              onChanged: (passwordtext) {
                                enteredPassword = passwordtext;
                              },
                              initialValue: "")),
                      errorLoginDialog(
                          "Email or password incorrect - please try again"),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                  TextButton(
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                          border: Border.all(color: color3),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment(-0.1, -0.1),
                            colors: [
                              color3,
                              color4,
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(90))
                      ),
                      padding: const EdgeInsets.all(16.0),
                    child: const Text('Log in',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Viking',
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    ),
                    onPressed: () async {
                      User newUser = User(
                          username: "",
                          email: enteredEmail,
                          password: enteredPassword);
                      //"response" below is the jwt token as a string:
                      var response =
                      await RemoteService().loginUser(newUser).catchError((err) {
                        isLoginError = true;
                        Navigator.of(context).pop();
                        loginShowDialog(context);
                        return;
                      });
                      if (response != null) {
                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                        prefs.setString("jwtString", response);
                        final token = prefs.getString("jwtString")!;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainMenu(token: token, language: "en"),
                            ));
                      }
                      ;
                    },

                  ),
                ],
              ),
            ),
          ),

        );
      },
    );
  }

  registerShowDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          content: SingleChildScrollView(
            child: Container(
              width: 350,
              height: 450,
              decoration: BoxDecoration(
                border: Border.all(color: color3),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment(-0.1, -0.1),
                  colors: [
                    color1,
                    color2,
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                      children:[
                        Container(
                          child: Text('Register',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Viking',
                              fontSize: 30,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ]
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text("Username:"),
                      SizedBox(
                          height: 35,
                          width: 200,
                          child: TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                              onChanged: (usernametext) {
                                enteredUsername = usernametext;
                              },
                              initialValue: ""))
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text("Email:"),
                      Text("-must be a valid email address",
                          style: TextStyle(fontSize: 11)),
                      SizedBox(
                          height: 35,
                          width: 200,
                          child: TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                              onChanged: (emailtext) {
                                enteredEmail = emailtext;
                              },
                              initialValue: ""))
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text("Password:"),
                      Text("-at least 6 characters",
                          style: TextStyle(fontSize: 11)),
                      Text("-must include one lowercase character",
                          style: TextStyle(fontSize: 11)),
                      Text("-must include one uppercase character",
                          style: TextStyle(fontSize: 11)),
                      Text("-must include one number",
                          style: TextStyle(fontSize: 11)),
                      Text("-must include one symbol",
                          style: TextStyle(fontSize: 11)),
                      SizedBox(
                          height: 35,
                          width: 200,
                          child: TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                              onChanged: (passwordtext) {
                                enteredPassword = passwordtext;
                              },
                              initialValue: "")),
                      errorRegisterDialog(
                          "Registration failed. Please check requirements and try again"),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                  TextButton(
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                          border: Border.all(color: color3),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment(-0.1, -0.1),
                            colors: [
                              color3,
                              color4,
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(90))
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: const Text('Register',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Viking',
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      User newUser = User(
                          username: enteredUsername,
                          email: enteredEmail,
                          password: enteredPassword);
                      var response = await RemoteService()
                          .registerUser(newUser)
                          .catchError((err) {
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
                            throw Exception('Illegal base64url string"');
                        }
                        String jsonId = utf8.decode(base64Url.decode(payload));
                        Map<String, dynamic> claims = jsonDecode(jsonId);
                        //The following, userId, is the all-important userid. Need to pass it to all screens.
                        String userId = claims['Id'];

                        Settings newSettings = Settings(
                          userId: userId,
                          numToDos: 5,
                          language: "en"
                        );
                        var response1 = await RemoteService()
                            .createSettings(newSettings)
                            .catchError((err) {
                          return;
                        });
                        if (response1 != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FirstPage(),
                              ));
                        };
                      };
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Padding errorRegisterDialog(String errorText) {
    if (isRegisterError) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0, top: 8.0),
        child: SizedBox(
          width: 200.0,
          height: 25.0,
          child: DecoratedBox(
            child: Text(errorText, style: TextStyle(fontSize: 11)),
            decoration: const BoxDecoration(
              color: Colors.red,
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0, top: 8.0),
      );
    }
  }

  Padding errorLoginDialog(String errorText) {
    if (isLoginError) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0, top: 8.0),
        child: SizedBox(
          width: 200.0,
          height: 25.0,
          child: DecoratedBox(
            child: Text(errorText, style: TextStyle(fontSize: 11)),
            decoration: const BoxDecoration(
              color: Colors.red,
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0, top: 8.0),
      );
    }
  }
}






