import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_booking_app/AdminPage.dart';
import 'login_page.dart';
import 'HomePage.dart';
import 'package:firebase_core/firebase_core.dart';

//For running main page
/*void main(){
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Admin()));
}*/

//For running App on user end
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SessionHandler(),
    );
  }
}

class SessionHandler extends StatefulWidget {
  @override
  _SessionHandlerState createState() => _SessionHandlerState();
}

class _SessionHandlerState extends State<SessionHandler> {
  @override
  void initState() {
    super.initState();
    checkSession();
  }

  void checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      int userId = prefs.getInt('userId') ?? -1;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home_page(pid: userId),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const login_page(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image(
            image: AssetImage("assets/icon/BE.png"),
          ),
        ));
  }
}
