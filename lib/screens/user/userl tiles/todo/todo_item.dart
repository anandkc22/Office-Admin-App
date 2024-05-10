import 'package:flutter/material.dart';
import 'package:office_administrator_app/constants/colors.dart';
import 'package:office_administrator_app/screens/user/userl%20tiles/todo/todo.dart';

class ToDoItem extends StatelessWidget {
  const ToDoItem({super.key, required this.todo, this.onTodoChanged, this.onDeleteItem});

  final ToDo todo;
  final onTodoChanged;
  final onDeleteItem;

  @override
  Widget build(BuildContext context) {
    return Container(margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
      onTap: () {onTodoChanged(todo);},
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 20, vertical: 5),
      tileColor: Colors.white,
      leading: Icon(todo.isDone ? Icons.check_box : Icons.check_box_outline_blank, 
      color: kPrimaryColor,),
      title: Text(todo.todoText!, style: TextStyle(fontSize: 20, 
      color: Colors.black, 
      decoration: todo.isDone? TextDecoration.lineThrough : null
      ),),
      trailing: Container(height: 35, width: 35,
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: Colors.white,
      borderRadius: BorderRadius.circular(5)),
      child: IconButton(onPressed: () {onDeleteItem(todo.id);}, icon: Icon(Icons.delete),
      iconSize: 23, color: Colors.red,),)
    ));
  }
}