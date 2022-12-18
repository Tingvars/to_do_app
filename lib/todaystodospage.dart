import 'package:flutter/material.dart';
import 'mainmenupage.dart';
import 'addnewtodopage.dart';
import 'todojson.dart';
import 'remote_service.dart';
import 'settingsjson.dart';

class TodaysTodos extends StatefulWidget {

  const TodaysTodos({Key? key, required this.userId, required this.maxLength}) : super(key: key);

  final String userId;
  final int maxLength;

  @override
  State<TodaysTodos> createState() => _TodaysTodosState();
}

class _TodaysTodosState extends State<TodaysTodos> {
  List<Todo>? todos;
  List<Todo> listedTodos = [];
  bool isLoadedToDo = false;

  @override
  void initState() {
    super.initState();
    print("settings maxlength: ");
    print(widget.maxLength);
    getToDoData();
  }

  getToDoData() async {
    todos = await RemoteService().getTodos();
    if (todos != null) {

      setState(() {
        isLoadedToDo = true;
      });
      print("maxlength within todo getter:");
      print(widget.maxLength);
      //listing things, by userid:
      listedTodos = todos!.where((element) => element.userId == widget.userId).toList();
      //sort things here by importance etc.:
      listedTodos.sort((a, b) => a.dueBy.compareTo(b.dueBy));
     if (listedTodos.length > widget.maxLength) {
      listedTodos.removeRange(widget.maxLength, listedTodos.length);
     }
    } else {}
  }

 navigateToPage(Widget widget) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => widget
        ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(children: [
            for (Todo todo in listedTodos) todoItem(todo, todo.title),
          ]),
          navButton("Add new todo", AddNewTodoPage(userId: widget.userId)),
          navButton("Back to main menu", MainMenu(userId: widget.userId,)),
        ],
      ),
    ));
  }

  Padding todoItem(Todo todo, String titleString) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        width: 200.0,
        height: 110.0,
        color: Colors.green,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child:
          Text(titleString),
          ),
      Padding(
          padding: const EdgeInsets.all(5.0),
          child:
          Text("Due: " + todo.dueBy.substring(11, 16) + " " + todo.dueBy.substring(8, 10) + " " + todo.dueBy.substring(5, 7) + " " + todo.dueBy.substring(0, 4)),
      ),
      Padding(
          padding: const EdgeInsets.all(5.0),
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              deleteButton(Colors.red, "Delete", todo.toDoId),
              editButton(Colors.blue, "Edit", todo),
            ],
          ),
      ),
        ]),
      ),
    );
  }

  TextButton editButton(Color bgcolor, String buttonString, Todo todo ) {
    String editedToDoTitle = todo.title;
    int editedToDoImportance = todo.importance;
    DateTime selectedDate = DateTime.parse(todo.dueBy);
    DateTime editedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(DateTime.parse(todo.dueBy));

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

    return TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                backgroundColor: bgcolor,
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
                              Column(children: [Text("Name of todo item:"), SizedBox(height: 35, width: 200, child:
                              TextFormField(decoration:
                              InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                              ),
                                  onChanged: (text) {
                                    editedToDoTitle = text;
                                  },
                                  initialValue: todo.title)
                              )
                              ],
                              ),
                              Column(children: [

                                TextButton(
                                    onPressed: () {
                                      selectDate();
                                    },
                                    child: Text("Select date")
                                ),

                                TextButton(
                                    onPressed: () {
                                      selectTime();
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
                                    editedToDoImportance = int.parse(text);
                                  },
                                  initialValue: todo.importance.toString())
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
                                  editedDate = DateTime(
                                      selectedDate.year,
                                      selectedDate.month,
                                      selectedDate.day,
                                      selectedTime.hour,
                                      selectedTime.minute,
                                      selectedDate.second,
                                      selectedDate.millisecond,
                                      selectedDate.microsecond
                                  );

                                  Todo? newTodo = Todo(toDoId: todo.toDoId, title: editedToDoTitle, importance: editedToDoImportance, dueBy: editedDate.toIso8601String(), userId: widget.userId
                                  );
                                  var response = await RemoteService().editTodo(todo.toDoId, newTodo).catchError((err) {});
                                  if (response == null) return;

                                  navigateToPage(TodaysTodos(userId: widget.userId, maxLength: widget.maxLength,));

                                  Navigator.of(context).pop();

                                },
                                child: const Text('Update'),
                              ),
                            ],

                          ),
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Back to todos'),
                          onPressed: () {

                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );

              },
              child: Text(buttonString),
            );
  }

  TextButton deleteButton(Color bgcolor, String buttonString, int id ) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(16.0),
        backgroundColor: bgcolor,
        primary: Colors.black,
        textStyle: const TextStyle(fontSize: 15),
      ),
      onPressed: () async {
        Todo? newTodo = Todo(toDoId: id, title: "", importance: 0, dueBy: DateTime.now().toIso8601String(), userId: widget.userId
        );
        var response = await RemoteService().deleteTodo(id, newTodo).catchError((err) {});
        if (response == null) return;

        navigateToPage(TodaysTodos(userId: widget.userId, maxLength: widget.maxLength,));
      },
      child: Text(buttonString),
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
