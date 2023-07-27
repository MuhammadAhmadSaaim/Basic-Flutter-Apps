import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ticket_booking_app/login_page.dart';
import 'EditProfilePage.dart';
import 'Database_Helper.dart';
import 'widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final int pid;
  ProfilePage({required this.pid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late int pid;

  String fname = '';
  String lname = '';
  String country = '';
  String email = '';
  int number = 0;
  int cnic = 0;

  String picture = '';
  String phonnumberString = '';
  String CnicString = '';

  @override
  void initState() {
    super.initState();
    pid = widget.pid;
    getdata();
  }

  Future<void> getdata() async {
    fname = await DatabaseHelper.getFirstname(pid) ?? '';
    lname = await DatabaseHelper.getLastname(pid) ?? '';
    cnic = await DatabaseHelper.getCNIC(pid);
    email = await DatabaseHelper.getEmail(pid) ?? '';
    country = await DatabaseHelper.getCountry(pid) ?? '';
    number = await DatabaseHelper.getPhoneNumber(pid);
    picture = await DatabaseHelper.getImage(pid) ?? '';

    phonnumberString = '+' + number.toString();
    CnicString = cnic.toString();

    setState(() {});
  }

  Future<void> editpage() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => EditProfilePage(pid: widget.pid),
      ),
    );
    await getdata();
  }

  Future<void> deleteAccountPrompt() async {
    String enteredEmail = '';
    String enteredPassword = '';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Confirm Email & Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  enteredEmail = value;
                },
                decoration:
                    CustomTextFieldDecoration.getInputDecoration('Email'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                  onChanged: (value) {
                    enteredPassword = value;
                  },
                  obscureText: true,
                  decoration:
                      CustomTextFieldDecoration.getInputDecoration('Password')),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final user = await DatabaseHelper.checkLogin(
                    enteredEmail, enteredPassword);
                if (user != null) {
                  await DatabaseHelper.deleteAccount(pid);

                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool('isLoggedIn', false);
                  prefs.remove('userId');

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (BuildContext context) => const login_page(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                } else {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Account not deleted. Incorrect email or password.'),
                    ),
                  );
                }
              },
              child: const Text('Delete Account'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: const Text(
          'BookEase',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                child: Card(
                  color: Colors.grey.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade800,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Colors.grey.shade200,
                                        backgroundImage: picture.isNotEmpty
                                            ? FileImage(File(picture))
                                            : null,
                                      ),
                                    ),
                                    Spacer(),
                                    Text('$fname $lname', style: TextStyle(color: Colors.white, fontSize: 25),maxLines: 2,)
                                  ],
                                )
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              CustomInfoContainer(
                                text: '$email',
                                icon: Icon(Icons.email),
                              ),
                              const SizedBox(height: 20),
                              CustomInfoContainer(
                                text: '$CnicString',
                                icon: Icon(Icons.credit_card),
                              ),
                              const SizedBox(height: 20),
                              CustomInfoContainer(
                                text: '$phonnumberString',
                                icon: Icon(Icons.phone),
                              ),
                              const SizedBox(height: 20),
                              CustomInfoContainer(
                                text: '$country',
                                icon: Icon(Icons.location_on),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                ),
              ),
              const SizedBox(height: 20),
              CustomListTile(
                text: 'Edit Profile',
                icon: const Icon(Icons.edit, color: Colors.black),
                onPressed: () {
                  editpage();
                },
              ),
              const SizedBox(height: 10),
              CustomListTile(
                text: 'Delete Account',
                icon: const Icon(Icons.delete, color: Colors.black),
                onPressed: () {
                  deleteAccountPrompt();
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBackButton(),
    );
  }
}
