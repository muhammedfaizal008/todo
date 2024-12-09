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
  List<Map<String, dynamic>> filteredTodos = [];
  final _textController = TextEditingController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodos(); 
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
  _filterTodos(); 
}


  Future<void> _toggleTodoStatus(int id, bool currentStatus) async {
  await FirstScreenController.toggleTodo(id, currentStatus ? 0 : 1);
  await _loadTodos(); 
  _filterTodos(); 
}

  void _filterTodos() {
  final query = _searchController.text.toLowerCase();
  setState(() {
    filteredTodos = todos
        .where((todo) => todo["task"].toString().toLowerCase().contains(query))
        .toList();
  });
}


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Todo App",
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
      ),
    ),
    body: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _searchController,
                onChanged: (value) => _filterTodos(),
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
              child: Text(
                "All ToDos",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),

            Expanded(
              child: todos.isEmpty
                  ? Center(child: Text('No todos added')) // Show message when no todos are available
                  : ListView.builder(
                      itemCount: filteredTodos.isNotEmpty || _searchController.text.isNotEmpty
                          ? filteredTodos.length
                          : todos.length,
                      itemBuilder: (context, index) {
                        final todo = filteredTodos.isNotEmpty || _searchController.text.isNotEmpty
                            ? filteredTodos[index]
                            : todos[index];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: ListTile(
                              onTap: () {
                                _textController.text = todo["task"];
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Edit Todo"),
                                    content: TextFormField(
                                      controller: _textController,
                                      decoration: InputDecoration(
                                        label: Text("Edit Todo"),
                                        hintText: "Enter updated task",
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          if (_textController.text.isNotEmpty) {
                                            FirstScreenController.updateTodo(
                                              todo["id"],
                                              _textController.text,
                                            );
                                            _textController.clear();
                                            Navigator.of(context).pop();
                                            _loadTodos(); 
                                          }
                                        },
                                        child: Text('Save'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _textController.clear();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              tileColor: Colors.white,
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
                                    color: todo["isDone"] == 0?null:Colors.green,
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
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: Colors.black,
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
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
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
