import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'DBfile.dart';
import 'widgets.dart';

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  String? image;

  String picture = '';

  Future<int> registerUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      final String email = _emailController.text;
      final String password = _passwordController.text;
      final String firstName = _firstNameController.text;
      final String lastName = _lastNameController.text;
      final String address = _addressController.text;

      int id = await DatabaseHelper.checkemail(email);

      if (id == -1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'Error',
                style: TextStyle(color: Colors.red),
              ),
              content: Text(
                'Email already exists.',
                style: TextStyle(color: Colors.red),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.indigo),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        id = await DatabaseHelper.addUser(
          email,
          password,
          firstName,
          lastName,
          address,
          image,
        );

        if (id != -1) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.indigo[200],
                title: CustomLabel(
                  label: 'Success',
                ),
                content: CustomLabel(
                  label: 'User Registered Successfully',
                ),
                actions: <Widget>[
                  TextButton(
                    child: CustomLabel(
                      label: 'Ok',
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        }
      }

      return id;
    }
    return -1;
  }

  void singleImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        this.image = image.path;
        picture = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('To-Do List'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.indigo[200],
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, right: 50, left: 50),
                  child: HeaderText(label: 'Register User'),
                ),
                GestureDetector(
                    onTap: () {
                      singleImage();
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.indigo,
                            backgroundImage: picture.isNotEmpty
                                ? FileImage(File(picture))
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              singleImage();
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Colors.indigo,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                const SizedBox(height: 20.0),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, right: 50, left: 50),
                  child: TextFormField(
                    controller: _emailController,
                    style: TextStyle(color: Colors.indigo),
                    decoration:
                        CustomTextFieldDecoration.getInputDecoration('Email'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Email is required';
                      }
                      if (!RegExp(
                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                          .hasMatch(value!)) {
                        return 'Invalid email format';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, right: 50, left: 50),
                  child: TextFormField(
                    controller: _passwordController,
                    style: TextStyle(color: Colors.indigo),
                    decoration: CustomTextFieldDecoration.getInputDecoration(
                        'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Password is required';
                      }
                      if (value!.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      if (!value.contains(RegExp(r'[A-Z]'))) {
                        return 'Password must contain at least one uppercase letter';
                      }
                      if (!value.contains(RegExp(r'[a-z]'))) {
                        return 'Password must contain at least one lowercase letter';
                      }
                      if (!value.contains(RegExp(r'[0-9]'))) {
                        return 'Password must contain at least one number';
                      }
                      if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                        return 'Password must contain at least one special character';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, right: 50, left: 50),
                  child: TextFormField(
                    controller: _firstNameController,
                    style: TextStyle(color: Colors.indigo),
                    decoration: CustomTextFieldDecoration.getInputDecoration(
                        'Frst Name'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'First Name is required';
                      }
                      final nameRegExp = RegExp(r'^[a-zA-Z]+$');
                      if (!nameRegExp.hasMatch(value!)) {
                        return 'Invalid name format';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, right: 50, left: 50),
                  child: TextFormField(
                    controller: _lastNameController,
                    style: TextStyle(color: Colors.indigo),
                    decoration: CustomTextFieldDecoration.getInputDecoration(
                        'Last Name'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Last Name is required';
                      }

                      final nameRegExp = RegExp(r'^[a-zA-Z]+$');
                      if (!nameRegExp.hasMatch(value!)) {
                        return 'Invalid name format';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, right: 50, left: 50),
                  child: TextFormField(
                    controller: _addressController,
                    style: TextStyle(color: Colors.indigo),
                    decoration:
                        CustomTextFieldDecoration.getInputDecoration('Address'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Address is required';
                      }
                      return null;
                    },
                  ),
                ),
                CustomElevatedButton(
                  text: 'Register',
                  onPressed: () {
                    registerUser();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
