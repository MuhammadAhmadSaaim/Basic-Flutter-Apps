import 'dart:io';

import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'Database_Helper.dart';
import 'package:flutter/material.dart';
import 'widgets.dart';

class EditProfilePage extends StatefulWidget {
  final int pid;
  EditProfilePage({required this.pid});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _CNICController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _PhoneumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  bool _isLoading = true;
  late int pid;
  int number = 0;
  int cnic = 0;
  String picture = '';

  String address = '';
  late String _selectedCity;
  late String _selectedState;
  late String _selectedCountry;

  @override
  void initState() {
    super.initState();
    pid = widget.pid;
    getdata();
  }

  Future<void> getdata() async {
    address = await DatabaseHelper.getCountry(pid);

    List<String> addressData = address.split(', ');
    if (addressData.length >= 3) {
      _selectedCity = addressData[0];
      _selectedState = addressData[1];
      _selectedCountry = addressData[2];
    }

    _emailController.text = await DatabaseHelper.getEmail(pid);
    cnic = await DatabaseHelper.getCNIC(pid);
    _firstNameController.text = await DatabaseHelper.getFirstname(pid);
    _lastNameController.text = await DatabaseHelper.getLastname(pid);
        number = await DatabaseHelper.getPhoneNumber(pid);
    _PhoneumberController.text = number.toString();
    _CNICController.text = cnic.toString();
    picture = await DatabaseHelper.getImage(pid) ?? '';

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> saveProfileData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String firstName = _firstNameController.text;
      String lastName = _lastNameController.text;
      int phoneNumber = int.tryParse(_PhoneumberController.text) ?? 0;
      address = _selectedCity + ', ' + _selectedState + ', ' + _selectedCountry;

      await DatabaseHelper.updateProfileData(
        pid: pid,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        address: address,
      );
      await DatabaseHelper.setImage(pid, picture);

      setState(() {});
      Navigator.of(context).pop();
    }
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
        title: const Text(
          'BookEase',
          style: TextStyle(fontSize: 30),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  enabled: false,
                  controller: _emailController,
                  style: const TextStyle(color: Colors.black),
                  decoration:
                      CustomTextFieldDecoration.getInputDecoration('Email'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, right: 20, left: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        enabled: true, // Enable first name text field
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
                        enabled: true, // Enable last name text field
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
                  enabled: false,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(13),],
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
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, right: 20, left: 20),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(12),],
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
                padding: const EdgeInsets.only(bottom: 15, right: 20, left: 20),
                child: _isLoading
                    ? LoadingWidget()
                    : CSCPicker(
                  flagState: CountryFlag.DISABLE,
                  currentCountry: _selectedCountry,
                  currentCity: _selectedCity,
                  currentState: _selectedState,
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
              CustomElevatedButton(
                text: 'Save',
                onPressed: () {
                  saveProfileData();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
