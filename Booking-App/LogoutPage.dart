import 'package:flutter/material.dart';
import 'login_page.dart';
import 'widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade200,
      title: const Text(
        'Are you sure you want to logout?',
        style: TextStyle(fontSize: 15),
      ),
      actions: [
        TextButton(
          child: const BodyLabel(label: 'Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const BodyLabel(label: 'Logout'),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool('isLoggedIn', false);
            prefs.remove('userId');

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => login_page(),
              ),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ],
    );
  }
}
