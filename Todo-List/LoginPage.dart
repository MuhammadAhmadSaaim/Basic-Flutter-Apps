import 'package:flutter/material.dart';
import 'Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DBfile.dart';
import 'SignUp.dart';
import 'widgets.dart';

class MyLoginPage extends StatefulWidget {
  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String usernameError = '';
  String passwordError = '';

  @override
  void initState() {
    super.initState();
    checkLoggedInUser();
  }

  Future<void> checkLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');

    if (userId != null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => MyHomePage(pid: userId),
        ),
            (Route<dynamic> route) => false,
      );
    }
  }

  bool validateEmail(String email) {
    if (email.isEmpty) {
      setState(() {
        usernameError = 'Please enter an email.';
      });
      return false;
    }
    return true;
  }

  bool validatePassword(String password) {
    if (password.isEmpty) {
      setState(() {
        passwordError = 'Please enter a password.';
      });
      return false;
    }
    return true;
  }

  Future<void> login() async {
    String email = loginController.text.trim();
    String password = passwordController.text;

    setState(() {
      usernameError = '';
      passwordError = '';
    });

    if (!validateEmail(email) || !validatePassword(password)) {
      return;
    }

    Map<String, dynamic>? user =
    await DatabaseHelper.checkLogin(email, password);

    if (user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', user['id'] as int);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => MyHomePage(pid: user['id']),
        ),
      );
      loginController.text = '';
      passwordController.text = '';
    } else {
      setState(() {
        passwordError = 'Username or Password is incorrect.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('To-Do List'),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        backgroundColor: Colors.indigo[200],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 50, right: 50, left: 50),
                child: HeaderText(label: 'LogIN'),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, right: 50, left: 50),
                child: TextField(
                  style: TextStyle(color: Colors.indigo),
                  controller: loginController,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.indigo),
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.white,
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigo),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigo),
                    ),
                    errorText: usernameError.isNotEmpty ? usernameError : null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30, right: 50, left: 50),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.indigo),
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.white,
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigo),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigo),
                    ),
                    errorText: passwordError.isNotEmpty ? passwordError : null,
                  ),
                ),
              ),
              CustomElevatedButton(
                text: 'Login',
                onPressed: () {
                  login();
                },
              ),
              SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  'Register Now,',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => RegistrationForm(),
                    ));
                  },
                  child: Text(
                    'SignUp',
                    style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

