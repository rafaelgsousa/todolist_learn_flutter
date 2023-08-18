import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/repository/todo_repository.dart';
import '../Widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todos = [];
  Todo? deletedTodo;
  int? deletedTodoPos;

  String? errorText;

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
      todoRepository.saveTodoList(todos);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tarefa ${todo.title} foi removida com sucesso',
            style: TextStyle(color: Color(0xff060708)),),
          backgroundColor: Colors.white,
          action: SnackBarAction(
            label: 'Desfazer',
            textColor: const Color(0xff00d7f3),
            onPressed: () {
              setState(() {
                todos.insert(deletedTodoPos!, deletedTodo!);
                todoRepository.saveTodoList(todos);
              });
            },
          ),
          duration: const Duration(seconds: 5),
        )
    );
  }

  void deleteAllTodos(){
    setState(() {
      todos.clear();
      todoRepository.saveTodoList(todos);
    });
  }

  void showDeletionsTodosConfirmationDiolog() {
    showDialog(context: context, builder: (context) =>
        AlertDialog(
          title: Text('limpar Tudo?'),
          content: Text('Você tem certeza que deseja apagar todas as tarefas?'),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(context).pop();},
              style: TextButton.styleFrom(foregroundColor: Color(0xff00d7f3)),
              child: Text('Cancelar'),
            ),
            TextButton(onPressed: (){
              Navigator.of(context).pop();
              deleteAllTodos();
            }, style: TextButton.styleFrom(foregroundColor: Colors.red), child: Text('Limpar tudo'),)
          ],
        ),
    );
  }

  @override
  void initState(){
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: TextField(
                            controller: todoController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Adicione uma tarefa',
                              hintText: 'Ex. Estudar Flutter',
                              errorText: errorText,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff00d7f3),
                                  width: 2
                                )
                              ),
                              labelStyle: TextStyle(
                                color: Color(0xff00d7f3)
                              )
                            ),
                          )
                      ),
                      SizedBox(width: 8,),
                      ElevatedButton(
                          onPressed: () {
                            String text = todoController.text;

                            if (text.isEmpty) {
                              setState(() {
                                errorText = 'O título não pode ser vazio!';
                              });
                              return;
                            }
                            setState(() {
                              Todo newTodo = Todo(
                                title: text,
                                dateTime: DateTime.now(),
                              );
                              todos.add(newTodo);
                              errorText = null;
                            });
                            todoController.clear();
                            todoRepository.saveTodoList(todos);
                          },
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.all(14)
                            // fixedSize: Size(100,100),
                          ),
                          child: Icon(
                            Icons.add,
                            size: 30,
                          )
                      )
                    ],
                  ),
                  SizedBox(height: 16,),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for(Todo todo in todos)
                          TodoListItem(
                            todo: todo,
                            onDelete: onDelete,
                          ),
                        // ListTile(
                        //   title: Text(todo),
                        //   subtitle: Text('20/11/23'),
                        //   leading: Icon(Icons.save, size: 30),
                        //   onTap: () {
                        //     print('Tarefa: $todo');
                        //   },
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16,),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                              'Você possui ${todos.length} tarefas pendentes.')
                      ),
                      SizedBox(width: 8,),
                      ElevatedButton(
                          onPressed: showDeletionsTodosConfirmationDiolog,
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.all(14)
                            // fixedSize: Size(100,100),
                          ),
                          child: Text('Limpar tudo')
                      )
                    ],
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}