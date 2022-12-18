import 'package:flutter/material.dart';
import 'firstpage.dart';
import 'mainmenupage.dart';

class AddNewOngoingPage extends StatefulWidget {
  const AddNewOngoingPage({Key? key}) : super(key: key);

  @override
  State<AddNewOngoingPage> createState() => _AddNewOngoingPageState();
}

class _AddNewOngoingPageState extends State<AddNewOngoingPage> {
  bool isChecked = false;

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
                "Page to add new ongoing",
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
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      //The 0s are values for turnCounter and rightCounter, to reset them when new game starts:
                      builder: (context) => MainMenu(userId: "",),
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