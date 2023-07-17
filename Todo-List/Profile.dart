import 'package:flutter/material.dart';
import 'LogoutPage.dart';
import 'Products.dart';
import 'DBfile.dart';
import 'Home.dart';
import 'dart:io';
import 'EditProfilePage.dart';
import 'widgets.dart';

class Profilepage extends StatefulWidget {
  final int pid;

  Profilepage({required this.pid});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  late int pid;

  String fname = '';
  String lname = '';
  String address = '';
  String email = '';
  String picture = '';
  String? temp;

  @override
  void initState() {
    super.initState();
    pid = widget.pid;
    getdata();
  }

  Future<void> getdata() async {
    fname = await DatabaseHelper.getFirstName(pid) ?? '';
    lname = await DatabaseHelper.getLastName(pid) ?? '';
    address = await DatabaseHelper.getAddress(pid) ?? '';
    email = await DatabaseHelper.getEmail(pid) ?? '';
    picture = await DatabaseHelper.getImage(pid) ?? '';

    setState(() {});
  }

  Future<void> updateprofile() async{
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (BuildContext context) => EditProfilePage(pid: pid, tempText: temp),
      ),
    );

    if (result != null) {
        temp = result;
    }
    getdata();
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
    return Scaffold(
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderText(label: 'Profile Page'),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.indigo,
                    backgroundImage: picture.isNotEmpty ? FileImage(File(picture)) : null,
                  ),
                ),

              ),
              ProfilePageDivider(),
              DataRowWidget(label: 'Email: ', value: email),
              DataRowWidget(label: 'First Name: ', value: fname),
              DataRowWidget(label: 'Last Name: ', value: lname),
              DataRowWidget(label: 'Address: ', value: address),
              DataRowWidget(label: temp != null ? 'Bio: ' : '', value: temp ?? ''),
              ProfilePageDivider(),
              Center(
                child: TextButton(
                    onPressed: () {updateprofile();},
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontStyle: FontStyle.italic, decoration: TextDecoration.underline),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
