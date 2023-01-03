import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'mainmenupage.dart';
import 'todojson.dart';
import 'remote_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNewTodoPage extends StatefulWidget {
  const AddNewTodoPage({Key? key, required this.userId, required this.token})
      : super(key: key);

  final String userId;
  final String token;

  @override
  State<AddNewTodoPage> createState() => _AddNewTodoPageState();
}

class _AddNewTodoPageState extends State<AddNewTodoPage> {
  String enteredTodoTitle = "";
  int enteredTodoImportance = 3;
  String importanceLabel = "Medium";
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime dueDateTime = DateTime.now();
  String token = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("jwtString")!;
  }

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
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
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
        selectedDate.microsecond);
  }

  editImportanceLabel() {
    if (enteredTodoImportance == 1) {
      importanceLabel = "Very low";
    } else if (enteredTodoImportance == 2) {
      importanceLabel = "Low";
    } else if (enteredTodoImportance == 3) {
      importanceLabel = "Medium";
    } else if (enteredTodoImportance == 4) {
      importanceLabel = "High";
    } else if (enteredTodoImportance == 5) {
      importanceLabel = "Very High";
    }
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
                style: TextStyle(
                    fontFamily: 'Viking',
                    fontSize: 29,
                    color: Colors.brown[700]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                width: 300.0,
                color: Colors.deepPurpleAccent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text("Name of todo item:"),
                        SizedBox(
                            height: 35,
                            width: 200,
                            child: TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                onChanged: (text) {
                                  enteredTodoTitle = text;
                                },
                                initialValue: ""))
                      ],
                    ),
                    Column(
                      children: [
                        TextButton(
                            onPressed: () {
                              _selectDate();
                            },
                            child: Text("Select date")),
                        TextButton(
                            onPressed: () {
                              _selectTime();
                            },
                            child: Text("Select time")),
                      ],
                    ),
                    Column(
                      children: [
                        Text("Importance:"),
                        SizedBox(
                            height: 35,
                            width: 200,
                            child: Slider(
                              value: enteredTodoImportance.toDouble(),
                              min: 1,
                              max: 5,
                              divisions: 4,
                              label: importanceLabel,
                              onChanged: (double value) {
                                setState(() {
                                  enteredTodoImportance = value.toInt();
                                  editImportanceLabel();
                                }
                                );
                              },
                            )
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
                      onPressed: () async {
                        dueDateTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                            selectedDate.second,
                            selectedDate.millisecond,
                            selectedDate.microsecond);

                        Todo newTodo = Todo(
                            title: enteredTodoTitle,
                            importance: enteredTodoImportance,
                            dueBy: dueDateTime.toIso8601String(),
                            userId: widget.userId);
                        var response = await RemoteService()
                            .createTodo(newTodo, token)
                            .catchError((err) {});
                        if (response == null) return;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddNewTodoPage(
                                  userId: widget.userId, token: token),
                            ));
                      },
                      child: const Text('Create'),
                    ),
                  ],
                ),
              ),
            ),
            navButton("Back to main menu",
                MainMenu(token: token)),
          ],
        ),
      ),
    );
  }

  Padding navButton(String buttonString, Widget widget) {
    return Padding(
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
            navigateToPage(widget);
          },
          child: Text(buttonString),
        ),
      ),
    );
  }
}
