import 'package:flutter/material.dart';
import 'widgets.dart';
import 'otpPage.dart';
import 'SignUp.dart';
import 'Database_Helper.dart';

class login_page extends StatefulWidget {
  const login_page({super.key});

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String usernameError = '';
  String passwordError = '';



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
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    setState(() {
      usernameError = '';
      passwordError = '';
    });

    if (!validateEmail(email) || !validatePassword(password)) {
      return;
    }

    Map<String, dynamic>? user =
    await DatabaseHelper.checkLogin(email, password);

    print('$user');

    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpPage(pid: user['PID']),
        ),
      );

      _emailController.text = '';
      _passwordController.text = '';
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

          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const Padding(
                      padding: EdgeInsets.only(top: 200, left: 20, right: 20),
                      child: HeaderText(label: 'BookEase')),
                  const Padding(
                      padding: EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 100),
                      child: BodyLabel(
                          label: 'Effortless bookings at your fingertips!')),
                  Padding(
                      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: TextField(
                        style: const TextStyle(color: Colors.black),
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.black),
                          labelText: 'Email',
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          errorText: usernameError.isNotEmpty ? usernameError : null,
                        ),
                      ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                      child:  TextField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.black),
                          labelText: 'Password',
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          errorText: passwordError.isNotEmpty ? passwordError : null,
                        ),
                      ),),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: CustomElevatedButton(
                      onPressed: () {login();},
                      text: 'Sign In',
                    ),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text(
                      'Not a member,',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => SignUpPage(),
                        ));
                      },
                      child: const Text(
                        'Register Now',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ));
  }
}
