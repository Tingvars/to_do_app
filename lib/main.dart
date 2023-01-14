import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'mainmenupage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("jwtString")!;
    runApp(
      MaterialApp(
        title: 'UpNext',
        theme: new ThemeData(scaffoldBackgroundColor: const Color(0xFFFCF788)),
        home: MainMenu(token: token),
      ),
    );
  } catch (error) {
    runApp(
      MaterialApp(
        title: 'UpNext',
        theme: new ThemeData(scaffoldBackgroundColor: const Color(0XFF6A266F)),
        home: LoginPage(),
      ),
    );
  }
}
