import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'mainmenupage.dart';
import 'todojson.dart';
import 'remote_service.dart';

class AddNewTodoPage extends StatefulWidget {

  const AddNewTodoPage({Key? key, required this.userId, required this.token}) : super(key: key);

  final String userId;
  final String token;

  @override
  State<AddNewTodoPage> createState() => _AddNewTodoPageState();
}

class _AddNewTodoPageState extends State<AddNewTodoPage> {
  String enteredTodoTitle = "";
  int enteredTodoImportance = 0;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime dueDateTime = DateTime.now();

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  navigateToPage(Widget widget) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => widget
        ));
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  void createDueDateTime() {
    dueDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
        selectedDate.second,
        selectedDate.millisecond,
        selectedDate.microsecond
    );
  }


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
                "Page to add new todo",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Viking', fontSize: 29, color: Colors.brown[700]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                width: 300.0,
                color: Colors.deepPurpleAccent,
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     Column(children: [Text("Name of todo item:"), SizedBox(height: 35, width: 200, child:
                    TextFormField(decoration:
                    InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                    ),
                        onChanged: (text) {
                          enteredTodoTitle = text;
                        },
                        initialValue: "")
                    )
                    ],
                    ),
                      Column(children: [

                        TextButton(
                            onPressed: () {
                              _selectDate();
                            },
                            child: Text("Select date")
                        ),

                        TextButton(
                            onPressed: () {
                              _selectTime();
                            },
                            child: Text("Select time")
                        ),

                      ],
                      ),
                      Column(children: [Text("Importance:"), SizedBox(height: 35, width: 200, child:
                      TextFormField(decoration:
                      InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                      ),
                          keyboardType: TextInputType.number,
                          onChanged: (text) {
                            enteredTodoImportance = int.parse(text);
                          },
                          initialValue: "0")
                      )
                      ],
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.red,
                          textStyle: const TextStyle(fontSize: 15),
                        ),
                        onPressed: () async{
                          dueDateTime = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute,
                              selectedDate.second,
                              selectedDate.millisecond,
                              selectedDate.microsecond
                          );

                          Todo newTodo = Todo(title: enteredTodoTitle, importance: enteredTodoImportance, dueBy: dueDateTime.toIso8601String(), userId: widget.userId
                          );
                          var response = await RemoteService().createTodo(newTodo, widget.token).catchError((err) {});
                          if (response == null) return;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddNewTodoPage(userId: widget.userId, token: widget.token),
                              ));
                        },
                        child: const Text('Create'),
                      ),
                    ],

                ),
              ),
            ),
            navButton("Back to main menu", MainMenu(userId: widget.userId, token: widget.token)),
          ],
        ),

      ),
    );
  }

  Padding navButton(String buttonString, Widget widget ) {
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
            navigateToPage(widget);
          },
          child: Text(buttonString),
        ),),
    );
  }

}