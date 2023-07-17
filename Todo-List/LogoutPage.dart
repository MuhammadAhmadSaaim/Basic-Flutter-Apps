import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';
import 'widgets.dart';

class LogoutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.indigo[500],
      title: const CustomLabel(label: 'Log Off'),
      content: const CustomLabel(label: 'Are you sure you want to log off?'),
      actions: [
        TextButton(
          child: const CustomLabel(label: 'Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const CustomLabel(label: 'Log Off'),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove('userId');
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => MyLoginPage(),
              ),
                  (Route<dynamic> route) => false, // Remove all previous routes
            );
          },
        ),
      ],
    );
  }
}
