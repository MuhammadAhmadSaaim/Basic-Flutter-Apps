import 'package:flutter/material.dart';
import 'DBfile.dart';
import 'widgets.dart';

class TaskPage extends StatefulWidget {
  final int? taskId;
  final int pid;
  List<Map<String, dynamic>> tasks;

  TaskPage({this.taskId, required this.pid, required this.tasks});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.taskId != null) {
      final task = widget.tasks.firstWhere((element) => element['id'] == widget.taskId);
      titleController.text = task['title'];
    }
  }

  void refreshList() async {
    final data = await DatabaseHelper.getTasks(widget.pid);
    setState(() {
      widget.tasks = data;
    });
  }

  Future<void> saveTask() async {
    if (titleController.text.isNotEmpty) {
      if (widget.taskId == null) {
        await DatabaseHelper.addTask(titleController.text.trim(), widget.pid);
      } else {
        await DatabaseHelper.updateTask(widget.taskId!, titleController.text.trim());
      }
      refreshList();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonText = widget.taskId == null ? 'Save' : 'Edit';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.taskId == null ? 'Add Task' : 'Update Task'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.indigo[200],
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextField(
              controller: titleController,
              labelText: 'Enter Task:',
            ),
            CustomElevatedButton(
              text: buttonText,
              onPressed: () {
                saveTask();
              },
            ),
          ],
        ),
      ),
    );
  }
}
