import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';  // Import for JSON encoding and decoding
import '../utils/todo_list.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  List toDoList = [];

  @override
  void initState() {
    super.initState();
    _loadToDoList();
  }

  void checkBoxChanged(int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
      _saveToDoList();
    });
  }

  void saveNewTask() {
    setState(() {
      toDoList.add([_controller.text, false]);
      _controller.clear();
      _saveToDoList();
    });
  }

  void deleteTask(int index) {
    setState(() {
      toDoList.removeAt(index);
      _saveToDoList();
    });
  }

  // Load the todo list from shared preferences
  void _loadToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    String? toDoListString = prefs.getString('toDoList');
    if (toDoListString != null) {
      setState(() {
        toDoList = json.decode(toDoListString);
      });
    }
  }

  // Save the todo list to shared preferences
  void _saveToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('toDoList', json.encode(toDoList));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      appBar: AppBar(
        title: const Text(
          'Simple Todo',
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: toDoList.length,
        itemBuilder: (BuildContext context, index) {
          return TodoList(
            taskName: toDoList[index][0],
            taskCompleted: toDoList[index][1],
            onChanged: (value) => checkBoxChanged(index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Add a new todo item',
                    filled: true,
                    fillColor: Colors.deepPurple.shade200,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.deepPurple,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.deepPurple,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: saveNewTask,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
