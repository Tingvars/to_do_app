import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'mainmenupage.dart';
import 'jsonComponents/todojson.dart';
import 'jsonComponents/remote_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Components/navButton.dart';

class AddNewTodoPage extends StatefulWidget {
  const AddNewTodoPage({Key? key, required this.userId, required this.token, required this.language})
      : super(key: key);

  final String userId;
  final String token;
  final String language;

  @override
  State<AddNewTodoPage> createState() => _AddNewTodoPageState();
}

class _AddNewTodoPageState extends State<AddNewTodoPage> {
  String enteredTodoTitle = "";
  int enteredTodoImportance = 2;
  String importanceLabel = "Medium";
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime dueDateTime = DateTime.now();
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
      importanceLabel = "Low";
    } else if (enteredTodoImportance == 2) {
      importanceLabel = "Medium";
    } else if (enteredTodoImportance == 3) {
      importanceLabel = "High";
    }
  }

  @override
  Widget build(BuildContext context) {
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
          )),
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
                  width: 450.0,
                  height: 450.0,
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
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: Column(
                                  children: [
                                    Text("Name of todo item:"),
                                    SizedBox(height: 15),
                                    SizedBox(
                                      height: 35,
                                      width: 250,
                                      child: TextFormField(
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                            ),
                                          ),
                                          onChanged: (text) {
                                            enteredTodoTitle = text;
                                          },
                                          initialValue: ""),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      child: Container(
                                        width: 140,
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(90))),
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                          Text("Select date",
                                            style: TextStyle(
                                              fontFamily: 'Viking',
                                              fontSize: 15,
                                              color: Colors.black,
                                            ),),
                                        ]),
                                      ),
                                      onPressed: () {
                                        _selectDate();
                                      },
                                    ),
                                    TextButton(
                                      child: Container(
                                        width: 140,
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(90))),
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("Select time",
                                                style: TextStyle(
                                                  fontFamily: 'Viking',
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                ),),
                                            ]),
                                      ),
                                        onPressed: () {
                                          _selectTime();
                                        },
                                        //child: Text("Select time"),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: Column(
                                  children: [
                                    Text("Importance:"),
                                    SizedBox(
                                        height: 35,
                                        width: 200,
                                        child: Slider(
                                          value:
                                              enteredTodoImportance.toDouble(),
                                          min: 1,
                                          max: 3,
                                          divisions: 2,
                                          label: importanceLabel,
                                          onChanged: (double value) {
                                            setState(() {
                                              enteredTodoImportance =
                                                  value.toInt();
                                              editImportanceLabel();
                                            });
                                          },
                                        ))
                                  ],
                                ),
                              ),
                              TextButton(
                                child: Container(
                                  width: 175,
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
                                      borderRadius: BorderRadius.all(Radius.circular(90))
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text("Create",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Viking',
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),),
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
                                            userId: widget.userId,
                                            token: token,
                                        language: widget.language),
                                      ));
                                },
                                //child: const Text('Create'),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
              navButton(
                  buttonString: "Back to main menu",
                  function: MainMenu(token: token, language: widget.language)),
            ],
          ),
        ),
      ),
    );
  }
}
