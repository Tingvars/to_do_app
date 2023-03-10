import "package:flutter/material.dart";
import '../jsonComponents/todojson.dart';
import 'package:to_do_app/showtodospage.dart';
import '../jsonComponents/remoteservice.dart';

class editingTodoItem extends StatefulWidget {
  const editingTodoItem({Key? key, required this.todo, required this.titleString, required this.importance, required this.token, required this.maxLength, required this.language}) : super(key: key);

  final Todo todo;
  final String titleString;
  final int importance;
  final String token;
  final int maxLength;
  final String language;

  @override
  State<editingTodoItem> createState() => _editingTodoItemState();
}

class _editingTodoItemState extends State<editingTodoItem> {
  Color color1 = Color(0XFF89143B); //dark red
  Color color2 = Color(0XFFFEF3F7); //pale red
  Color color3 = Color(0XFF6A266F); //Pale purple
  Color color4 = Color(0XFFF8F5F8); //dark purple
  Color color5 = Color(0XFFFFE7DF); //pale orange/brown
  Color color6 = Color(0XFFB6360A); //dark orange/brown
  Color todoColor = Colors.green;

  bool initialImportanceLoad = true;

  String lowImpString = "";
  String medImpString = "";
  String highImpString = "";
  String nameOfTodoString = "";
  String selectDateString = "";
  String selectTimeString = "";
  String importanceString = "";
  String updateButtonString = "";

  int editedToDoImportance = 1;

  @override
  Widget build(BuildContext context) {

    String importanceLabel = "";
    DateTime selectedDate = DateTime.parse(widget.todo.dueBy);
    DateTime editedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(DateTime.parse(widget.todo.dueBy));

    if (initialImportanceLoad) {
      editedToDoImportance = widget.todo.importance;
    }

    void selectDate() async {
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

    editImportanceLabel() {
      if (editedToDoImportance == 1) {
        importanceLabel = lowImpString;
      } else if (editedToDoImportance == 2) {
        importanceLabel = medImpString;
      } else if (editedToDoImportance == 3) {
        importanceLabel = highImpString;
      }
    }

    setLanguage()
    {
      if (widget.language == "is") {
        lowImpString = "L??gt";
        medImpString = "Mi??lungs";
        highImpString = "H??tt";
        nameOfTodoString = "L??sing:";
        selectDateString = "Velja dag";
        selectTimeString = "Velja t??ma";
        importanceString = "Mikilv??gi:";
        updateButtonString = "Uppf??ra";
      } else {
        lowImpString = "Low";
        medImpString = "Medium";
        highImpString = "High";
        nameOfTodoString = "Description:";
        selectDateString = "Choose date";
        selectTimeString = "Choose time";
        importanceString = "Importance:";
        updateButtonString = "Update";
      }
    }

    void selectTime() async {
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

    String editedToDoTitle = widget.todo.title;

    if (widget.importance == 3) {
      todoColor = color1;
    }

    setLanguage();

    editImportanceLabel();
                return AlertDialog(
                  contentPadding: EdgeInsets.all(0),
                  content: SingleChildScrollView(
                    child: Container(
                      width: 400,
                      height: 450,
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
                                  Text(nameOfTodoString),
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
                                        editedToDoTitle = text;
                                      },
                                      initialValue: widget.todo.title),
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
                                          Text(selectDateString,
                                            style: TextStyle(
                                              fontFamily: 'Viking',
                                              fontSize: 15,
                                              color: Colors.black,
                                            ),),
                                        ]),
                                  ),
                                  onPressed: () {
                                    selectDate();
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
                                          Text(selectTimeString,
                                            style: TextStyle(
                                              fontFamily: 'Viking',
                                              fontSize: 15,
                                              color: Colors.black,
                                            ),),
                                        ]),
                                  ),
                                  onPressed: () {
                                    selectTime();
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
                                Text(importanceString),
                                SizedBox(
                                    height: 35,
                                    width: 200,
                                    child: Slider(
                                      value: editedToDoImportance.toDouble(),
                                      min: 1,
                                      max: 3,
                                      divisions: 2,
                                      label: importanceLabel,
                                      onChanged: (double value) {

                                        setState( () {
                                          editedToDoImportance = value.toInt();

                                          initialImportanceLoad = false;
                                          editImportanceLabel();
                                        }
                                        );
                                      },
                                    )
                                )
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
                              child: Text(updateButtonString,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Viking',
                                  fontSize: 15,
                                  color: Colors.black,
                                ),),
                            ),
                            onPressed: () async {
                              editedDate = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  selectedTime.hour,
                                  selectedTime.minute,
                                  selectedDate.second,
                                  selectedDate.millisecond,
                                  selectedDate.microsecond);

                              Todo? newTodo = Todo(
                                  toDoId: widget.todo.toDoId,
                                  title: editedToDoTitle,
                                  importance: editedToDoImportance,
                                  dueBy: editedDate.toIso8601String(),
                                  userId: widget.todo.userId);
                              var response = await RemoteService()
                                  .editTodo(widget.todo.toDoId, newTodo, widget.token)
                                  .catchError((err) {});
                              if (response == null)
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ShowTodos(userId: widget.todo.userId, maxLength: widget.maxLength, token: widget.token),
                                    )
                                );

                              navigateToPage(ShowTodos(
                                  userId: widget.todo.userId,
                                  maxLength: widget.maxLength,
                                  token: widget.token)
                              );
                              Navigator.of(context).pop();
                            },

                          ),
                        ],
                      ),
                    ),
                          ],
                  ),
    ),
                  )
    );
  }
}
