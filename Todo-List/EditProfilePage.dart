import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'DBfile.dart';
import 'widgets.dart';

class EditProfilePage extends StatefulWidget {
  final int pid;
  String? tempText;

  EditProfilePage({required this.pid, this.tempText});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late int pid;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController tempController = TextEditingController();

  String fname = '';
  String lname = '';
  String address = '';
  String picture = '';
  String? tempText = '';

  @override
  void initState() {
    super.initState();
    tempText=widget.tempText;
    pid = widget.pid;
    getUserData();
  }

  Future<void> getUserData() async {
    fname = await DatabaseHelper.getFirstName(pid) ?? '';
    lname = await DatabaseHelper.getLastName(pid) ?? '';
    address = await DatabaseHelper.getAddress(pid) ?? '';
    picture = await DatabaseHelper.getImage(pid) ?? '';

    setState(() {
      firstNameController.text = fname;
      lastNameController.text = lname;
      addressController.text = address;
      tempController.text = tempText ?? '';
    });
  }

  Future<void> updateUser() async {
    String newFirstName = firstNameController.text.trim();
    String newLastName = lastNameController.text.trim();
    String newAddress = addressController.text.trim();
    tempText = tempController.text.trim();

    await DatabaseHelper.setFirstName(pid, newFirstName);
    await DatabaseHelper.setLastName(pid, newLastName);
    await DatabaseHelper.setAddress(pid, newAddress);
    await DatabaseHelper.setImage(pid, picture);

    Navigator.of(context).pop(tempText);
  }

  void singleImage() async {
    final imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.indigo[200],
          title: Text('Select Source', style: TextStyle(color: Colors.white),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextButton(
                  child: Text('Gallery', style: TextStyle(color: Colors.indigo),),
                  onPressed: () {
                    Navigator.of(context).pop(ImageSource.gallery);
                  },
                ),
                TextButton(
                  child: Text('Camera', style: TextStyle(color: Colors.indigo),),
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
          this.picture = image.path;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edit Profile'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.indigo[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              const SizedBox(height: 20,),
              CustomTextField(
                controller: firstNameController,
                labelText: 'Firstname:',
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                controller: lastNameController,
                labelText: 'Lastname:',
              ),

              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                controller: addressController,
                labelText: 'Address:',
              ),
              const SizedBox(
                height: 20,
              ),

              CustomTextField(
                controller: tempController,
                labelText: 'Enter Bio Here:',
              ),
              const SizedBox(height: 20,),
              CustomElevatedButton(
                text: 'Save',
                onPressed: () {
                  updateUser();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
