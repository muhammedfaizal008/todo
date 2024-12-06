// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:todo/controller/first_screen_controller.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  List<Map<String, dynamic>> todos = [];
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodos(); // Load todos from the database
  }

  Future<void> _loadTodos() async {
    List<Map<String, dynamic>> loadedTodos =
        await FirstScreenController.getTodo();
    setState(() {
      todos = loadedTodos;
    });
  }

  Future<void> _addTodo() async {
    if (_textController.text.isNotEmpty) {
      await FirstScreenController.addTodo(_textController.text, 0);
      _textController.clear();
      await _loadTodos();
    }
  }

  Future<void> _deleteTodo(int id) async {
    await FirstScreenController.deleteTodo(id);
    await _loadTodos();
  }

  Future<void> _toggleTodoStatus(int id, bool currentStatus) async {
    await FirstScreenController.toggleTodo(id, currentStatus ? 0 : 1);
    await _loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo App",style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w600
        ),),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search",
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text("All ToDos",style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500
                ),),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: ListTile(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("About"),
                                content: Text(todo["task"]),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                          tileColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          leading: IconButton(
                            onPressed: () => _toggleTodoStatus(
                              todo["id"],
                              todo["isDone"] == 1,
                            ),
                            icon: Icon(
                              todo["isDone"] == 0
                                  ? Icons.check_box_outline_blank
                                  : Icons.check_box,
                            ),
                          ),
                          title: Text(
                            todo["task"],
                            style: TextStyle(
                              decoration: todo["isDone"] == 1
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          trailing: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () => _deleteTodo(todo["id"]),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _textController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.add),
                        hintText: "Add ToDo",
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  ElevatedButton(
                    style: ButtonStyle(
                      padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(vertical: 20)),
                      backgroundColor:
                          WidgetStatePropertyAll(Colors.grey),
                      foregroundColor:
                          WidgetStatePropertyAll(Colors.black),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    onPressed: _addTodo,
                    child: Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
