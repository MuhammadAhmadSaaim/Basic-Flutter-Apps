import 'package:flutter/material.dart';
import 'Products.dart';
import 'DBfile.dart';
import 'dart:io';
import 'task_page.dart';
import 'Profile.dart';
import 'widgets.dart';
import 'LogoutPage.dart';

class MyHomePage extends StatefulWidget {
  final int pid;
  MyHomePage({required this.pid});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> tasks = [];
  late int pid;

  String fname = '';
  String lname = '';
  String email = '';
  String picture = '';

  void refreshList() async {
    final data = await DatabaseHelper.getTasks(pid);
    setState(() {
      tasks = data;
    });
  }

  @override
  void initState() {
    pid = widget.pid;
    refreshList();
    getdata();
    super.initState();
  }

  Future<void> getdata() async {
    fname = await DatabaseHelper.getFirstName(pid) ?? '';
    lname = await DatabaseHelper.getLastName(pid) ?? '';
    picture = await DatabaseHelper.getImage(pid) ?? '';
    email = await DatabaseHelper.getEmail(pid) ?? '';

    setState(() {});
  }

  TextEditingController title_controller = TextEditingController();

  Future<void> addtask() async {
    if (title_controller.text.isNotEmpty) {
      await DatabaseHelper.addTask(title_controller.text, pid);
      refreshList();
    }
  }

  Future<void> updatetask(int id) async {
    await DatabaseHelper.updateTask(id, title_controller.text);
    refreshList();
  }

  Future<void> deletetask(int id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.indigo[500],
          title: const CustomLabel(label: 'Delete Task',),
          content: const CustomLabel(label: 'Are you sure you want to delete this task?',),
          actions: [
            TextButton(
              child: const CustomLabel(label: 'Cancel',),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const CustomLabel(label: 'Delete',),
              onPressed: () async {
                final deletedTask =
                    tasks.firstWhere((element) => element['id'] == id);

                await DatabaseHelper.deleteTask(id);
                refreshList();

                final snackBar = SnackBar(
                  content: const CustomLabel(label: 'Task Deleted',),
                  action: SnackBarAction(
                    label: 'Undo',
                    textColor: Colors.indigo[200],
                    onPressed: () {
                      if (deletedTask != null) {
                        DatabaseHelper.addTask(deletedTask!['title'], pid);
                        refreshList();
                      }
                    },
                  ),
                  duration: const Duration(seconds: 3),
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> taskdialogbox(int? id) async {
    if (id != null) {
      final available_tasks =
          tasks.firstWhere((element) => element['id'] == id);
      title_controller.text = available_tasks['title'];
    } else {
      title_controller.text = '';
    }

    await Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) =>
          TaskPage(taskId: id, pid: pid, tasks: tasks),
    ));
    title_controller.text = '';
    refreshList();
  }

  void Logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LogoutDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Logout();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: const Text('To-Do List'),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  Logout();
                }),
          ],
        ),
        drawer: Drawer(
          backgroundColor: Colors.indigo[100],
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.indigo,
                  backgroundImage:
                  picture.isNotEmpty ? FileImage(File(picture)) : null,
                ),
                accountName: Text('$fname $lname,'),
                accountEmail: Text(email),
                decoration: BoxDecoration(color: Colors.indigo[200]),
              ),
              CustomListTile(
                label: 'Home',
                icon: Icons.home,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => MyHomePage(pid: pid),
                    ),
                  );
                },
              ),
              CustomListTile(
                label: 'Profile',
                icon: Icons.account_box,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => Profilepage(pid: pid),
                    ),
                  );
                },
              ),
              CustomListTile(
                label: 'Product',
                icon: Icons.square,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => ProductsPage(pid: pid),
                    ),
                  );
                },
              ),
              CustomListTile(
                label: 'Close',
                icon: Icons.close,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.indigo[200],
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20, right: 20, left: 20),
              child: HeaderText(label: 'Tasks'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                padding: const EdgeInsets.only(bottom: 20),
                itemBuilder: (context, index) => Card(
                  color: Colors.indigo[400],
                  margin: const EdgeInsets.only(top: 20, right: 15, left: 15),
                  child: GestureDetector(
                    onTap: () {
                      taskdialogbox(tasks[index]['id']);
                    },
                    child: ListTile(
                      title: CustomLabel(label: tasks[index]['title'],),
                      trailing: SizedBox(
                        width: 40,
                        child: IconButton(
                          iconSize: 20,
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deletetask(tasks[index]['id']);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            taskdialogbox(null);
          },
          icon: const Icon(Icons.add_task),
          backgroundColor: Colors.indigo,
          label: const Text('Add Task'),
        ),
      ),
    );
  }
}
