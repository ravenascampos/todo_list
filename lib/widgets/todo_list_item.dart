import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({
    Key? key,
    required this.todo,
    required this.onDelete,
  }) : super(key: key);

  final Todo todo;
  final Function(Todo) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Slidable(
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.2,
            children: [
              SlidableAction(
                backgroundColor: Colors.red,
                icon: Icons.delete,
                onPressed: (context) {
                  onDelete(todo);
                },
              )
            ],
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Color(0xffe6e1ef),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  DateFormat('dd/MM/yyyy - HH:mm').format(todo.date),
                  style: const TextStyle(fontSize: 12, color: Colors.black38),
                ),
                Text(
                  todo.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
