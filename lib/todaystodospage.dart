import 'package:flutter/material.dart';
import 'mainmenupage.dart';
import 'addnewtodopage.dart';
import 'jsonComponents/todojson.dart';
import 'jsonComponents/remote_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Components/navButton.dart';
import 'Components/editingTodoItem.dart';

class TodaysTodos extends StatefulWidget {
  const TodaysTodos(
      {Key? key,
      required this.userId,
      required this.maxLength,
      required this.token,
      required this.language})
      : super(key: key);

  final String userId;
  final int maxLength;
  final String token;
  final String language;

  @override
  State<TodaysTodos> createState() => _TodaysTodosState();
}

class _TodaysTodosState extends State<TodaysTodos> {
  List<Todo>? todos;
  List<Todo> listedTodos = [];
  bool isLoadedToDo = false;
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
    getToDoData();
  }

  getToDoData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("jwtString")!;
    todos = await RemoteService().getTodos(token);
    if (todos != null) {
      setState(() {
        isLoadedToDo = true;
      });
      //listing things, by userid:
      listedTodos =
          todos!.where((element) => element.userId == widget.userId).toList();
      //sort things here by importance etc.:
      listedTodos.sort((a, b) => a.dueBy.compareTo(b.dueBy));
      if (listedTodos.length > widget.maxLength) {
        listedTodos.removeRange(widget.maxLength, listedTodos.length);
      }
    } else {}
  }

  navigateToPage(Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }

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
            )
        ),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(children: [
            for (Todo todo in listedTodos)
              todoItem(todo, todo.title, todo.importance),
          ]),
          navButton(buttonString: "Add new todo",
              function: AddNewTodoPage(userId: widget.userId, token: token, language: widget.language)),
          navButton(buttonString: "Back to main menu", function: MainMenu(token: token, language: widget.language)),
        ],
      ),
        ),
    ),
    );
  }

  Padding todoItem(Todo todo, String titleString, int importance) {
    Color todoColor = Colors.green;

    if (importance == 3) {
      todoColor = Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Dismissible(
      key: Key(todo.toDoId.toString()),
      background: Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Edit"),
                  SizedBox( width: (MediaQuery.of(context).size.width)/2.5,
                  ),
                ]
          ),
          color: Colors.blue),
      secondaryBackground: Container(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox( width: (MediaQuery.of(context).size.width)/2.5,
              ),
          Text("Delete")
            ]
        ),
          color: Colors.red),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment(0.5, -0.5),
              colors: [
                todoColor,
                color4,
              ],
            )
        ),
        height: 130.0,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(titleString, textAlign: TextAlign.center, style: TextStyle(
                fontFamily: 'Viking',
                fontSize: 20,
                color: Colors.black),),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text("Due: " +
                todo.dueBy.substring(11, 16) +
                " " +
                todo.dueBy.substring(8, 10) +
                " " +
                todo.dueBy.substring(5, 7) +
                " " +
                todo.dueBy.substring(0, 4)),
          ),
        ]),
      ),

        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            Navigator.of(context).pop(true);
          } else {
            Navigator.of(context).pop(true);
          }
        },

        confirmDismiss: (direction) {
        if (direction == DismissDirection.startToEnd) {

          return showDialog(
            context: context,
            builder: (context) {
              return editingTodoItem(todo: todo, titleString: titleString, importance: importance, token: token, maxLength: widget.maxLength, language: widget.language);
            },
          );
        } else {
          return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Remove item?'),
                content: Text(
                    'Do you want to remove this item from your to-do list?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  deleteButton(Colors.red, "Yes, delete!", todo.toDoId)
                ],
              );
            },
          );
        }
        },
    ),
    );
  }

  TextButton deleteButton(Color bgcolor, String buttonString, int id) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(16.0),
        backgroundColor: bgcolor,
        primary: Colors.black,
        textStyle: const TextStyle(fontSize: 15),
      ),
      onPressed: () async {
        Todo? newTodo = Todo(
            toDoId: id,
            title: "",
            importance: 0,
            dueBy: DateTime.now().toIso8601String(),
            userId: widget.userId);
        var response = await RemoteService()
            .deleteTodo(id, newTodo, token)
            .catchError((err) {});
        if (response == null) return;

        navigateToPage(TodaysTodos(
            userId: widget.userId, maxLength: widget.maxLength, token: token, language: widget.language));
      },
      child: Text(buttonString),
    );
  }
}
