import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:office_administrator_app/constants/colors.dart';
import 'package:office_administrator_app/screens/user/user_main_screen.dart';
import 'package:office_administrator_app/screens/user/userl%20tiles/todo/todo.dart';
import 'package:office_administrator_app/screens/user/userl%20tiles/todo/todo_item.dart';

class UserToDo extends StatefulWidget {
  const UserToDo({super.key});

  @override
  State<UserToDo> createState() => _UserToDoState();
}

class _UserToDoState extends State<UserToDo> {

  final todosList = ToDo.todoList();
  final _todoController = TextEditingController();
  List <ToDo> _foundTodo = [];

  @override
  void initState() {
    _foundTodo = todosList;
    super.initState();
  }

  void _handleTodoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteTodoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });
  }

  void _addTodoItem(String todo) {
    setState(() {
      if (todo.isNotEmpty) {
        todosList.add(ToDo(id: DateTime.now().millisecondsSinceEpoch.toString(),
     todoText: todo));
      }
    });

    _todoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        appBar: AppBar(
          title: Text('To Do list',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          elevation: 5,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
              builder: (context) => UserMainScreen(index: 0,)));
            },
          ),
        ),
        body: Stack(
        children: [
          Container(padding: EdgeInsets.symmetric(horizontal: 20,
            vertical: 15),
            child: Column(children: [
              Expanded(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView(children: [
                  for (ToDo todo in _foundTodo.reversed)
                  ToDoItem(todo: todo,
                  onTodoChanged: _handleTodoChange,
                  onDeleteItem: _deleteTodoItem,
                  )
                ],),
              ),)
            ],),),
            Align(alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(child: Container(
                margin: EdgeInsets.only(bottom: 20, right: 20,
                left: 20),padding: EdgeInsets.symmetric(horizontal: 20,
                vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [BoxShadow(color: Colors.grey,
                  offset: Offset(0.0, 0.0),
                  blurRadius: 10.0, spreadRadius: 0.0),],
                  borderRadius: BorderRadius.circular(10),
                ),child: TextField(controller: _todoController,
                  decoration: InputDecoration(
                    hintText: 'Add a new todo',
                    border: InputBorder.none
                  ),
                ),
              )),
              Container(
                margin: EdgeInsets.only(bottom: 20,
                right: 20),child: ElevatedButton(onPressed: () {
                  _addTodoItem(_todoController.text);
                }, 
                child: Text('+', style: TextStyle(fontSize: 40, 
                color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  minimumSize: Size(60, 60),
                  elevation: 10,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                ),),
              )
            ],),)
        ],
              ),
        ),
    );
  }
}