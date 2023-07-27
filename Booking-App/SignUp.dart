import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ticket_booking_app/login_page.dart';
import 'Database_Helper.dart';
import 'package:flutter/material.dart';
import 'widgets.dart';
import 'package:csc_picker/csc_picker.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _CNICController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _PhoneumberController = TextEditingController();
  final TextEditingController _PasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  String? image;

  String _selectedCity = '';
  String _selectedState = '';
  String _selectedCountry = '';

  String errorMessage = '';
  String picture = '';

  Future<int> registerUser() async {
    if (_formKey.currentState?.validate() ??
        false &&
            _selectedCountry.isNotEmpty &&
            _selectedState.isNotEmpty &&
            _selectedCity.isNotEmpty) {
      final String email = _emailController.text;
      final String firstName = _firstNameController.text;
      final String lastName = _lastNameController.text;
      final int cnic = int.parse(_CNICController.text);
      final int phoneNumber = int.parse(_PhoneumberController.text);
      final String country =
          _selectedCity + ', ' + _selectedState + ', ' + _selectedCountry;
      final String password = _PasswordController.text;
      setState(() {
        errorMessage = '';
      });

      int id = await DatabaseHelper.addUser(
        email,
        firstName,
        lastName,
        cnic,
        phoneNumber,
        country,
        password,
        picture,
      );

      if (id == -1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text(
                'Error',
                style: TextStyle(color: Colors.red),
              ),
              content: const Text(
                'Email already exists.',
                style: TextStyle(color: Colors.red),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.black54),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'Success',
                style: TextStyle(color: Colors.black),
              ),
              content: const Text(
                'User Registered Successfully',
                style: TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) => login_page(),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      }
      return id;
    }
    if (_selectedCountry.isEmpty ||
        _selectedState.isEmpty ||
        _selectedCity.isEmpty) {
      setState(() {
        errorMessage = 'Location is required';
      });
      return -1;
    } else {
      setState(() {
        errorMessage = '';
      });
    }
    return -1;
  }

  void singleImage() async {
    final imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade200,
          title: const Text(
            'Select Source',
            style: TextStyle(color: Colors.black),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextButton(
                  child: const Text(
                    'Gallery',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(ImageSource.gallery);
                  },
                ),
                TextButton(
                  child: const Text(
                    'Camera',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
    if (imageSource != null) {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image != null) {
        setState(() {
          picture = image.path;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Sign Up'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20.0),
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
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey.shade200,
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
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, right: 20, left: 20),
                child: TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.black),
                  decoration:
                      CustomTextFieldDecoration.getInputDecoration('Email'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                        .hasMatch(value!)) {
                      return 'Invalid email format';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, right: 20, left: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        style: const TextStyle(color: Colors.black),
                        decoration:
                            CustomTextFieldDecoration.getInputDecoration(
                                'First Name'),
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
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        style: const TextStyle(color: Colors.black),
                        decoration:
                            CustomTextFieldDecoration.getInputDecoration(
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, right: 20, left: 20),
                child: TextFormField(
                  controller: _PasswordController,
                  style: const TextStyle(color: Colors.black),
                  decoration:
                      CustomTextFieldDecoration.getInputDecoration('Password'),
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
                padding: const EdgeInsets.only(bottom: 15, right: 20, left: 20),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(13),
                  ],
                  controller: _CNICController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.black),
                    labelText: 'CNIC',
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    hintText: 'Eg. 35202XXXXXXXX (Without Dashes)',
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
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'CNIC is required';
                    }
                    if (value!.length != 13) {
                      return 'CNIC must be 13 characters long';
                    }
                    if (value!.contains('-')) {
                      return 'CNIC is Incorrect';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, right: 20, left: 20),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(12),
                  ],
                  controller: _PhoneumberController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.black),
                    labelText: 'Phone Number',
                    hintText: 'Eg. 923XXXXXXXXX',
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
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Phone Number is required';
                    }
                    if (value!.length != 12) {
                      return 'Phone Number must be 12 characters long';
                    }
                    if (!value.startsWith('92')) {
                      return 'Phone Number is incorrect';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5, right: 20, left: 20),
                child: CSCPicker(
                  flagState: CountryFlag.DISABLE,
                  onCountryChanged: (country) {
                    setState(() {
                      _selectedCountry = country;
                    });
                  },
                  onStateChanged: (state) {
                    setState(() {
                      _selectedState = state ?? '';
                    });
                  },
                  onCityChanged: (city) {
                    setState(() {
                      _selectedCity = city ?? '';
                    });
                  },
                  dropdownDialogRadius: 15,
                  searchBarRadius: 15,
                ),
              ),
              errorMessage.isNotEmpty
                  ? Padding(
                padding: EdgeInsets.only(left: 35),
                    child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                          Text(
                            errorMessage,
                            style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                  : SizedBox(),
              SizedBox(
                height: 20,
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
      bottomNavigationBar: CustomBackButton(),
    );
  }
}
