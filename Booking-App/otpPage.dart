import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';
import 'widgets.dart';
import 'Database_Helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class OtpPage extends StatefulWidget {
  final int pid;
  OtpPage({required this.pid});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  TextEditingController _pinController = TextEditingController();
  String phonenumberdb = '+923096482000';
  final auth = FirebaseAuth.instance;
  late String _verificationId;

  String error = '';

  @override
  void initState() {
    super.initState();
    _sendOtp();
  }

  void _sendOtp() async {
    int phoneNumber = await DatabaseHelper.getPhoneNumber(widget.pid);
    phonenumberdb = '+' + phoneNumber.toString();
    print(
        'Num: $phonenumberdb ////////////////////////////////////////////////////////////////////////////////////////////////////');
    await auth.verifyPhoneNumber(
      phoneNumber: phonenumberdb,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        _navigateToHomePage();
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Verification Failed: ${e.message}');
        setState(() {
          error='Verification Failed, Try Again Later';
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      timeout: const Duration(seconds: 60),
    );
  }

  void _verifyOtp() async {
    String otp = _pinController.text.trim();
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );
      await auth.signInWithCredential(credential);
      _navigateToHomePage();
    } catch (e) {
      setState(() {
        error = 'Try Again';
      });
    }
  }

  void _navigateToHomePage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    prefs.setInt('userId', widget.pid);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Home_page(pid: widget.pid),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 200, left: 20, right: 20),
                child: HeaderText(label: 'Verify OTP'),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                  bottom: 100,
                ),
                child: BodyLabel(
                  label: 'Enter your 6-digit code',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: PinInputTextField(
                  pinLength: 6,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: _pinController,
                  decoration: UnderlineDecoration(
                    textStyle: const TextStyle(color: Colors.black),
                    colorBuilder: PinListenColorBuilder(
                      Colors.black,
                      Colors.black,
                    ),
                  ),
                  onSubmit: (pin) {
                    _verifyOtp();
                  },
                ),
              ),
              SizedBox(height: 8),
              Text(
                error,
                style: TextStyle(
                  color: Colors.red,
                ),
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: CustomElevatedButton(
                  onPressed: () {
                    _verifyOtp();
                  },
                  text: 'Submit',
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBackButton(),
    );
  }
}
