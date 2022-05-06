import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/repositories/todo_repository.dart';
import 'package:todo_list/widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<Todo> todos = [];
  Todo? deletedTodo;
  int? deletedTodoPosition;

  String? errorText;

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [
                  Color(0xffd16ba5),
                  Color(0xffc777b9),
                  Color(0xffba83ca),
                  Color(0xffaa8fd8),
                  Color(0xff9a9ae1),
                  Color(0xff8aa7ec),
                  Color(0xff79b3f4),
                  Color(0xff69bff8),
                  Color(0xff52cffe),
                  Color(0xff41dfff),
                  Color(0xff46eefa),
                  Color(0xff5ffbf1)
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "Todo List",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: TextField(
                                controller: todoController,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: "Adicione uma tarefa",
                                  labelStyle: const TextStyle(
                                    color: Color(0xffd16ba5),
                                  ),
                                  errorText: errorText,
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xffd16ba5),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(14),
                              primary: const Color(0xffd16ba5),
                            ),
                            onPressed: () {
                              String text = todoController.text;

                              if (text.isEmpty) {
                                setState(() {
                                  errorText = 'O campo não pode ser vazio!';
                                });
                                return;
                              }

                              setState(() {
                                Todo newTodo =
                                    Todo(title: text, date: DateTime.now());
                                todos.add(newTodo);
                                errorText = null;
                              });
                              todoController.clear();
                              todoRepository.SaveTodoList(todos);
                            },
                            child: const Icon(
                              Icons.add,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                      Flexible(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            for (Todo todo in todos)
                              TodoListItem(
                                todo: todo,
                                onDelete: onDelete,
                              ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(todos.isEmpty
                                ? "Você não possui tarefas pendentes"
                                : "Você possui ${todos.length} tarefas pendentes"),
                          ),
                          ElevatedButton(
                            onPressed: showDeleteTodosConfirmationDialog,
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xffd16ba5),
                            ),
                            child: const Text("Limpar tudo"),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPosition = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });
    todoRepository.SaveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'A tarefa ${todo.title} foi removida com sucesso!',
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color(0xff79b3f4),
        action: SnackBarAction(
          label: 'DESFAZER',
          textColor: const Color(0xffd16ba5),
          onPressed: () {
            setState(() {
              todos.insert(deletedTodoPosition!, deletedTodo!);
            });
            todoRepository.SaveTodoList(todos);
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void showDeleteTodosConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Limpar Tudo"),
        content:
            const Text("Deseja realmente apagar todos os tarefas da lista?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "Cancelar",
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteAllTodos();
            },
            style: TextButton.styleFrom(primary: Colors.red),
            child: const Text(
              "Limpar Tudo",
            ),
          )
        ],
      ),
    );
  }

  void deleteAllTodos() {
    setState(() {
      todos.clear();
    });
    todoRepository.SaveTodoList(todos);
  }
}
